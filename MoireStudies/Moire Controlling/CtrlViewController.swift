//
//  PatternController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-02.
//

import Foundation
import UIKit

protocol CtrlViewController: UIViewController {
    var id: String! { get }
    var delegate: PatternManager? { get set }
    init(id: String, frame: CGRect, pattern: Pattern?)
    func matchControlsWithModel(pattern: Pattern)
}
