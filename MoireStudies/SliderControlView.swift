//
//  SliderControlView.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-23.
//

import Foundation
import UIKit

class SliderControlView : ControlView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func instanceFromNib() -> UIView {
        return UINib(nibName: "SliderControlView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let view: UIView = self.instanceFromNib()
        view.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.addSubview(view)
    }
}
