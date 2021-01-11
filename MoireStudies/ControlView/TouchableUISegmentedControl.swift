//
//  TouchableUISegmentedControl.swift
//  MoireStudies
//
//  Created by Jialiang Xiang on 2021-01-11.
//

import Foundation
import UIKit

class TouchableUISegmentedControl: UISegmentedControl {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        sendActions(for: UIControl.Event.touchDown)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        var touchUpInside = false
        var touchUpOutside = false
        for t in touches {
            if self.bounds.contains(t.location(in: self)) {
                touchUpInside = true
            } else {
                touchUpOutside = true
            }
        }
        if touchUpInside {
            sendActions(for: UIControl.Event.touchUpInside)
        }
        if touchUpOutside {
            sendActions(for: UIControl.Event.touchUpOutside)
        }
    }
}
