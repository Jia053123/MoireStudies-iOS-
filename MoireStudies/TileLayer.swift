//
//  TileLayer.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-23.
//

import Foundation
import UIKit

class TileLayer: CALayer {
    private let fillLayer = CALayer()
    private var _fillRatio: CGFloat = 0.5
    var fillRatio : CGFloat {
        get {
            return self._fillRatio
        }
        set {
            assert(fillRatio > 0 && fillRatio <= 1)
            self._fillRatio = newValue
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            fillLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height * CGFloat(fillRatio))
            CATransaction.commit()
        }
    }
    
    func setUp(fillRatio: CGFloat) {
        self.backgroundColor = UIColor.clear.cgColor
        assert(fillRatio > 0 && fillRatio <= 1)
        fillLayer.backgroundColor = UIColor.black.cgColor
        fillLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height * CGFloat(fillRatio))
        self.fillRatio = fillRatio
        self.addSublayer(fillLayer)
    }
    
    deinit {
        self.delegate = nil // prevent retain cycle
    }
}
