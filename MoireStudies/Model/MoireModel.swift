//
//  MoireModel.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-12.
//

import Foundation

class MoireModel {
    private var _moires: Array<Moire> = []
    var moires: Array<Moire> {
        get {
            if _moires.isEmpty {
                _ = self.createNew()
            }
            return _moires
        }
    }
    
    required init() {
        guard let _m = SaveFileIO.readSavedMoires() else {return}
        _moires = _m
    }
    
    func numOfMoires() -> Int {
        return _moires.count
    }
    
    func load(moireIndex: Int) -> Moire? {
        return nil
    }
    
    func load(moireId: String) -> Moire? {
        return nil
    }
    
    func saveOrUpdate(moire: Moire) throws {
        try SaveFileIO.saveOrUpdate(moire: moire)
    }
    
    func createNew() -> Moire {
        let newM = Moire()
        _moires.append(newM)
        return newM
    }
    
    func delete(moireId: String) -> Bool {
        return false
    }
    
    func deleteAll() {
        self._moires = []
    }
}

fileprivate class SaveFileIO {
    static func readSavedMoires() -> Array<Moire>? {
        print("TODO: read moires")
        return nil
    }
    
    static func saveOrUpdate(moire: Moire) throws {
        // check with id whether the moire is new
        print("TODO: save moire")
    }
    
    static func deleteMoire(id: String) throws {
        print("TODO: delete moire")
    }
}
