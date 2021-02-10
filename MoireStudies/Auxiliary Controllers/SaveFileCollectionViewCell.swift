//
//  SaveFileCollectionViewCell.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-11.
//

import Foundation
import UIKit

class SaveFileCollectionViewCell: UICollectionViewCell {
    private weak var previewView: UIImageView?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let pv = UIImageView()
        pv.contentMode = ContentMode.scaleAspectFill
        self.addSubview(pv)
        self.previewView = pv
    }
    
    func setUp(previewImage: UIImage) {
        self.backgroundColor = UIColor.white
        self.previewView!.frame = self.bounds
        self.previewView!.image = previewImage
    }
    
    func highlight() {
        self.layer.borderWidth = 3.0
        self.layer.borderColor = CGColor.init(red: 20/255, green: 126/255, blue: 251/255, alpha: 255/255)
    }
    
    func unhighlight() {
        self.layer.borderWidth = 0.0
    }
}
