//
//  MoireModel.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-12.
//

import Foundation

class LocalMoireModel: MoireModel {
    private var saveFileIO = SaveFileIO.init()
    
    func numOfMoires() -> Int {
        return saveFileIO.numOfMoire() ?? 0
    }
    
    func readAllMoiresSortedByLastCreatedOrModified() -> Array<Moire> {
        guard let ms = self.saveFileIO.readAllMoiresSortedByLastCreatedOrModified() else {
            return []
        }
        return ms.compactMap({$0})
    }
    
    func readAllMoiresSortedByLastCreated() -> Array<Moire> {
        guard let ms = self.saveFileIO.readAllMoiresSortedByLastCreated() else {
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
    
    func saveOrModify(moire: Moire) -> Bool {
        if self.read(moireId: moire.id) == nil {
            return self.saveFileIO.save(moire: moire)
        } else {
            return self.saveFileIO.modify(moire: moire)
        }
    }
    
    func createNewDemo() -> Moire {
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
    private let tempDirectory: URL
    private let saveFileDirectory: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    required init() {
        let documentsDirectory = fileManager.urls(for: FileManager.SearchPathDirectory.documentDirectory,
                                                  in: FileManager.SearchPathDomainMask.userDomainMask).first!
        tempDirectory = URL.init(fileURLWithPath: NSTemporaryDirectory())
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
        return saveFileUrl
    }
    
    private func makeTempSaveFileUrl(moireId: String) -> URL {
        let fileName = moireId + ".moire"
        let tempSaveFileUrl = tempDirectory.appendingPathComponent(fileName)
        return tempSaveFileUrl
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
    
    func modify(moire: Moire) -> Bool {
        let originalUrl = self.makeSaveFileUrl(moireId: moire.id)
        let tempSaveUrl = self.makeTempSaveFileUrl(moireId: moire.id)
        let encodedMoire = try! encoder.encode(moire)
        let success = fileManager.createFile(atPath: tempSaveUrl.path, contents: encodedMoire, attributes: nil)
        guard success else {
            return false
        }
        let newUrl: URL?
        do {
            newUrl = try fileManager.replaceItemAt(originalUrl, withItemAt: tempSaveUrl)
        } catch {
            return false
        }
        if newUrl == nil {
            return false
        } else {
            return true
        }
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
    
    /**
     LastCreatedOnly: if true, sort by only last created; otherwise sort by both criteria
     */
    private func allMoireUrlsSortedByLastCreatedOrModified(lastCreatedOnly: Bool) -> Array<URL>? {
        var urls: Array<URL>
        do {
            urls = try fileManager.contentsOfDirectory(at: saveFileDirectory,
                                                       includingPropertiesForKeys: [.attributeModificationDateKey,.creationDateKey],
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
                return greaterNonNil(a: md, b: cd)
            }
            let d0, d1: Date?
            if lastCreatedOnly {
                d0 = try? $0.resourceValues(forKeys: [.creationDateKey]).creationDate
                d1 = try? $1.resourceValues(forKeys: [.creationDateKey]).creationDate
            } else {
                d0 = dateToCompare(url: $0)
                d1 = dateToCompare(url: $1)
            }
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
    
    func readAllMoiresSortedByLastCreated() -> Array<Moire?>? {
        var moires: Array<Moire?> = []
        guard let urls = self.allMoireUrlsSortedByLastCreatedOrModified(lastCreatedOnly: true) else {
            return nil
        }
        for u in urls {
            moires.append(self.read(moireUrl: u) ?? nil)
        }
        return moires
    }
    
    func readAllMoiresSortedByLastCreatedOrModified() -> Array<Moire?>? {
        var moires: Array<Moire?> = []
        guard let urls = self.allMoireUrlsSortedByLastCreatedOrModified(lastCreatedOnly: false) else {
            return nil
        }
        for u in urls {
            moires.append(self.read(moireUrl: u) ?? nil)
        }
        return moires
    }
    
    func readLastCreatedOrModified() -> Moire? {
        if let url = self.allMoireUrlsSortedByLastCreatedOrModified(lastCreatedOnly: false)?.last {
            return self.read(moireUrl: url)
        } else {
            return nil
        }
    }
    
    func numOfMoire() -> Int? {
        guard let urls = self.allMoireUrlsSortedByLastCreatedOrModified(lastCreatedOnly: true) else {
            return nil
        }
        return urls.count
    }
    
    func deleteAll() -> Bool {
        guard let urls = self.allMoireUrlsSortedByLastCreatedOrModified(lastCreatedOnly: true) else {
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
