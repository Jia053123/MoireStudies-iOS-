//
//  PatternController.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-02.
//

import Foundation
import UIKit

protocol PatternCtrlViewController: UIViewController {
    var delegate: PatternStore? { get set }
}
