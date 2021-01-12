//
//  PatternController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-02.
//

import Foundation
import UIKit

protocol CtrlViewTarget: UIViewController {
    var id: Int? { get }
    var delegate: PatternManager? { get set }
    init(id: Int, frame: CGRect, pattern: Pattern?)
    func matchControlsWithModel(pattern: Pattern)
    func highlightPattern()
    func unhighlightPattern()
}
