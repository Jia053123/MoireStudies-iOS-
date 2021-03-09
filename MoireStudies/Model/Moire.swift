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
    let id: String!
    var patterns: Array<Pattern> = []
    
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
    
    init(id: String = UUID().uuidString) {
        self.id = id
    }
    
    func resetData() {
        self.patterns = []
        _previewData = nil
    }
    
    /// two moires are equal iff their IDs are identical and their patterns are equal and in the same order
    static func == (lhs: Moire, rhs: Moire) -> Bool {
        return (lhs.id == rhs.id) && (lhs.patterns == rhs.patterns)
    }
}

extension Moire: NSCopying {
    /// new object posesses copy of ID and patterns. previewData is not copied
    func copy(with zone: NSZone? = nil) -> Any {
        let copiedMoire = Moire.init(id: self.id)
        copiedMoire.patterns = self.patterns
        return copiedMoire
    }
}
