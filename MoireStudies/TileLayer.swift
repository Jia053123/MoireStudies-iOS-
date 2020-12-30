//
//  TileLayer.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-23.
//

import Foundation
import UIKit

class TileLayer: CALayer {
    let fillLayer = CALayer()
    
    func setUp(fillRatio: Double) {
//        self.borderColor = UIColor.red.cgColor
//        self.borderWidth = 1 // uncomment for debug
        assert(fillRatio > 0 && fillRatio <= 1)
        fillLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height * CGFloat(fillRatio))
        fillLayer.backgroundColor = UIColor.black.cgColor
        self.addSublayer(fillLayer)
    }
    
    deinit {
        self.delegate = nil // prevent retain cycle
    }
}
