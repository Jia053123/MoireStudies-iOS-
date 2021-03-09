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
    private(set) var mockMoires: Array<Moire> = []
    
    func setMockMoires(moires: Array<Moire>) {
        self.mockMoires = moires
    }
    
    func numOfMoires() -> Int {
        return self.mockMoires.count
    }
    
    func read(moireId: String) -> Moire? {
        return self.mockMoires.first(where: {m -> Bool in
            return m.id == moireId
        })
    }
    
    func readLastCreatedOrEdited() -> Moire? {
        return self.mockMoires.last
    }
    
    func saveOrModify(moire: Moire) -> Bool {
        let index = self.mockMoires.firstIndex(where: {m -> Bool in
            return m.id == moire.id
        })
        if let i = index {
            // moire already exists
            self.mockMoires.remove(at: i)
        }
        self.mockMoires.append(moire)
        return true
    }
    
    func createNewDemoMoire() -> Moire {
        let newDemo = Moire()
        self.mockMoires.append(newDemo)
        return newDemo
    }
    
    func delete(moireId: String) -> Bool {
        let index = self.mockMoires.firstIndex(where: {m -> Bool in
            return m.id == moireId
        })
        if let i = index {
            // moire exists
            self.mockMoires.remove(at: i)
            return true
        } else {
            return false
        }
    }
    
    func deleteAllSaves() -> Bool {
        self.mockMoires = []
        return true
    }
}
