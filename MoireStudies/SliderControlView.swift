//
//  SliderControlView.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-23.
//

import Foundation
import UIKit

class SliderControlView : ControlView {
    @IBOutlet weak var speed: UISegmentedControl!
    @IBOutlet weak var direction: UISlider!
    @IBOutlet weak var fillRatio: UISlider!
    @IBOutlet weak var zoomRatio: UISlider!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUp()
    }
    
//    func instanceFromNib() -> UIView {
//        return UINib(nibName: "SliderControlView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! UIView
//    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.yellow
        //let view: UIView = self.instanceFromNib()
//        view.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        //self.addSubview(view)
        self.setUp()
    }
    
    private func setUp()
    {
        let nib = UINib(nibName: "SliderControlView", bundle: nil)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            self.addSubview(view)
            view.frame = self.bounds
        }
    }
    @IBAction func speedChanged(_ sender: Any) {
        print("speed changed")
    }
    
}
