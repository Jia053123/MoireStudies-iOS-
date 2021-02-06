//
//  CustomDisplayLink.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-02-06.
//

import Foundation
import UIKit

/**
 Summary: a wrapper wround CADisplayLInk to calculate actual frame duration
 */
class DisplayLinkWrapper: NSObject {
    private var displayLink: CADisplayLink!
    private var target: NSObject!
    private var selector: Selector!
    private var previousTimeStamp: CFTimeInterval?
    private var _frameDuration: CFTimeInterval?
    var frameDuration: CFTimeInterval? {get {return self._frameDuration}}
    
    required init(target: NSObject, selector: Selector, frameRate: Int) {
        super.init()
        if let dl = self.displayLink {
            dl.invalidate()
        }
        self.target = target
        self.selector = selector
        self.displayLink = CADisplayLink(target: self, selector: #selector(tick))
        self.displayLink.preferredFramesPerSecond = frameRate
        self.displayLink.add(to: RunLoop.main, forMode: .default)
    }
    
    @objc private func tick() {
        let timeStamp = CACurrentMediaTime()
        if let pts = self.previousTimeStamp {
            self._frameDuration = timeStamp - pts
        }
        self.previousTimeStamp = timeStamp
        self.target.perform(self.selector)
    }
}
