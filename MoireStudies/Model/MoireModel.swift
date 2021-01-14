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
            return self.allMoires()
        }
    }
    
    func numOfMoires() -> Int {
        return saveFileIO.numOfMoire() ?? 0
    }
    
    func allMoires() -> Array<Moire> {
        guard let ms = saveFileIO.readAllMoires() else {
            return []
        }
        return ms.compactMap({$0})
    }
    
    func open(moireId: String) -> Moire? {
        return self.saveFileIO.read(moireId: moireId)
    }
    
    func saveOrUpdate(moire: Moire) {
        self.saveFileIO.save(moire: moire)
    }
    
    func createNew() -> Moire {
        let newM = Moire()
        self.saveFileIO.save(moire: newM)
        return newM
    }
    
    func delete(moireId: String) -> Bool {
        return self.saveFileIO.delete(moireId: moireId)
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
        var isDirectory: ObjCBool = ObjCBool(false)
        let fileExists = fileManager.fileExists(atPath: saveFileDirectory.absoluteString, isDirectory: &isDirectory)
        if !fileExists || !isDirectory.boolValue  {
            try! fileManager.createDirectory(at: saveFileDirectory, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    private func makeSaveFileUrl(moireId: String) -> URL {
        let fileName = moireId + ".json"
        return saveFileDirectory.appendingPathComponent(fileName)
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
    
    func save(moire: Moire) {
        let url = self.makeSaveFileUrl(moireId: moire.id)
        let encodedMoire = try! encoder.encode(moire)
        fileManager.createFile(atPath: url.absoluteString, contents: encodedMoire, attributes: nil)
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
    
    func numOfMoire() -> Int? {
        do {
            let num = try fileManager.contentsOfDirectory(at: saveFileDirectory,
                                                          includingPropertiesForKeys: [],
                                                          options: []).count
            return num
        } catch {
            print("IO ERROR: accessing directory from disk failed")
            return nil
        }
    }
    
    func readAllMoires() -> Array<Moire?>? {
        var moires: Array<Moire?> = []
        do {
            let urls = try fileManager.contentsOfDirectory(at: saveFileDirectory,
                                                           includingPropertiesForKeys: [],
                                                           options: [])
            for u in urls {
                moires.append(self.read(moireUrl: u) ?? nil)
            }
            return moires
        } catch {
            print("IO ERROR: accessing files from disk failed")
            return nil
        }
    }
}
