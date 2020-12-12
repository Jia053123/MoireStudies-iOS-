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
    PatternView* pv = [[PatternView alloc]
                       initWithFrame:self.frame
                       ControlFrame:CGRectMake(10, 30, 200, 300)];
    [self addSubview:pv];
}

@end
