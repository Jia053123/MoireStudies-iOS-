//
//  CoreAnimPatternView.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-23.
//

import Foundation
import UIKit

class CoreAnimPatternView: UIView, PatternView, CAAnimationDelegate {
    private var pattern: Pattern = Pattern.defaultPattern()
    private var tileHeight: CGFloat = Constants.UI.tileHeight
    private var tileLength: CGFloat?
    private var numOfTile: Int = 0
    private var tiles: Array<TileLayer> = Array()
    private var lastTile: TileLayer? // keep track of the top tile to ensure the recycled tiles fit seamlessly
    private var backingView: UIView = UIView() // the view that holds all the tiles
    private var backingViewDefaultTransf: CGAffineTransform = CGAffineTransform()
    
    func setUpAndRender(pattern: Pattern) {
        self.backgroundColor = UIColor.clear
        let diagonalLength = Double(sqrt(pow(Float(self.bounds.width), 2) + pow(Float(self.bounds.height), 2)))
        backingView.frame = CGRect(x: 0, y: 0, width: diagonalLength, height: diagonalLength)
        //backingView.frame = CGRect(x: 0, y: 0, width: self.bounds.height, height: self.bounds.height) //uncomment to show the whole backing view for debug
        backingView.center = self.center
        self.addSubview(backingView)
        backingViewDefaultTransf = backingView.transform
        self.createTiles()
        self.animateTiles()
        self.updatePattern(newPattern: pattern)
    }
    
    private func createTiles() {
        // the tiles are placed to fill the backing view
        tileLength = backingView.bounds.width
        numOfTile = Int(ceil(backingView.bounds.height / tileHeight)) + 1
        
        for i in 0..<numOfTile {
            let xPos : CGFloat = backingView.bounds.width / 2.0
            let yPos : CGFloat = CGFloat(i) * tileHeight
            
            let newTile = TileLayer()
            newTile.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            newTile.frame = CGRect(x: 0, y: 0, width: tileLength!, height: tileHeight)
            newTile.position = CGPoint(x: xPos, y: yPos)
            newTile.setUp(fillRatio: pattern.fillRatio)
            backingView.layer.addSublayer(newTile)
            tiles.append(newTile)
            if i == 0 {
                lastTile = newTile
            }
        }
    }
    
    func updatePattern(newPattern: Pattern) {
        let oldPattern = self.pattern
        self.pattern = newPattern
        if oldPattern.speed != newPattern.speed {
            // set model layers to presentation layers and interrupt animations
            for tile in tiles {
                if let pl = tile.presentation() {
                    tile.position = pl.position
                }
            }
            for tile in tiles {
                tile.removeAnimation(forKey: "move down")
            }
            self.animateTiles()
        }
        
        if oldPattern.direction != newPattern.direction || oldPattern.zoomRatio != newPattern.zoomRatio {
            backingView.transform =
                backingViewDefaultTransf.rotated(by: CGFloat(newPattern.direction)).scaledBy(x: CGFloat(newPattern.zoomRatio), y: CGFloat(newPattern.zoomRatio))
        }
        
        if oldPattern.fillRatio != newPattern.fillRatio {
            for tile in tiles {
                tile.fillRatio = newPattern.fillRatio
            }
        }
    }
    
    func animateTiles() {
        for t in tiles {
            self.animateTile(tile: t)
        }
    }
    
    func animateTile(tile: TileLayer) {
        // all tiles move towards the bottom of the backing view at the same speed
        let remainingDistance: CGFloat = backingView.bounds.height - tile.position.y
        let duration = remainingDistance / self.pattern.speed
        let moveDownAnim = CABasicAnimation(keyPath: "position")
        moveDownAnim.fromValue = CGPoint(x: tile.position.x, y: tile.position.y)
        moveDownAnim.toValue = CGPoint(x: tile.position.x, y: backingView.bounds.height)
        moveDownAnim.duration = CFTimeInterval(duration)
        moveDownAnim.delegate = self;
        moveDownAnim.fillMode = CAMediaTimingFillMode.forwards
        moveDownAnim.isRemovedOnCompletion = false
        moveDownAnim.setValue(tile, forKey: "tileLayer")
        tile.add(moveDownAnim, forKey: "move down")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if (flag) { // in case this method is triggered by removing the animation
            let tile: TileLayer? = anim.value(forKey: "tileLayer") as? TileLayer
            if let t = tile, let lt = lastTile {
                t.position = CGPoint(x: backingView.bounds.width/2.0,
                                     y: (lt.presentation()?.position.y ?? lt.position.y) - tileHeight)
                t.removeAnimation(forKey: "move down")
                lastTile = t
                self.animateTile(tile: t)
            } else {
                print("no tile found for the key")
            }
        }
    }
}
