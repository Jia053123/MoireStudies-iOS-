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
    private var registeredIds: Set<Int> = []
    
    func getOrCreateCtrlViewControllerId(indexOfPatternControlled: Int) -> Int? {
        let id = indexOfPatternControlled
        if !self.registeredIds.contains(id) {
            print("new id created and registered")
            self.registeredIds.insert(id)
        }
        assert(self.getIndexOfPatternControlled(id: id) == indexOfPatternControlled, "reverse conversion test failed")
        return id
    }
    
    func getIndexOfPatternControlled(id: Int) -> Int? {
        if self.registeredIds.contains(id) {
            let index = id
            return index
        } else {
            return nil
        }
    }
}
