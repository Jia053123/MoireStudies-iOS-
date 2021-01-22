//
//  MoireModel.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-12.
//

import Foundation

class MoireModel {
    private var saveFileIO = SaveFileIO.init()
    
    func numOfMoires() -> Int {
        return saveFileIO.numOfMoire() ?? 0
    }
    
    /**
     returns:  a sorted array of moires sorted in ascending order by its creation date or modification date, whichever comes later
     */
    func readAllMoiresSortedByLastCreatedOrModified() -> Array<Moire> {
        guard let ms = self.saveFileIO.readAllMoiresSortedByLastCreatedOrModified() else {
            return []
        }
        return ms.compactMap({$0})
    }
    
    func read(moireId: String) -> Moire? {
        return self.saveFileIO.read(moireId: moireId)
    }
    
    func readLastCreatedOrEdited() -> Moire? {
        return saveFileIO.readLastCreatedOrModified()
    }
    
    func save(moire: Moire) -> Bool {
        return self.saveFileIO.save(moire: moire)
    }
    
    func createNew() -> Moire {
        let newM = Moire()
        _ = self.saveFileIO.save(moire: newM)
        return newM
    }
    
    func delete(moireId: String) -> Bool {
        return self.saveFileIO.delete(moireId: moireId)
    }
    
    func deleteAllSaves() -> Bool {
        return self.saveFileIO.deleteAll()
    }
}

fileprivate class SaveFileIO {
    private let fileManager: FileManager = FileManager.default
    private let saveFileDirectory: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    required init() {
        let documentsDirectory = fileManager.urls(for: FileManager.SearchPathDirectory.documentDirectory,
                                                  in: FileManager.SearchPathDomainMask.userDomainMask).first!
        saveFileDirectory = documentsDirectory.appendingPathComponent("MoireSaveFiles")
//        print("saveFileDirectory: " + saveFileDirectory.path)
        var isDirectory: ObjCBool = ObjCBool(false)
        let fileExists = fileManager.fileExists(atPath: saveFileDirectory.path, isDirectory: &isDirectory)
        if !fileExists || !isDirectory.boolValue  {
            print("save file directory doesn't exist; creating directory")
            try! fileManager.createDirectory(at: saveFileDirectory, withIntermediateDirectories: true, attributes: nil)
        } else {
            print("save file directory already exists")
        }
    }
    
    private func makeSaveFileUrl(moireId: String) -> URL {
        let fileName = moireId + ".moire"
        let saveFileUrl = saveFileDirectory.appendingPathComponent(fileName)
//        print("made file url: " + saveFileUrl.path)
        return saveFileUrl
    }
    
    private func read(moireUrl: URL) -> Moire? {
        do {
            let moireData = try Data.init(contentsOf: moireUrl)
            let moire = try decoder.decode(Moire.self, from: moireData)
            return moire
        } catch {
            print("IO ERROR: reading moire file from disk failed")
            return nil
        }
    }
    
    func read(moireId: String) -> Moire? {
        let url = makeSaveFileUrl(moireId: moireId)
        return self.read(moireUrl: url)
    }
    
    func save(moire: Moire) -> Bool {
        let url = self.makeSaveFileUrl(moireId: moire.id)
        let encodedMoire = try! encoder.encode(moire)
        let success = fileManager.createFile(atPath: url.path, contents: encodedMoire, attributes: nil)
        if !success {
            print("IO ERROR: creating file failed")
        }
        return success
    }
    
    private func delete(moireUrl: URL) -> Bool {
        do {
            try fileManager.removeItem(at: moireUrl)
            return true
        } catch {
            print("IO ERROR: deleting moire file from disk failed")
            return false
        }
    }
    
    func delete(moireId: String) -> Bool {
        let url = self.makeSaveFileUrl(moireId: moireId)
        return self.delete(moireUrl: url)
    }
    
    private func allMoireUrlsSortedByLastCreatedOrModified() -> Array<URL>? {
        var urls: Array<URL>
        do {
            urls = try fileManager.contentsOfDirectory(at: saveFileDirectory,
                                                           includingPropertiesForKeys: [.attributeModificationDateKey,
                                                                                        .creationDateKey],
                                                           options:.skipsHiddenFiles)
        } catch {
            print("IO ERROR: accessing directory from disk failed")
            return nil
        }
            
        urls.sort(by: {
            func greaterNonNil<T: Comparable>(a: T?, b: T?) -> T? {
                // in the case a = b, and neither value is nil, a is the output
                if let nonNilA = a, let nonNilB = b {
                    if nonNilA >= nonNilB {
                        return nonNilA
                    } else {
                        return nonNilB
                    }
                } else {
                    return a ?? b
                }
            }
            func dateToCompare(url: URL) -> Date? {
                let md = try? url.resourceValues(forKeys: [.attributeModificationDateKey]).attributeModificationDate
                let cd = try? url.resourceValues(forKeys: [.creationDateKey]).creationDate
                return greaterNonNil(a: md, b: cd) // give modification date prority when it's the same as the creation date
            }
            let d0 = dateToCompare(url: $0)
            let d1 = dateToCompare(url: $1)
            if let greaterD = greaterNonNil(a: d1, b: d0) {
                if greaterD == d0 {
                    return false
                } else {
                    assert(greaterD == d1)
                    return true
                }
            } else {
                return true
            }
        })
        return urls.compactMap({$0.absoluteString.hasSuffix(".moire") ? $0 : nil})
    }
    
    func readAllMoiresSortedByLastCreatedOrModified() -> Array<Moire?>? {
        var moires: Array<Moire?> = []
        guard let urls = self.allMoireUrlsSortedByLastCreatedOrModified() else {
            return nil
        }
        for u in urls {
            moires.append(self.read(moireUrl: u) ?? nil)
        }
        return moires
    }
    
    func readLastCreatedOrModified() -> Moire? {
        if let url = self.allMoireUrlsSortedByLastCreatedOrModified()?.last {
            return self.read(moireUrl: url)
        } else {
            return nil
        }
    }
    
    func numOfMoire() -> Int? {
        guard let urls = self.allMoireUrlsSortedByLastCreatedOrModified() else {
            return nil
        }
        return urls.count
    }
    
    func deleteAll() -> Bool {
        guard let urls = self.allMoireUrlsSortedByLastCreatedOrModified() else {
            return false
        }
        var success: Bool = true
        for u in urls {
            let s = self.delete(moireUrl: u)
            success = success && s
        }
        return success
    }
}
