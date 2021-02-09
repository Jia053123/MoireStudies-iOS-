//
//  WeakTileLayerContainer.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-02-09.
//

import Foundation
import UIKit

class WeakTileLayerContainer: NSObject {
    weak var tileLayer: TileLayer?
    init(tileLayer: TileLayer) {
        self.tileLayer = tileLayer
    }
}
