//
//  PatternView.m
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-08.
//

#import "PatternView.h"
#import "ControlView.h"

@implementation PatternView {
    UIView* mask;
    ControlView* controlView;
}

- (PatternView*)initWithFrame:(CGRect)f ControlFrame:(CGRect)c{
    self = [super init];
    if (self) {
        self.frame = f;
        [self setUpMaskWithControlFrame:c];
        [self setUpControlsWithControlFrame:c];
    }
    return self;
}

- (void)setUpMaskWithControlFrame: (CGRect)c {
    
}

- (void)setUpControlsWithControlFrame: (CGRect)c {
    
}

@end
