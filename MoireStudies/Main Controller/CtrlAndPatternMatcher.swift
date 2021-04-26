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
    private var registeredIds: Set<String> = []
    
    private func isRegistered(id: String) -> Bool {
        return self.registeredIds.contains(id)
    }

    /// for example, if a controller controls the pattern 1, 22, 3, its id is "/1/22/3"
    func getOrCreateCtrlViewControllerId(indexesOfPatternControlled: Array<Int>) -> String? {
        var id: String = ""
        for i in 0..<indexesOfPatternControlled.count {
            id.append("/" + String(indexesOfPatternControlled[i]))
        }
        if !self.registeredIds.contains(id) {
            print("new id created and registered")
            self.registeredIds.insert(id)
        }
        assert(self.getIndexesOfPatternControlled(controllerId: id) == indexesOfPatternControlled, "reverse conversion test failed")
        return id
    }
    
    func getIndexesOfPatternControlled(controllerId: String) -> Array<Int>? {
        if self.isRegistered(id: controllerId) {
            var allIndexesData: Array<String> = []
            var currentIndexesData = ""
            for char in controllerId {
                if char == "/" {
                    // record data collected (if not empty) and reset current data
                    if currentIndexesData != "" {
                        allIndexesData.append(currentIndexesData)
                        currentIndexesData = ""
                    }
                } else {
                    // add to current data
                    currentIndexesData += String(char)
                }
            }
            if currentIndexesData != "" {
                allIndexesData.append(currentIndexesData)
                currentIndexesData = ""
            }
            var indexes: Array<Int> = []
            for d in allIndexesData {
                guard let newIndex = Int(d) else {return nil}
                indexes.append(newIndex)
            }
            return indexes
        } else {
            return nil
        }
    }
}
