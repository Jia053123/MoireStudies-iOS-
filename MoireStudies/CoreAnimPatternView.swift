//
//  CoreAnimPatternView.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-23.
//

import Foundation
import UIKit

class CoreAnimPatternView: PatternView {
    private var tileHeight: Double = 10.0
    private var tileLength: Double = 0.0
    private var numOfTile: Int = 0
    private var tiles: Array<TileLayer> = Array()
    private var backingView: UIView? // the view that holds all the tiles
    
    override func setUp() {
        let diagonalLength = Double(sqrt(pow(Float(self.frame.width), 2) + pow(Float(self.frame.height), 2)))
        backingView = UIView(frame: CGRect(x: 0, y: 0, width: diagonalLength, height: diagonalLength))
        backingView?.center = self.center
        if let bv = backingView {
            self.addSubview(bv)
            // the tiles are placed to fill the backing view
            tileLength = Double(bv.frame.width)
            numOfTile = Int(ceil(Double(bv.frame.height) / tileHeight)) + 1
            
            for i in 1...numOfTile {
                let xPos : Double = Double(self.frame.width / 2)
                let yPos : Double = Double(i) * tileHeight
                
                let newTile = TileLayer()
                newTile.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                newTile.frame = CGRect(x: 0, y: 0, width: tileLength, height: tileHeight)
                newTile.position = CGPoint(x: xPos, y: yPos)
                newTile.setUp(fillRatio: 0.5) // TODO
                bv.layer.addSublayer(newTile)
                tiles.append(newTile)
            }
            self.animateTiles()
        }
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
