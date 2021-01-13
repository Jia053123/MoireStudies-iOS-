//
//  MoireModel.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-12.
//

import Foundation

class MoireModel {
    private var _model: Array<Moire> = []
    var model: Array<Moire> {
        get {
            if _model.isEmpty {
                self.reset()
            }
            return _model
        }
        set {
            _model = newValue
        }
    }
    
    required init() {
        guard let _m = SaveFileIO.readSavedMoires() else {return}
        _model = _m
    }
    
    func saveAndCreateNew(moireToSave: Moire) -> Moire {
        try? SaveFileIO.saveOrUpdate(moire: moireToSave)
        let newM = Moire()
        _model.append(newM)
        return newM
    }
    
    func reset() {
        self._model = []
        self._model.append(Moire())
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
