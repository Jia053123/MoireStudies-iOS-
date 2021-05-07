//
//  HighDegreeCtrlViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-03-03.
//

import Foundation
import UIKit

class HighDegCtrlViewControllerBasic: UIViewController {
    static let supportedNumOfPatterns: ClosedRange<Int> = 2...(Constants.Constrains.numOfPatternsPerMoire.upperBound)
    var id: String!
    var delegate: PatternManager!
    let initPattern: Array<Pattern?>
    
    required init(id: String, frame: CGRect, patterns: Array<Pattern?>) {
        self.id = id
        self.initPattern = patterns
        super.init(nibName: nil, bundle: nil)
        
        let controlView: HighDegreeCtrlView = SliderHighDegreeCtrlView.init(frame: frame)
        self.view = controlView
        controlView.target = self
//        if let ps = patterns {
            self.matchControlsWithModel(patterns: patterns)//ps)
//        }
    }
    
    required init?(coder: NSCoder) {
        self.initPattern = []
        super.init(coder: coder)
    }
}

extension HighDegCtrlViewControllerBasic: HighDegCtrlViewController {
    func matchControlsWithModel(patterns: Array<Pattern?>) {
        // stub
    }
}
