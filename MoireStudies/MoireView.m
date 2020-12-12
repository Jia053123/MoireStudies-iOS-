//
//  MoireView.m
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-08.
//

#import "MoireView.h"
#import "PatternView.h"

@implementation MoireView

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
    PatternView* pv1 = [[PatternView alloc]
                       initWithFrame:self.frame
                       ControlFrame:controlFrame1];
    [self addSubview:pv1];
    PatternView* pv2;
    // TODO
    [self setUpMaskOnPatternView:pv2 WithControlFrame:controlFrame1];
}

- (void)setUpMaskOnPatternView: (UIView*)pv WithControlFrame: (CGRect)c {
    // TODO: mask corresponding pattern view to match the control views
}

@end
