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

- (BOOL)setDirectionTo:(double)d {
    return FALSE;
}

- (BOOL)setFillRatioTo:(double)f {
    return FALSE;
}

- (BOOL)setSpeedTo:(double)s {
    return FALSE;
}

- (BOOL)setZoomRatioTo:(double)z {
    return FALSE;
}

@end
