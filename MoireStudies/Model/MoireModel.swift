//
//  MoireModel.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-12.
//

import Foundation

class MoireModel: Codable {
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
    
    func reset() {
        self._model = []
        self._model.append(Moire())
    }
}
