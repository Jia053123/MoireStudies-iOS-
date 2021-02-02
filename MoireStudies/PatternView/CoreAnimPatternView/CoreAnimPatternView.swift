//
//  CoreAnimPatternView.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-23.
//

import Foundation
import UIKit

class CoreAnimPatternView: UIView {
    private var pattern: Pattern = Pattern.defaultPattern() // TODO: use ! instead
    private var tileHeight: CGFloat = Constants.UI.tileHeight
    private var tileLength: CGFloat?
    private var numOfTile: Int = 0
    private var tiles: Array<TileLayer> = Array()
    private var lastTile: TileLayer? // keep track of the tile at the end to ensure the next recycled tile fit seamlessly
    private var backingView: UIView = UIView() // the view that holds all the tiles
    private var backingViewDefaultTransf: CGAffineTransform = CGAffineTransform()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    
    func setUp() {
        self.accessibilityIdentifier = "CoreAnimPatternView"
    }
    
    private func createTiles() {
        let fr = Utilities.convertToFillRatioAndScaleFactor(blackWidth: pattern.blackWidth, whiteWidth: pattern.whiteWidth).fillRatio
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
            newTile.setUp(fillRatio: fr)
            backingView.layer.addSublayer(newTile)
            tiles.append(newTile)
            if i == 0 {
                lastTile = newTile
            }
        }
    }
    
    private func animateTile(tile: TileLayer) {
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
    
    func animateTiles() {
        for t in tiles {
            self.animateTile(tile: t)
        }
    }
    
    /**
     Summary: Set model layers to presentation layers, interrupt animations and redo animations
     */
    func reAnimateTiles() {
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
}

extension CoreAnimPatternView: PatternView {
    func setUpAndRender(pattern: Pattern) {
        self.backgroundColor = UIColor.clear
        let diagonalLength = Double(sqrt(pow(Float(self.bounds.width), 2) + pow(Float(self.bounds.height), 2)))
        backingView.frame = CGRect(x: 0, y: 0, width: diagonalLength, height: diagonalLength)
//        backingView.frame = CGRect(x: 0, y: 0, width: self.bounds.height, height: self.bounds.height) //uncomment to show the whole backing view for debuging
        backingView.center = self.center
        self.addSubview(backingView)
        backingViewDefaultTransf = backingView.transform
        self.createTiles()
        self.animateTiles()
        self.updatePattern(newPattern: pattern)
    }
    
    func updatePattern(newPattern: Pattern) {
        let oldPattern = self.pattern
        self.pattern = newPattern
        if oldPattern.speed != newPattern.speed {
            self.reAnimateTiles()
        }
        let oldR = Utilities.convertToFillRatioAndScaleFactor(blackWidth: oldPattern.blackWidth,
                                                              whiteWidth: oldPattern.whiteWidth)
        let newR = Utilities.convertToFillRatioAndScaleFactor(blackWidth: newPattern.blackWidth,
                                                              whiteWidth: newPattern.whiteWidth)
        if oldPattern.direction != newPattern.direction || oldR.scaleFactor != newR.scaleFactor {
            backingView.transform =
                backingViewDefaultTransf.rotated(by: newPattern.direction).scaledBy(x: newR.scaleFactor, y: newR.scaleFactor)
        }
        if oldR.fillRatio != newR.fillRatio {
            for tile in tiles {
                tile.fillRatio = newR.fillRatio
            }
        }
    }
    
    func pauseAnimations() {
        // official Apple code
        let layer = self.layer
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0 // sets the layer's time 0
        layer.timeOffset = pausedTime // add pausedTime to the layer's time, and now layer's time is pausedTime
    }

    func resumeAnimations() {
        // official Apple code
        let layer = self.layer
        let pausedTime = layer.timeOffset
        layer.speed = 1.0 // add current time to the layer's time
        layer.timeOffset = 0.0 // minus pausedTime from the layer's time, and now layer's time is the current time
        layer.beginTime = 0.0 // assign this for now so that convertTime work correctly
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause // minus timeSincePause from the layer's time, and now layer's time is pausedTime
    }
}

extension CoreAnimPatternView: CAAnimationDelegate {
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
                print("no tile found for the key or no lastTile")
            }
        }
    }
}
