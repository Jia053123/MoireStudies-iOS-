//
//  PatternView.m
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-08.
//

#import "PatternView.h"
#import "ControlView.h"
#import "SliderControlView.h"

@implementation PatternView {
    UIView* mask;
    ControlView* controlView;
}

- (PatternView*)initWithFrame:(CGRect)f ControlFrame:(CGRect)c {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        self.frame = f;
        [self setUpControlsWithControlFrame:c];
    }
    return self;
}

- (void)setUpControlsWithControlFrame: (CGRect)c {
    controlView = [[SliderControlView alloc]initWithFrame:c];
    [self addSubview:controlView];
}

@end
