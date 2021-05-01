//
//  PatternSelector.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-05-01.
//

import Foundation
protocol PatternsSelector {
    var selectedPatternIndexes: Array<Int> { get }
    func enterSelectionMode()
    func exitSelectionMode()
}
