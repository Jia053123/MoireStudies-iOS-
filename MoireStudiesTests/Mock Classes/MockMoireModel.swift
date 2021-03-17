//
//  MockMoireModel.swift
//  MoireStudiesTests
//
//  Created by Jialiang Xiang on 2021-03-09.
//

@testable import MoireStudies
import Foundation

class MockMoireModelFilesNotCorrupted: MoireModel {
    // make sure the last created or edited is the last element
    private(set) var currentMoires: Array<Moire> = []
    
    func setStoredMoires(moires: Array<Moire>) {
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
        newDemo.patterns.append(Pattern.defaultPattern())
        newDemo.patterns.append(Pattern.defaultPattern())
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

/// When the model is corrupted, it reports more moires available than it is able to read (currently all files are corrupted) 
class MockMoireModelFilesCorrupted: MoireModel {
    private var moiresSupposedToBeStored: Array<Moire> = []
    
    func setMoiresSupposedToBeStored(moires: Array<Moire>) {
        self.moiresSupposedToBeStored = moires
    }
    
    func numOfMoires() -> Int {
        return self.moiresSupposedToBeStored.count
    }
    
    func read(moireId: String) -> Moire? {
        return nil
    }
    
    func readLastCreatedOrEdited() -> Moire? {
        return nil
    }
    
    func saveOrModify(moire: Moire) -> Bool {
        let index = self.moiresSupposedToBeStored.firstIndex(where: {m -> Bool in
            return m.id == moire.id
        })
        if let i = index {
            // moire already exists
            self.moiresSupposedToBeStored.remove(at: i)
        }
        self.moiresSupposedToBeStored.append(moire) // append to the end since it's the latest
        return false
    }
    
    func createNewDemoMoire() -> Moire {
        let newDemo = Moire()
        newDemo.patterns.append(Pattern.defaultPattern())
        newDemo.patterns.append(Pattern.defaultPattern())
        self.moiresSupposedToBeStored.append(newDemo)
        return newDemo
    }
    
    func delete(moireId: String) -> Bool {
        return false
    }
    
    func deleteAllSaves() -> Bool {
        return false
    }
}
