//
//  SliderControlView.m
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-08.
//

#import "SliderControlView.h"

@implementation SliderControlView

- (UIView*) instanceFromNib {
    return (UIView*)[[UINib nibWithNibName:@"SliderControlView" bundle:nil]instantiateWithOwner:nil options:nil].firstObject;
}

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:[self instanceFromNib]];
    }
    return self;
}

@end
