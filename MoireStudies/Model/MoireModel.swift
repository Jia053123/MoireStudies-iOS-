//
//  MoireModel.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-12.
//

import Foundation

class MoireModel {
    private var saveFileIO = SaveFileIO.init()
    var moires: Array<Moire> { // TODO: rename to currentMoires?
        get {
            if self.numOfMoires() == 0 {
                _ = self.createNew()
            }
            return []//self.allMoires()
        }
    }
    
    func numOfMoires() -> Int {
        return saveFileIO.numOfMoire() ?? 0
    }
    
//    func allMoires() -> Array<Moire> {
//        guard let ms = saveFileIO.readAllMoiresSortedBy(key: nil) else {
//            return []
//        }
//        return ms.compactMap({$0})
//    }
    
//    func open(moireId: String) -> Moire? {
//        return self.saveFileIO.read(moireId: moireId)
//    }
    
//    func openLastEdited() -> Moire? {
//        do {
//            let num = try fileManager.contentsOfDirectory(at: saveFileDirectory,
//                                                          includingPropertiesForKeys: [],
//                                                          options: []).count
//        }
//    }
    
//    func saveOrUpdate(moire: Moire) {
//        _ = self.saveFileIO.save(moire: moire)
//    }
    
    func createNew() -> Moire {
        print("create new")
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
        print("saveFileDirectory: " + saveFileDirectory.path)
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
        let fileName = "MOIRE-" + moireId + ".json"
        print("made file name: " + fileName)
        let saveFileUrl = saveFileDirectory.appendingPathComponent(fileName)
        print("made file url: " + saveFileUrl.path)
        return saveFileUrl
    }
    
//    private func read(moireUrl: URL) -> Moire? {
//        do {
//            let moireData = try Data.init(contentsOf: moireUrl)
//            let moire = try decoder.decode(Moire.self, from: moireData)
//            return moire
//        } catch {
//            print("IO ERROR: reading moire file from disk failed")
//            return nil
//        }
//    }
    
//    func read(moireId: String) -> Moire? {
//        let url = makeSaveFileUrl(moireId: moireId)
//        return self.read(moireUrl: url)
//    }
    
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
    
    func allMoireUrls() -> Array<URL>? {
        do {
            let urls = try fileManager.contentsOfDirectory(at: saveFileDirectory,
                                                          includingPropertiesForKeys: [],
                                                          options: [])
            return urls.filter({$0.lastPathComponent.hasPrefix("MOIRE-")})
        } catch {
            print("IO ERROR: accessing directory from disk failed")
            return nil
        }
    }
    
    func numOfMoire() -> Int? {
        guard let urls = self.allMoireUrls() else {
            return nil
        }
        return urls.count
    }
    
    func deleteAll() -> Bool {
        guard let urls = self.allMoireUrls() else {
            return false
        }
        var success: Bool = true
        for u in urls {
            let s = self.delete(moireUrl: u)
            success = success && s
        }
        return success
    }
    
//    func readAllMoiresSortedBy(key: URLResourceKey?) -> Array<Moire?>? {
//        var moires: Array<Moire?> = []
//        do {
//            // TODO: work with the key
//            let urls = try fileManager.contentsOfDirectory(at: saveFileDirectory,
//                                                           includingPropertiesForKeys: [],
//                                                           options: [])
//            for u in urls {
//                moires.append(self.read(moireUrl: u) ?? nil)
//            }
//            return moires
//        } catch {
//            print("IO ERROR: accessing files from disk failed")
//            return nil
//        }
//    }
}
