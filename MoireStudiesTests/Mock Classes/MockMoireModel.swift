//
//  MockMoireModel.swift
//  MoireStudiesTests
//
//  Created by Jialiang Xiang on 2021-03-09.
//

@testable import MoireStudies
import Foundation

class MockMoireModelFilesNormal: MoireModel {
    // make sure the last created or edited is the last element
    private(set) var currentMoiresSortedByLastCreatedOrEdited: Array<Moire> = []
    private(set) var currentMoiresSortedByLastCreated: Array<Moire> = []
    
    func setStoredMoires(moires: Array<Moire>) {
        self.currentMoiresSortedByLastCreatedOrEdited = moires
        self.currentMoiresSortedByLastCreated = moires
    }
    
    func numOfMoires() -> Int {
        return self.currentMoiresSortedByLastCreatedOrEdited.count
    }
    
    func read(moireId: String) -> Moire? {
        return self.currentMoiresSortedByLastCreatedOrEdited.first(where: {m -> Bool in
            return m.id == moireId
        })
    }
    
    func readAllMoiresSortedByLastCreated() -> Array<Moire> {
        assert(self.currentMoiresSortedByLastCreated.count == self.currentMoiresSortedByLastCreatedOrEdited.count)
        for m in self.currentMoiresSortedByLastCreatedOrEdited {
            assert(self.currentMoiresSortedByLastCreated.firstIndex(of: m) != nil)
        }
        
        return self.currentMoiresSortedByLastCreated
    }
    
    func readLastCreatedOrEdited() -> Moire? {
        return self.currentMoiresSortedByLastCreatedOrEdited.last
    }
    
    func saveOrModify(moire: Moire) -> Bool {
        let index1 = self.currentMoiresSortedByLastCreatedOrEdited.firstIndex(where: {m -> Bool in
            return m.id == moire.id
        })
        if let i = index1 {
            // moire already exists
            self.currentMoiresSortedByLastCreatedOrEdited.remove(at: i)
        }
        self.currentMoiresSortedByLastCreatedOrEdited.append(moire) // append to the end since it's the latest
        
        let index2 = self.currentMoiresSortedByLastCreated.firstIndex(where: {m -> Bool in
            return m.id == moire.id
        })
        if let i = index2 { // moire already exists
            self.currentMoiresSortedByLastCreated[i] = moire
        } else { // a new moire
            self.currentMoiresSortedByLastCreated.append(moire)
        }
        
        return true
    }
    
    func createNewDemoMoire() -> Moire {
        let newDemo = Moire()
        newDemo.patterns.append(Pattern.defaultPattern())
        newDemo.patterns.append(Pattern.defaultPattern())
        self.currentMoiresSortedByLastCreatedOrEdited.append(newDemo)
        self.currentMoiresSortedByLastCreated.append(newDemo)
        return newDemo
    }
    
    func delete(moireId: String) -> Bool {
        let index1 = self.currentMoiresSortedByLastCreatedOrEdited.firstIndex(where: {m -> Bool in
            return m.id == moireId
        })
        if let i = index1 {
            // moire exists
            self.currentMoiresSortedByLastCreatedOrEdited.remove(at: i)
            
            let index2 = self.currentMoiresSortedByLastCreated.firstIndex(where: {m -> Bool in
                return m.id == moireId
            })
            assert(index2 != nil)
            self.currentMoiresSortedByLastCreatedOrEdited.remove(at: index2!)
            
            return true
        } else {
            return false
        }
    }
    
    func deleteAllSaves() -> Bool {
        self.currentMoiresSortedByLastCreatedOrEdited = []
        self.currentMoiresSortedByLastCreated = []
        return true
    }
}

/// When the model is corrupted, it saves successfully, but reports more moires available than it is able to read (currently all files are corrupted)
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
    
    func readAllMoiresSortedByLastCreated() -> Array<Moire> {
        return []
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
        return true
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

/// A mock model that can't write to file system successfully e.g. a read only partition
class MockMoireModelReadOnly: MoireModel {
    private var existingMoires: Array<Moire> = []
    
    func setExistingMoires(moires: Array<Moire>) {
        self.existingMoires = moires
    }
    
    func numOfMoires() -> Int {
        return self.existingMoires.count
    }
    
    func read(moireId: String) -> Moire? {
        return self.existingMoires.first(where: {m -> Bool in
            return m.id == moireId
        })
    }
    
    func readAllMoiresSortedByLastCreated() -> Array<Moire> {
        return self.existingMoires
    }
    
    func readLastCreatedOrEdited() -> Moire? {
        return self.existingMoires.last
    }
    
    func saveOrModify(moire: Moire) -> Bool {
        return false
    }
    
    func createNewDemoMoire() -> Moire {
        let newDemo = Moire()
        newDemo.patterns.append(Pattern.defaultPattern())
        newDemo.patterns.append(Pattern.defaultPattern())
        // doesn't save
        return newDemo
    }
    
    func delete(moireId: String) -> Bool {
        return false
    }
    
    func deleteAllSaves() -> Bool {
        return false
    }
}
