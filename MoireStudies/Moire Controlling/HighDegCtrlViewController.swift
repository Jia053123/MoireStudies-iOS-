//
//  HighDegCtrlViewController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-04-11.
//

import Foundation
import UIKit

protocol HighDegCtrlViewController: UIViewController {
    static var supportedNumOfPatterns: ClosedRange<Int> { get }
    var id: String! { get }
    var patternsDelegate: PatternManager! { get set }
    init(id: String, frame: CGRect, patterns: Array<Pattern?>)
    func matchControlsWithModel(patterns: Array<Pattern?>)
}
