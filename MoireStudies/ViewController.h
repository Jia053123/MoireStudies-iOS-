//
//  ViewController.h
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-07.
//

#import <UIKit/UIKit.h>
#import "MoireStudies-Swift.h"

@interface ViewController : UIViewController <ControlViewTarget>

- (BOOL)modifyPatternWithSpeed:(double)speed;
- (BOOL)modifyPatternWithDirection:(double)direction;
- (BOOL)modifyPatternWithFillRatio:(double)fillRatio;
- (BOOL)modifyPatternWithZoomRatio:(double)zoomRatio;

@end

