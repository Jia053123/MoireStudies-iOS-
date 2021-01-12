//
//  PatternStore.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-05.
//

import Foundation
import UIKit

/**
 Summary: represent the model of a single moire
 */
class MoireModel: Codable {
    private var _id: String?
    var id: String {
        get {
            if let i = _id {
                return i
            } else {
                _id = UUID().uuidString
                return _id!
            }
        }
    }
    
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
    
    private var _previewData: Data?
    
    var preview: UIImage {
        get {
            guard let d = _previewData, let img = UIImage.init(data: d) else {
                return UIImage(systemName: "photo")!
            }
            return img
        }
        set {
            _previewData = newValue.pngData()
        }
    }
    
    func reset() {
        self._model = []
        self._model.append(Pattern.demoPattern1())
        self._model.append(Pattern.demoPattern2())
        _previewData = nil
    }
}
