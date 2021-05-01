//
//  MainViewController+PatternManager.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-05-01.
//

import Foundation
import UIKit

extension MainViewController: PatternManager {
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
    
    private func modifyPattern(speed: CGFloat, patternIndex: Int) -> Bool {
        guard BoundsManager.speedRange.contains(speed) else {
            print("speed out of bound")
            return false
        }
        currentMoire!.patterns[patternIndex].speed = speed
        return true
    }
    
    func modifyPattern(speed: CGFloat, callerId: String) -> Bool {
        guard self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.count == 1 else {
            print("called modifyPattern with a high degree id")
            return false
        }
        guard let index = self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.first else {
            print("can't find id")
            return false
        }
        let success = self.modifyPattern(speed: speed, patternIndex: index)
        if success {
            self.moireViewController.modifyPatternView(patternViewIndex: index, newPattern: currentMoire!.patterns[index])
            return true
        } else {
            return false
        }
    }
    
    private func modifyPattern(direction: CGFloat, patternIndex: Int) -> Bool {
        guard BoundsManager.directionRange.contains(direction) else {
            print("direction out of bound")
            return false
        }
        currentMoire!.patterns[patternIndex].direction = direction
        return true
    }
    
    func modifyPattern(direction: CGFloat, callerId: String) -> Bool {
        guard self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.count == 1 else {
            print("called modifyPattern with a high degree id")
            return false
        }
        guard let index = self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.first else {
            print("can't find id")
            return false
        }
        let success = self.modifyPattern(direction: direction, patternIndex: index)
        if success {
            self.moireViewController.modifyPatternView(patternViewIndex: index, newPattern: currentMoire!.patterns[index])
            return true
        } else {
            return false
        }
    }
    
    private func modifyPattern(blackWidth: CGFloat, patternIndex: Int) -> Bool {
        guard BoundsManager.blackWidthRange.contains(blackWidth) else {
            print("blackWidth out of bound")
            return false
        }
        currentMoire!.patterns[patternIndex].blackWidth = blackWidth
        return true
    }
    
    func modifyPattern(blackWidth: CGFloat, callerId: String) -> Bool {
        guard self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.count == 1 else {
            print("called modifyPattern with a high degree id")
            return false
        }
        guard let index = self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.first else {
            print("can't find id")
            return false
        }
        let success = self.modifyPattern(blackWidth: blackWidth, patternIndex: index)
        if success {
            self.moireViewController.modifyPatternView(patternViewIndex: index, newPattern: currentMoire!.patterns[index])
            return true
        } else {
            return false
        }
    }
    
    private func modifyPattern(whiteWidth: CGFloat, patternIndex: Int) -> Bool {
        guard BoundsManager.whiteWidthRange.contains(whiteWidth) else {
            print("whiteWidth out of bound")
            return false
        }
        currentMoire!.patterns[patternIndex].whiteWidth = whiteWidth
        return true
    }
    
    func modifyPattern(whiteWidth: CGFloat, callerId: String) -> Bool {
        guard self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.count == 1 else {
            print("called modifyPattern with a high degree id")
            return false
        }
        guard let index = self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.first else {
            print("can't find id")
            return false
        }
        let success = self.modifyPattern(whiteWidth: whiteWidth, patternIndex: index)
        if success {
            self.moireViewController.modifyPatternView(patternViewIndex: index, newPattern: currentMoire!.patterns[index])
            return true
        } else {
            return false
        }
    }
    
    func modifyPatterns(modifiedPatterns: Array<Pattern>, callerId: String) -> Bool {
        guard let patternIndexes = self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId) else {
            return false
        }
        // if array length is wrong, return false
        guard modifiedPatterns.count == patternIndexes.count else {
            return false
        }
        // if not all the changes are legal, apply what is legal, and return false
        var completeSuccess = true
        for i in 0..<patternIndexes.count {
            let newPattern = modifiedPatterns[i]
            let patternIndex = patternIndexes[i]
            var success = true
            success = self.modifyPattern(speed: newPattern.speed, patternIndex: patternIndex)
            completeSuccess = completeSuccess && success
            success = self.modifyPattern(direction: newPattern.direction, patternIndex: patternIndex)
            completeSuccess = completeSuccess && success
            success = self.modifyPattern(blackWidth: newPattern.blackWidth, patternIndex: patternIndex)
            completeSuccess = completeSuccess && success
            success = self.modifyPattern(whiteWidth: newPattern.whiteWidth, patternIndex: patternIndex)
            completeSuccess = completeSuccess && success
            
            self.moireViewController.modifyPatternView(patternViewIndex: patternIndex, newPattern: currentMoire!.patterns[patternIndex])
        }
        return completeSuccess
    }
    
    func retrievePattern(callerId: String) -> Pattern? {
        guard let index = self.ctrlAndPatternMatcher.getIndexesOfPatternControlled(controllerId: callerId)?.first else {return nil}
        return self.currentMoire!.patterns[index]
    }
    
    func retrievePatterns(callerId: String) -> Array<Pattern>? {
        // TODO: stub
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
}

