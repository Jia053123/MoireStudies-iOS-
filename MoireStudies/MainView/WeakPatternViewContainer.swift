//
//  WeakContainer.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-02-06.
//

import Foundation
import UIKit

class WeakPatternViewContainer: NSObject {
    weak var content: PatternView?
    required init(content: PatternView) {
        self.content = content
    }
}
