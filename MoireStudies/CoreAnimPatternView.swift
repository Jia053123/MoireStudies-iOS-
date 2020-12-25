//
//  CoreAnimPatternView.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-23.
//

import Foundation
import UIKit

class CoreAnimPatternView: PatternView {
    private var _pattern: Pattern?
    var pattern: Pattern {
        get {
            if let p = _pattern {
                return p
            } else {
                return Pattern.defaultPattern()
            }
        }
        set {
            _pattern = newValue
        }
    }
    
    private var tileHeight: Double = 10.0
    private var tileLength: Double?
    private var numOfTile: Int = 0
    private var tiles: Array<TileLayer> = Array()
    private var backingView: UIView? // the view that holds all the tiles
    
    override func setUp() {
        let diagonalLength = Double(sqrt(pow(Float(self.frame.width), 2) + pow(Float(self.frame.height), 2)))
        backingView = UIView(frame: CGRect(x: 0, y: 0, width: diagonalLength, height: diagonalLength))
        if let bv = backingView {
            bv.center = self.center
            self.addSubview(bv)
            // the tiles are placed to fill the backing view
            tileLength = Double(bv.frame.width)
            //numOfTile = Int(ceil(Double(bv.frame.height) / tileHeight)) + 1
            numOfTile = 20
            
            for i in 0..<numOfTile {
                let xPos : Double = Double(self.frame.width / 2)
                let yPos : Double = Double(i) * tileHeight
                
                let newTile = TileLayer()
                newTile.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                newTile.frame = CGRect(x: 0, y: 0, width: tileLength!, height: tileHeight)
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
        if let bv = backingView {
            // all tiles move towards the top of the frame. calc remaining distance
            let remainingDistance: Double = Double(bv.frame.height - tile.position.y)
            // calculate duration from the distance so that speed is fixed
            let duration = remainingDistance / self.pattern.speed
            // animate and recycle the tile at the end of the animation
            let moveUpAnim = CABasicAnimation(keyPath: "position")
            moveUpAnim.fromValue = CGPoint(x: tile.position.x, y: tile.position.y)
            moveUpAnim.toValue = CGPoint(x: tile.position.x, y: bv.frame.height)
            moveUpAnim.duration = duration
            tile.add(moveUpAnim, forKey: "move up")
        }
    }
}
