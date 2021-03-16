//
//  MockPatternManager.swift
//  MoireStudiesTests
//
//  Created by Jialiang Xiang on 2021-03-15.
//

@testable import MoireStudies
import Foundation
import UIKit

class MockPatternManagerLegal: UIViewController, PatternManager {
    private(set) var modifiedPattern: Pattern?
    private(set) var modifySpeedCallers: Set<Int> = []
    private(set) var modifyDirectionCallers: Set<Int> = []
    private(set) var modifyBlackWidthCallers: Set<Int> = []
    private(set) var modifyWhiteWidthCallers: Set<Int> = []
    private(set) var highlightCallers: Set<Int> = []
    private(set) var unhighlightCallers: Set<Int> = []
    private(set) var dimCallers: Set<Int> = []
    private(set) var undimCallers: Set<Int> = []
    private(set) var hideCallers: Set<Int> = []
    private(set) var unhideCallers: Set<Int> = []
    private(set) var getCallers: Set<Int> = []
    private(set) var createCallers: Set<Int?> = []
    private(set) var deleteCallers: Set<Int> = []
    
    func setCurrentPatternControlled(initPattern: Pattern) {
        self.modifiedPattern = initPattern
    }
    
    func resetTestingRecords() {
        self.modifiedPattern = nil
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
    
    func highlightPattern(callerId: Int) -> Bool {
        self.highlightCallers.insert(callerId)
        return true
    }
    
    func unhighlightPattern(callerId: Int) -> Bool {
        self.unhighlightCallers.insert(callerId)
        return true
    }
    
    func dimPattern(callerId: Int) -> Bool {
        self.dimCallers.insert(callerId)
        return true
    }
    
    func undimPattern(callerId: Int) -> Bool {
        self.undimCallers.insert(callerId)
        return true
    }
    
    /// do not perform bound checks that are done in the real class
    func modifyPattern(speed: CGFloat, callerId: Int) -> Bool {
        self.modifiedPattern?.speed = speed
        self.modifySpeedCallers.insert(callerId)
        return true
    }
    
    func modifyPattern(direction: CGFloat, callerId: Int) -> Bool {
        self.modifiedPattern?.direction = direction
        self.modifyDirectionCallers.insert(callerId)
        return true
    }
    
    func modifyPattern(blackWidth: CGFloat, callerId: Int) -> Bool {
        self.modifiedPattern?.blackWidth = blackWidth
        self.modifyBlackWidthCallers.insert(callerId)
        return true
    }
    
    func modifyPattern(whiteWidth: CGFloat, callerId: Int) -> Bool {
        self.modifiedPattern?.whiteWidth = whiteWidth
        self.modifyWhiteWidthCallers.insert(callerId)
        return true
    }
    
    func getPattern(callerId: Int) -> Pattern? {
        self.getCallers.insert(callerId)
        return self.modifiedPattern
    }
    
    func hidePattern(callerId: Int) -> Bool {
        self.hideCallers.insert(callerId)
        return true
    }
    
    func unhidePattern(callerId: Int) -> Bool {
        self.unhideCallers.insert(callerId)
        return true
    }
    
    func createPattern(callerId: Int?, newPattern: Pattern) -> Bool {
        self.createCallers.insert(callerId)
        return true
    }
    
    func deletePattern(callerId: Int) -> Bool {
        self.deleteCallers.insert(callerId)
        self.modifiedPattern = nil
        return true
    }
}

class MockPatternManagerIllegal: UIViewController, PatternManager {
    private(set) var modifySpeedCallers: Set<Int> = []
    private(set) var modifyDirectionCallers: Set<Int> = []
    private(set) var modifyBlackWidthCallers: Set<Int> = []
    private(set) var modifyWhiteWidthCallers: Set<Int> = []
    private(set) var highlightCallers: Set<Int> = []
    private(set) var unhighlightCallers: Set<Int> = []
    private(set) var dimCallers: Set<Int> = []
    private(set) var undimCallers: Set<Int> = []
    private(set) var hideCallers: Set<Int> = []
    private(set) var unhideCallers: Set<Int> = []
    private(set) var getCallers: Set<Int> = []
    private(set) var createCallers: Set<Int?> = []
    private(set) var deleteCallers: Set<Int> = []
    
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
    
    func highlightPattern(callerId: Int) -> Bool {
        self.highlightCallers.insert(callerId)
        return false
    }
    
    func unhighlightPattern(callerId: Int) -> Bool {
        self.unhighlightCallers.insert(callerId)
        return false
    }
    
    func dimPattern(callerId: Int) -> Bool {
        self.dimCallers.insert(callerId)
        return false
    }
    
    func undimPattern(callerId: Int) -> Bool {
        self.undimCallers.insert(callerId)
        return false
    }
    
    func modifyPattern(speed: CGFloat, callerId: Int) -> Bool {
        self.modifySpeedCallers.insert(callerId)
        return false
    }
    
    func modifyPattern(direction: CGFloat, callerId: Int) -> Bool {
        self.modifyDirectionCallers.insert(callerId)
        return false
    }
    
    func modifyPattern(blackWidth: CGFloat, callerId: Int) -> Bool {
        self.modifyBlackWidthCallers.insert(callerId)
        return false
    }
    
    func modifyPattern(whiteWidth: CGFloat, callerId: Int) -> Bool {
        self.modifyWhiteWidthCallers.insert(callerId)
        return false
    }
    
    func getPattern(callerId: Int) -> Pattern? {
        self.getCallers.insert(callerId)
        return nil
    }
    
    func hidePattern(callerId: Int) -> Bool {
        self.hideCallers.insert(callerId)
        return false
    }
    
    func unhidePattern(callerId: Int) -> Bool {
        self.unhideCallers.insert(callerId)
        return false
    }
    
    func createPattern(callerId: Int?, newPattern: Pattern) -> Bool {
        self.createCallers.insert(callerId)
        return false
    }
    
    func deletePattern(callerId: Int) -> Bool {
        self.deleteCallers.insert(callerId)
        return false
    }
}
