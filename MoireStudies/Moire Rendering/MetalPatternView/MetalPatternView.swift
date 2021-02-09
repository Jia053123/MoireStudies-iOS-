//
//  OpenGLPatternView.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-23.
//

import Foundation
import UIKit
import MetalKit

class MetalPatternView: UIView {
    override class var layerClass: AnyClass {get {return CAMetalLayer.self}}
    weak var delegate: MetalPatternViewController?
    private var displayLink: CADisplayLink?
    
    func setup(delegate: MetalPatternViewController) {
        self.accessibilityIdentifier = "MetalPatternView"
        self.backgroundColor = UIColor.clear
        (self.layer as! CAMetalLayer).drawableSize = CGSize.init(width: self.bounds.size.width * UIScreen.main.scale,
                                                                 height: self.bounds.size.height * UIScreen.main.scale)
        self.layer.contentsScale = UIScreen.main.scale
        self.setupDisplayLink()
        self.delegate = delegate
    }
    
    private func setupDisplayLink() {
        self.displayLink?.invalidate()
        self.displayLink = CADisplayLink(target: self, selector: #selector(render))
//        self.displayLink!.preferredFramesPerSecond = 60
        self.displayLink!.add(to: RunLoop.main, forMode: .default)
    }
    
    func invalidateDisplayLink() {
        self.displayLink?.invalidate()
    }
    
    @objc private func render() {
        self.delegate!.render(frameDuration: self.displayLink!.targetTimestamp - self.displayLink!.timestamp)
    }

    func pauseDisplayLink() {
        self.displayLink!.isPaused = true
    }
    
    func resumeDisplayLink() {
        self.displayLink!.isPaused = false
    }
}

