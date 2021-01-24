//
//  SaveFileCollectionViewCell.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-11.
//

import Foundation
import UIKit

class SaveFileCollectionViewCell: UICollectionViewCell {
    private var previewView: UIImageView = UIImageView()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.previewView.contentMode = ContentMode.scaleAspectFill
        self.addSubview(previewView)
    }
    
    func setUp(previewImage: UIImage) {
        self.backgroundColor = UIColor.white
        self.previewView.frame = self.bounds
        self.previewView.image = previewImage
    }
    
    func highlight() {
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.cyan.cgColor
    }
    
    func unhighlight() {
        self.layer.borderWidth = 0.0
    }
}
