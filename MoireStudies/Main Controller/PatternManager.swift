//
//  PatternManager.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-02.
//

import Foundation
import UIKit

/// these functions return false when the action is illegal, otherwise they return true and the action is performed
class PatternManager: NSObject {
    private(set) var ctrlAndPatternMatcher = CtrlAndPatternMatcher()
    
    func highlightPattern(callerId: String) -> Bool {
        guard let index = self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.first else {return false}
        self.moireViewController.highlightPatternView(patternViewIndex: index)
        return true
    }
    
    func unhighlightPattern(callerId: String) -> Bool {
        guard let index = self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.first else {return false}
        self.moireViewController.unhighlightPatternView(patternViewIndex: index)
        return true
    }
    
    func dimPattern(callerId: String) -> Bool {
        guard let index = self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.first else {return false}
        self.moireViewController.dimPatternView(patternViewIndex: index)
        return true
    }
    
    func undimPattern(callerId: String) -> Bool {
        guard self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId) != nil else {return false}
        self.moireViewController.undimPatternViews()
        return true
    }
    
    func modifyPattern(speed: CGFloat, callerId: String) -> Bool {
//        print("setting speed to: ", speed)
        guard BoundsManager.speedRange.contains(speed) else {
            print("speed out of bound")
            return false
        }
        guard let index = self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.first else {
            return false
        }
        currentMoire!.patterns[index].speed = speed
        self.moireViewController.modifyPatternView(patternViewIndex: index, newPattern: currentMoire!.patterns[index])
        return true
    }
    
    func modifyPattern(direction: CGFloat, callerId: String) -> Bool {
        guard BoundsManager.directionRange.contains(direction) else {
            print("direction out of bound")
            return false
        }
        guard let index = self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.first else {
            return false
        }
        currentMoire!.patterns[index].direction = direction
        self.moireViewController.modifyPatternView(patternViewIndex: index, newPattern: currentMoire!.patterns[index])
        return true
    }
    
    func modifyPattern(blackWidth: CGFloat, callerId: String) -> Bool {
//        print("setting blackWidth to: ", blackWidth)
        guard BoundsManager.blackWidthRange.contains(blackWidth) else {
            print("blackWidth out of bound")
            return false
        }
        guard let index = self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.first else {
            return false
        }
        currentMoire!.patterns[index].blackWidth = blackWidth
        self.moireViewController.modifyPatternView(patternViewIndex: index, newPattern: currentMoire!.patterns[index])
        return true
    }
    
    func modifyPattern(whiteWidth: CGFloat, callerId: String) -> Bool {
        guard BoundsManager.whiteWidthRange.contains(whiteWidth) else {
            print("whiteWidth out of bound")
            return false
        }
        guard let index = self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.first else {
            return false
        }
        currentMoire!.patterns[index].whiteWidth = whiteWidth
        self.moireViewController .modifyPatternView(patternViewIndex: index, newPattern: currentMoire!.patterns[index])
        return true
    }
    
    func modifyPatterns(modifiedPatterns: Array<Pattern>, callerId: String) -> Bool {
        // stub
        return false
    }
    
    func getPattern(callerId: String) -> Pattern? {
        guard let index = self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.first else {return nil}
        return self.currentMoire!.patterns[index]
    }
    
    func getPatterns(callerId: String) -> Array<Pattern>? {
        // stub
        return nil
    }
    
    func hidePattern(callerId: String) -> Bool {
        guard let index = self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.first else {return false}
        self.moireViewController?.hidePatternView(patternViewIndex: index)
        return true
    }
    
    func unhidePattern(callerId: String) -> Bool {
        guard let index = self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.first else {return false}
        self.moireViewController?.unhidePatternView(patternViewIndex: index)
        return true
    }
    
    func createPattern(callerId: String?, newPattern: Pattern) -> Bool {
        guard self.currentMoire!.patterns.count < Constants.Constrains.numOfPatternsPerMoire.upperBound else {
            print("creation failed: maximum number of patterns per moire reached")
            return false
        }
        if let cId = callerId {
            if let pIndex = self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: cId)?.first {
                self.currentMoire!.patterns.insert(newPattern, at: pIndex+1)
            }
        } else {
            self.currentMoire!.patterns.append(newPattern)
        }
        self.updateMainView()
        print("num of patterns after creating new: ", self.currentMoire!.patterns.count)
        return true
    }
    
    func deletePattern(callerId: String) -> Bool {
        guard self.currentMoire!.patterns.count > Constants.Constrains.numOfPatternsPerMoire.lowerBound else {
            print("deletion failed: minimum number of patterns per moire reached")
            return false
        }
        guard let index = self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.first else {return false}
        self.currentMoire!.patterns.remove(at: index)
        print("num of patterns after deletion: ", self.currentMoire!.patterns.count)
        self.updateMainView()
        return true
    }
        
    //    func createHighDegControl(type: HighDegreeControlSettings, patternsToControl: Array<Int>) -> Bool {
    //        // stub
    //        return false
    //    }
    
//    func modifyPattern(speed: CGFloat, callerId: String) -> Bool
//    func modifyPattern(direction: CGFloat, callerId: String) -> Bool
//    func modifyPattern(blackWidth: CGFloat, callerId: String) -> Bool
//    func modifyPattern(whiteWidth: CGFloat, callerId: String) -> Bool
//    /// if cannot apply all the changes, apply what is legal, and return false
//    func modifyPatterns(modifiedPatterns: Array<Pattern>, callerId: String) -> Bool
//
//    func getPattern(callerId: String) -> Pattern?
//    func getPatterns(callerId: String) -> Array<Pattern>?
//
//    func highlightPattern(callerId: String) -> Bool
//    func unhighlightPattern(callerId: String) -> Bool
//    func dimPattern(callerId: String) -> Bool
//    func undimPattern(callerId: String) -> Bool
//    func hidePattern(callerId: String) -> Bool
//    func unhidePattern(callerId: String) -> Bool
//
//    func createPattern(callerId: String?, newPattern: Pattern) -> Bool
//    func deletePattern(callerId: String) -> Bool
    
////    func createHighDegControl(type: HighDegreeControlSettings, patternsToControl: Array<Int>) -> Bool
}
