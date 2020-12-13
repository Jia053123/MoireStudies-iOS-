//
//  MoireView.m
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-08.
//

#import "MoireView.h"
#import "PatternView.h"
#import "ControlView.h"
#import "SliderControlView.h"

@implementation MoireView {
    PatternView* patternView1;
    ControlView* controlView1;
    PatternView* patternView2;
    ControlView* controlView2;
    UIView* mask1;
}

- (id) initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        // TODO: stub
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

- (void) setUp {
    CGRect controlFrame1 = CGRectMake(10, 30, 200, 300);
    patternView1 = [[PatternView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    patternView1.backgroundColor = [UIColor yellowColor];
    [self addSubview:patternView1];
    // TODO
    [self setUpMaskOnPatternView:patternView2 WithControlFrame:controlFrame1];
    [self setUpControlsWithControlFrame:controlFrame1];
}

- (void)setUpMaskOnPatternView: (UIView*)pv WithControlFrame: (CGRect)c {
    // TODO: mask corresponding pattern view to match the control views
}

- (void)setUpControlsWithControlFrame: (CGRect)c {
    controlView1 = [[SliderControlView alloc]initWithFrame:c];
    [self addSubview:controlView1];
}

@end
