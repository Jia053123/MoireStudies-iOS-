//
//  PatternController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-02.
//

import Foundation
import UIKit

protocol CtrlViewController: UIViewController {
    var id: Int? {get set}
    var delegate: PatternStore? { get set }
}
