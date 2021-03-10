//
//  MockMoireModel.swift
//  MoireStudiesTests
//
//  Created by Jialiang Xiang on 2021-03-09.
//

@testable import MoireStudies
import Foundation

class MockMoireModel: MoireModel {
    // make sure the last created or edited is the last element
    private(set) var currentMoires: Array<Moire> = []
    
    func setMockMoires(moires: Array<Moire>) {
        self.currentMoires = moires
    }
    
    func numOfMoires() -> Int {
        return self.currentMoires.count
    }
    
    func read(moireId: String) -> Moire? {
        return self.currentMoires.first(where: {m -> Bool in
            return m.id == moireId
        })
    }
    
    func readLastCreatedOrEdited() -> Moire? {
        return self.currentMoires.last
    }
    
    func saveOrModify(moire: Moire) -> Bool {
        let index = self.currentMoires.firstIndex(where: {m -> Bool in
            return m.id == moire.id
        })
        if let i = index {
            // moire already exists
            self.currentMoires.remove(at: i)
        }
        self.currentMoires.append(moire) // append to the end since it's the latest
        return true
    }
    
    func createNewDemoMoire() -> Moire {
        let newDemo = Moire()
        newDemo.patterns.append(Pattern.randomDemoPattern())
        newDemo.patterns.append(Pattern.randomDemoPattern())
        self.currentMoires.append(newDemo)
        return newDemo
    }
    
    func delete(moireId: String) -> Bool {
        let index = self.currentMoires.firstIndex(where: {m -> Bool in
            return m.id == moireId
        })
        if let i = index {
            // moire exists
            self.currentMoires.remove(at: i)
            return true
        } else {
            return false
        }
    }
    
    func deleteAllSaves() -> Bool {
        self.currentMoires = []
        return true
    }
}
