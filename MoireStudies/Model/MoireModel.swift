//
//  MoireModel.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-03-09.
//

import Foundation

protocol MoireModel {
    func numOfMoires() -> Int
    ///returns:  a sorted array of moires sorted in ascending order by its creation date or modification date, whichever comes later
    func readAllMoiresSortedByLastCreatedOrModified() -> Array<Moire>
    func readAllMoiresSortedByLastCreated() -> Array<Moire>
    func read(moireId: String) -> Moire?
    func readLastCreatedOrEdited() -> Moire?
    func saveOrModify(moire: Moire) -> Bool
    func createNewDemo() -> Moire
    func delete(moireId: String) -> Bool
    func deleteAllSaves() -> Bool
}
