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
    private var tileLength : Double = 0.0
    private var numOfTile : Int = 0
    private var tiles : Array<TileLayer> = Array()
    
    override func setUp() {
        // the tiles are placed to fill the view
        tileLength = Double(self.frame.width)
        numOfTile = Int(ceil(Double(tileLength) / tileHeight)) + 1
        
        for i in 1...numOfTile {
            let xPos : Double = Double(self.frame.width / 2)
            let yPos : Double = Double(i) * tileHeight
            
            let newTile = TileLayer()
            newTile.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            newTile.frame = CGRect(x: 0, y: 0, width: tileLength, height: tileHeight)
            newTile.position = CGPoint(x: xPos, y: yPos)
            newTile.setUp(fillRatio: 0.5) // TODO
            self.layer.addSublayer(newTile)
            tiles.append(newTile)
        }
        self.animateTiles()
    }
    
    func animateTiles() {
        for t in tiles {
            self.animateTile(tile: t)
        }
    }
    
    func animateTile(tile: TileLayer) {
        // calculate distance till the end of the frame
        // calculate duration from distance so that speed is fixed
    }
}
