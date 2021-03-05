//
//  CtrlsViewControllerIdManager.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-18.
//

import Foundation

/**
 summary: translate among control view object, control view id, and the index of the pattern its controling
 */
class CtrlAndPatternMatcher {
    /// for example, if a controller controls the pattern 1, 2, 3, its id is "123"
    func getCtrlViewControllerId(indexesOfPatternControlled: Array<Int>) -> String {
        var id: String = ""
        for i in 0..<indexesOfPatternControlled.count {
            id.append(String(indexesOfPatternControlled[i]))
        }
//        assert(self.getIndexOfPatternControlled(controllerId: id) == indexOfPatternControlled, "reverse conversion test failed")
        return id
    }
    
    func getIndexesOfPatternControlled(controllerId: String) -> Array<Int>? {
        var indexes: Array<Int> = []
        for char in controllerId {
            guard let newIndex = Int(String(char)) else {return nil}
            indexes.append(newIndex)
        }
        return indexes
    }
    
    func findIndexesOfPatternControlled(controlViewController: CtrlViewController) -> Array<Int>? {
        guard let id = controlViewController.id else {return nil}
        return self.getIndexesOfPatternControlled(controllerId: id)
    }
}
