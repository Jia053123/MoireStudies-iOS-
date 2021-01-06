//
//  PatternStore.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-05.
//

import Foundation

class MoireModel: Codable {
    private var _model: Array<Pattern> = []
    var model: Array<Pattern> {
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
        self._model.append(Pattern.demoPattern1())
        self._model.append(Pattern.demoPattern2())
    }
}
