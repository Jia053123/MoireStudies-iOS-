//
//  ViewController.m
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-07.
//

#import "ViewController.h"
#import "MoireView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSAssert([self.view isKindOfClass:[MoireView class]], @"the view is of wrong class");
    [(MoireView*)self.view setUp];
}


@end
