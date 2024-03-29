//
//  AbstractHighDegCtrlViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-05-08.
//

import Foundation
import UIKit

protocol AbstractHighDegCtrlViewController: HighDegCtrlViewController {
    var id: String! { get set }
}

/// the index parameters are from the POV of this class. E.g. if this class controlls 3 patterns, then their indexes are respectively 0,1,2
extension AbstractHighDegCtrlViewController {
    func modifyPattern(index: Int, speed: CGFloat) -> Bool {
        guard var currentPatterns = self.patternsDelegate.retrievePatterns(callerId: self.id)
        else {return false}
        guard index >= 0 && index < currentPatterns.count else {return false}
        currentPatterns[index].speed = speed
        return self.patternsDelegate.modifyPatterns(modifiedPatterns: currentPatterns, callerId: self.id)
    }
    
    func modifyPattern(index: Int, direction: CGFloat) -> Bool {
        guard var currentPatterns = self.patternsDelegate.retrievePatterns(callerId: self.id)
        else {return false}
        guard index >= 0 && index < currentPatterns.count else {return false}
        currentPatterns[index].direction = direction
        return self.patternsDelegate.modifyPatterns(modifiedPatterns: currentPatterns, callerId: self.id)
    }
    
    func modifyPattern(index: Int, blackWidth: CGFloat) -> Bool {
        guard var currentPatterns = self.patternsDelegate.retrievePatterns(callerId: self.id)
        else {return false}
        guard index >= 0 && index < currentPatterns.count else {return false}
        currentPatterns[index].blackWidth = blackWidth
        return self.patternsDelegate.modifyPatterns(modifiedPatterns: currentPatterns, callerId: self.id)
    }
    
    func modifyPattern(index: Int, whiteWidth: CGFloat) -> Bool {
        guard var currentPatterns = self.patternsDelegate.retrievePatterns(callerId: self.id)
        else {return false}
        guard index >= 0 && index < currentPatterns.count else {return false}
        currentPatterns[index].whiteWidth = whiteWidth
        return self.patternsDelegate.modifyPatterns(modifiedPatterns: currentPatterns, callerId: self.id)
    }
}
