//
//  Pattern.m
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-08.
//

#import "Pattern.h"

@implementation Pattern

- (Pattern*) initWithSpeed: (double) s Direction: (double) d FillRatio: (double) f ZoomRatio: (double) z {
    self.speed = s;
    self.direction = d;
    self.fillRatio = f;
    self.zoomRatio = z;
    return nil;
}

@end
