//
//  PatternStore.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-05.
//

import Foundation

class PatternModel {
    private var model: Array<Pattern> = []
    
    init() {
        self.model.append(Pattern.demoPattern1())
        self.model.append(Pattern.demoPattern2())
    }
    
    
}
