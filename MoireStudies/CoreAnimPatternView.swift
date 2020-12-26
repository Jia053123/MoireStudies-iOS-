//
//  CoreAnimPatternView.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-23.
//

import Foundation
import UIKit

class CoreAnimPatternView: PatternView, CAAnimationDelegate {
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
            self.resetAnimation()
        }
    }
    
    private var tileHeight: Double = 10.0
    private var tileLength: Double?
    private var numOfTile: Int = 0
    private var tiles: Array<TileLayer> = Array()
    private var lastTile: TileLayer? // keep track of the top tile to ensure the recycled tiles fit seamlessly
    private var backingView: UIView = UIView() // the view that holds all the tiles
    
    override func setUp() {
        self.backgroundColor = UIColor.clear
        let diagonalLength = Double(sqrt(pow(Float(self.frame.width), 2) + pow(Float(self.frame.height), 2)))
        //backingView = UIView(frame: CGRect(x: 0, y: 0, width: diagonalLength, height: diagonalLength))
        backingView.frame = CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height)
        backingView.backgroundColor = UIColor.white
        backingView.center = self.center
        self.addSubview(backingView)
        // the tiles are placed to fill the backing view
        tileLength = Double(backingView.frame.width)
        //numOfTile = Int(ceil(Double(bv.frame.height) / tileHeight)) + 1
        numOfTile = 20
        
        for i in 0..<numOfTile {
            let xPos : Double = Double(backingView.frame.width / 2)
            let yPos : Double = Double(i) * tileHeight
            
            let newTile = TileLayer()
            newTile.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            newTile.frame = CGRect(x: 0, y: 0, width: tileLength!, height: tileHeight)
            newTile.position = CGPoint(x: xPos, y: yPos)
            newTile.setUp(fillRatio: 0.5) // TODO
            backingView.layer.addSublayer(newTile)
            tiles.append(newTile)
            if i == numOfTile - 1 {
                lastTile = newTile
            }
        }
        self.animateTiles()
    }
    
    func animateTiles() {
        for t in tiles {
            self.animateTile(tile: t)
        }
    }
    
    func animateTile(tile: TileLayer) {
        // all tiles move towards the bottom of the frame at the same speed
        let remainingDistance: Double = Double(backingView.frame.height - tile.position.y)
        let duration = remainingDistance / self.pattern.speed
        let moveDownAnim = CABasicAnimation(keyPath: "position")
        moveDownAnim.fromValue = CGPoint(x: tile.position.x, y: tile.position.y)
        moveDownAnim.toValue = CGPoint(x: tile.position.x, y: backingView.frame.height)
        moveDownAnim.duration = duration
        moveDownAnim.delegate = self;
        moveDownAnim.fillMode = CAMediaTimingFillMode.forwards
        moveDownAnim.isRemovedOnCompletion = false
        moveDownAnim.setValue(tile, forKey: "tileLayer")
        tile.add(moveDownAnim, forKey: "move down")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("animation did stop")
        let tile: TileLayer? = anim.value(forKey: "tileLayer") as? TileLayer
        if let t = tile {
            t.position = CGPoint(x: Double(backingView.frame.width/2), y: Double(lastTile!.position.y) - tileHeight)
            t.removeAnimation(forKey: "move down")
            lastTile = t
            self.animateTile(tile: t)
        } else {
            print("no tile found for the key")
        }
    }
    
    func resetAnimation() {
        // interrupt animations and set model layers to presentation layers
        // animate with new settings
    }
    
    
}
