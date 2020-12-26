//
//  TileLayer.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-23.
//

import Foundation
import UIKit

class TileLayer: CALayer {
    
    func setUp(fillRatio: Double) {
        self.borderColor = UIColor.red.cgColor
        self.borderWidth = 1
    }
    
    deinit {
        self.delegate = nil // prevent retain cycle
    }
}
