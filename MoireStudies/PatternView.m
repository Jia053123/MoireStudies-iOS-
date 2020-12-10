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
        self.frame = f;
        [self setUpMaskWithControlFrame:c];
        [self setUpControlsWithControlFrame:c];
    }
    return self;
}

- (void)setUpMaskWithControlFrame: (CGRect)c {
    mask = [[UIView alloc]initWithFrame:c];
    mask.backgroundColor = [UIColor blackColor];
    mask.layer.cornerRadius = 30;
    self.maskView = mask;
}

- (void)setUpControlsWithControlFrame: (CGRect)c {
    controlView = [[SliderControlView alloc]initWithFrame:c];
    //controlView.backgroundColor = [UIColor whiteColor];
    [self addSubview:controlView];
}

@end
