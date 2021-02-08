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
    
    // change value before touch up event is fired
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let segNum = self.numberOfSegments
        let width = self.bounds.width
        let segWidth = width / CGFloat(segNum)
        let touchX = touches.first!.location(in: self).x
        let segIndexDraggedInto = Int(floor(touchX / segWidth))
        if self.selectedSegmentIndex != segIndexDraggedInto {
            self.selectedSegmentIndex = segIndexDraggedInto
            sendActions(for: UIControl.Event.valueChanged)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if self.bounds.contains(touches.first!.location(in: self)) {
            sendActions(for: UIControl.Event.touchUpInside)
        } else {
            sendActions(for: UIControl.Event.touchUpOutside)
        }
    }
}
