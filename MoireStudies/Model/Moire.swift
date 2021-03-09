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
class Moire: Codable, Equatable {
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
    
    private var _patterns: Array<Pattern> = []
    var patterns: Array<Pattern> { 
        get {
            if _patterns.isEmpty {
                self.resetAndInit()
            }
            return _patterns
        }
        set {
            _patterns = newValue
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
    
    func resetAndInit() {
        self._patterns = []
        self._patterns.append(Pattern.demoPattern1())
        self._patterns.append(Pattern.demoPattern2())
        _previewData = nil
    }
    
    /// two moires are equal iff their IDs are identical and their patterns are equal and in the same order
    static func == (lhs: Moire, rhs: Moire) -> Bool {
        return (lhs.id == rhs.id) && (lhs.patterns == rhs.patterns)
    }
}
