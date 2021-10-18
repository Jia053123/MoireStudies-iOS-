//
//  MockPatternManager.swift
//  MoireStudiesTests
//
//  Created by Jialiang Xiang on 2021-03-15.
//

@testable import MoireStudies
import Foundation
import UIKit

class MockPatternManagerAlwaysLegal: UIViewController, PatternManager {
    private(set) var modifiedPattern: Pattern?
    private(set) var modifiedPatterns: Array<Pattern>?
    private(set) var createdPattern: Pattern?
    private(set) var modifySpeedCallers: Set<String> = []
    private(set) var modifyDirectionCallers: Set<String> = []
    private(set) var modifyBlackWidthCallers: Set<String> = []
    private(set) var modifyWhiteWidthCallers: Set<String> = []
    private(set) var modifyMulitplePatternsCallers: Set<String> = []
    private(set) var highlightCallers: Set<String> = []
    private(set) var unhighlightCallers: Set<String> = []
    private(set) var dimCallers: Set<String> = []
    private(set) var undimCallers: Set<String> = []
    private(set) var hideCallers: Set<String> = []
    private(set) var unhideCallers: Set<String> = []
    private(set) var retrievePatternCallers: Set<String> = []
    private(set) var retrievePatternsCallers: Set<String> = []
    private(set) var createCallers: Set<String?> = []
    private(set) var deleteCallers: Set<String> = []
    
    func setCurrentPatternControlled(initPattern: Pattern) {
        self.modifiedPattern = initPattern
    }
    
    func setCurrentPatternsControlled(initPatterns: Array<Pattern>) {
        self.modifiedPatterns = initPatterns
    }
    
    func resetTestingRecords() {
        self.modifiedPattern = nil
        self.createdPattern = nil
        self.modifySpeedCallers = []
        self.modifyDirectionCallers = []
        self.modifyBlackWidthCallers = []
        self.modifyWhiteWidthCallers = []
        self.highlightCallers = []
        self.unhighlightCallers = []
        self.dimCallers = []
        self.undimCallers = []
        self.hideCallers = []
        self.unhideCallers = []
        self.retrievePatternCallers = []
        self.retrievePatternsCallers = []
        self.createCallers = []
        self.deleteCallers = []
    }
    
    func highlightPattern(callerId: String) -> Bool {
        self.highlightCallers.insert(callerId)
        return true
    }
    
    func unhighlightPattern(callerId: String) -> Bool {
        self.unhighlightCallers.insert(callerId)
        return true
    }
    
    func dimPattern(callerId: String) -> Bool {
        self.dimCallers.insert(callerId)
        return true
    }
    
    func undimPattern(callerId: String) -> Bool {
        self.undimCallers.insert(callerId)
        return true
    }
    
    /// do not perform bound checks that are done in the real class
    func modifyPattern(speed: CGFloat, callerId: String) -> Bool {
        self.modifiedPattern?.speed = speed
        self.modifySpeedCallers.insert(callerId)
        return true
    }
    
    func modifyPattern(direction: CGFloat, callerId: String) -> Bool {
        self.modifiedPattern?.direction = direction
        self.modifyDirectionCallers.insert(callerId)
        return true
    }
    
    func modifyPattern(blackWidth: CGFloat, callerId: String) -> Bool {
        self.modifiedPattern?.blackWidth = blackWidth
        self.modifyBlackWidthCallers.insert(callerId)
        return true
    }
    
    func modifyPattern(whiteWidth: CGFloat, callerId: String) -> Bool {
        self.modifiedPattern?.whiteWidth = whiteWidth
        self.modifyWhiteWidthCallers.insert(callerId)
        return true
    }
    
    func modifyPatterns(modifiedPatterns: Array<Pattern>, callerId: String) -> Bool {
        self.modifiedPatterns = modifiedPatterns
        self.modifyMulitplePatternsCallers.insert(callerId)
        return true
    }
    
    func retrievePattern(callerId: String) -> Pattern? {
        self.retrievePatternCallers.insert(callerId)
        return self.modifiedPattern
    }
    
    func retrievePatterns(callerId: String) -> Array<Pattern>? {
        self.retrievePatternsCallers.insert(callerId)
        return self.modifiedPatterns
    }
    
    func hidePattern(callerId: String) -> Bool {
        self.hideCallers.insert(callerId)
        return true
    }
    
    func unhidePattern(callerId: String) -> Bool {
        self.unhideCallers.insert(callerId)
        return true
    }
    
    func createPattern(callerId: String?, newPattern: Pattern) -> Bool {
        self.createCallers.insert(callerId)
        self.createdPattern = newPattern
        return true
    }
    
    func deletePattern(callerId: String) -> Bool {
        self.deleteCallers.insert(callerId)
        self.modifiedPattern = nil
        return true
    }
    
    func removeHighDegControl(id: String) -> Bool {
        return true // stub
    }
}

class MockPatternManagerAlwaysIllegal: UIViewController, PatternManager {
    var doesReturnPatternControlled: Bool = true
    private(set) var modifySpeedCallers: Set<String> = []
    private(set) var modifyDirectionCallers: Set<String> = []
    private(set) var modifyBlackWidthCallers: Set<String> = []
    private(set) var modifyWhiteWidthCallers: Set<String> = []
    private(set) var modifyMulitplePatternsCallers: Set<String> = []
    private(set) var highlightCallers: Set<String> = []
    private(set) var unhighlightCallers: Set<String> = []
    private(set) var dimCallers: Set<String> = []
    private(set) var undimCallers: Set<String> = []
    private(set) var hideCallers: Set<String> = []
    private(set) var unhideCallers: Set<String> = []
    private(set) var getCallers: Set<String> = []
    private(set) var createCallers: Set<String?> = []
    private(set) var deleteCallers: Set<String> = []
    
    func resetTestingRecords() {
        self.modifySpeedCallers = []
        self.modifyDirectionCallers = []
        self.modifyBlackWidthCallers = []
        self.modifyWhiteWidthCallers = []
        self.highlightCallers = []
        self.unhighlightCallers = []
        self.dimCallers = []
        self.undimCallers = []
        self.hideCallers = []
        self.unhideCallers = []
        self.getCallers = []
        self.createCallers = []
        self.deleteCallers = []
    }
    
    func highlightPattern(callerId: String) -> Bool {
        self.highlightCallers.insert(callerId)
        return false
    }
    
    func unhighlightPattern(callerId: String) -> Bool {
        self.unhighlightCallers.insert(callerId)
        return false
    }
    
    func dimPattern(callerId: String) -> Bool {
        self.dimCallers.insert(callerId)
        return false
    }
    
    func undimPattern(callerId: String) -> Bool {
        self.undimCallers.insert(callerId)
        return false
    }
    
    func modifyPattern(speed: CGFloat, callerId: String) -> Bool {
        self.modifySpeedCallers.insert(callerId)
        return false
    }
    
    func modifyPattern(direction: CGFloat, callerId: String) -> Bool {
        self.modifyDirectionCallers.insert(callerId)
        return false
    }
    
    func modifyPattern(blackWidth: CGFloat, callerId: String) -> Bool {
        self.modifyBlackWidthCallers.insert(callerId)
        return false
    }
    
    func modifyPattern(whiteWidth: CGFloat, callerId: String) -> Bool {
        self.modifyWhiteWidthCallers.insert(callerId)
        return false
    }
    
    func modifyPatterns(modifiedPatterns: Array<Pattern>, callerId: String) -> Bool {
        self.modifyMulitplePatternsCallers.insert(callerId)
//        return true
        return false
    }
    
    func retrievePattern(callerId: String) -> Pattern? {
        self.getCallers.insert(callerId)
        return self.doesReturnPatternControlled ? Pattern.defaultPattern() : nil
    }
    
    func retrievePatterns(callerId: String) -> Array<Pattern>? {
        //TODO: stub
        return nil
    }
    
    func hidePattern(callerId: String) -> Bool {
        self.hideCallers.insert(callerId)
        return false
    }
    
    func unhidePattern(callerId: String) -> Bool {
        self.unhideCallers.insert(callerId)
        return false
    }
    
    func createPattern(callerId: String?, newPattern: Pattern) -> Bool {
        self.createCallers.insert(callerId)
        return false
    }
    
    func deletePattern(callerId: String) -> Bool {
        self.deleteCallers.insert(callerId)
        return false
    }
    
    func removeHighDegControl(id: String) -> Bool {
        return false // stub
    }
}
