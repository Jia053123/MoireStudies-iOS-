//
//  HighDegreeCtrlViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-03-03.
//

import Foundation
import UIKit

class HighDegreeCtrlViewController: UIViewController {
    var id: String!
    var delegate: PatternManager!
    
    required init(id: String, frame: CGRect, patterns: Array<Pattern>?) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
        
        let controlView: HighDegreeCtrlView = SliderHighDegreeCtrlView.init(frame: frame)
        self.view = controlView
        controlView.target = self
        if let ps = patterns {
            self.matchControlsWithModel(patterns: ps)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension HighDegreeCtrlViewController {//: CtrlViewController {
    func matchControlsWithModel(patterns: Array<Pattern>) {
        // stub
    }
}
