//
//  ScreenshotProvider.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-05-01.
//

import Foundation
import UIKit

protocol MoireScreenshotProvider: AnyObject {
    func takeMoireScreenshot() -> UIImage?
}
