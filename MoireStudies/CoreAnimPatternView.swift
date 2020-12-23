//
//  CoreAnimPatternView.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-23.
//

import Foundation
import UIKit

class CoreAnimPatternView: PatternView {
    private var tileHeight : Double = 10.0
    private var tileLength : Double?
    private var numOfTile : Int?
    
    override func setUp() {
        tileLength = Double(sqrt(pow(Float(self.frame.width), 2) + pow(Float(self.frame.height), 2)))
        if let tileLength = tileLength {
            numOfTile = Int(ceil(Double(tileLength) / tileHeight))
            if let numOfTile = numOfTile {
                for i in 1...numOfTile {
                    let xPos : Double = Double(self.frame.width / 2)
                    let yPos : Double = Double(i) * tileHeight
                    
                    let newTile = TileLayer()
                    newTile.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                    newTile.frame = CGRect(x: 0, y: 0, width: tileLength, height: tileHeight)
                    newTile.position = CGPoint(x: xPos, y: yPos)
                    newTile.setUp(fillRatio: 0.5)
                    self.layer.addSublayer(newTile)
                }
            }
        }
    }
}
