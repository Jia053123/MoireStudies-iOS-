//
//  ViewController.m
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-07.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSAssert([self.view isKindOfClass:[MoireView class]], @"the view is of wrong class");
    [(MoireView*)self.view setUp];
}

- (BOOL)modifyPatternWithSpeed:(double)speed {
    return false;
}
- (BOOL)modifyPatternWithDirection:(double)direction {
    return false;
}
- (BOOL)modifyPatternWithFillRatio:(double)fillRatio {
    return false;
}
- (BOOL)modifyPatternWithZoomRatio:(double)zoomRatio {
    return false;
}

@end
