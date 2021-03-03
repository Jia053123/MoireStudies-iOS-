//
//  HighDegreeCtrlViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-03-03.
//

import Foundation
import UIKit

class HighDegreeCtrlViewController: UIViewController {
    var id: Int?
    var delegate: PatternManager?
    
    required init(id: Int, frame: CGRect, pattern: Pattern?) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
        // stub
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension HighDegreeCtrlViewController: CtrlViewController {
    func matchControlsWithModel(pattern: Pattern) {
        
    }
}
