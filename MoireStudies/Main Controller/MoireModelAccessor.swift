//
//  MainViewController+MoireModelAccessor.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-05-01.
//

import Foundation

class MoireModelAccessor {
    private var moireModel: MoireModel
    private weak var screenshotProvider: MoireScreenshotProvider?
    
    required init(moireModel: MoireModel, screenshotProvider: MoireScreenshotProvider) {
        self.moireModel = moireModel
        self.screenshotProvider = screenshotProvider
    }
    
    func loadMoire(preferredId: String?) -> Moire {
        var newMoire: Moire
        if let miti = preferredId {
            print("init moire from id: " + miti)
            newMoire = self.moireModel.read(moireId: miti) ?? self.moireModel.createNewDemoMoire()
        } else {
            newMoire = self.moireModel.readLastCreatedOrEdited() ?? self.moireModel.createNewDemoMoire()
        }
        newMoire = Utilities.fitWithinBounds(moire: newMoire)
        if newMoire.patterns.count > Constants.Constrains.numOfPatternsPerMoire.upperBound {
            newMoire.patterns = Array(newMoire.patterns[0..<Constants.Constrains.numOfPatternsPerMoire.upperBound])
        }
        return newMoire
    }
    
    func saveMoire(moireToSave: Moire) -> Bool {
        // save preview
        if let img = self.screenshotProvider?.takeMoireScreenshot() {
            moireToSave.preview = img
        } else {print("failed to take screenshot")}
        // write to disk
        return self.moireModel.saveOrModify(moire: moireToSave)
    }
}
