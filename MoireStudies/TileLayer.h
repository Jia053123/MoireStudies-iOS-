//
//  TileLayer.h
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-08.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface TileLayer : CALayer

@property double fillRatio;

- (TileLayer*)initWithFillRatio: (double)f;

@end

NS_ASSUME_NONNULL_END
