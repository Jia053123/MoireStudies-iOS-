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
    func getCtrlViewControllerId(indexOfPatternControlled: Int) -> Int? {
        let id = indexOfPatternControlled
        assert(self.getIndexOfPatternControlled(id: id) == indexOfPatternControlled, "reverse conversion test failed")
        return id
    }
    
    func getIndexOfPatternControlled(id: Int) -> Int? {
        let index = id
        return index
    }
}
