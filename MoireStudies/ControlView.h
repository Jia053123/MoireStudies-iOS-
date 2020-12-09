//
//  ControlView.h
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-08.
//

#import <UIKit/UIKit.h>
#import "ControlViewTarget.h"

NS_ASSUME_NONNULL_BEGIN

@interface ControlView : UIView

@property id <ControlViewTarget> target;

@end

NS_ASSUME_NONNULL_END
