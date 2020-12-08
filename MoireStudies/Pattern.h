//
//  Pattern.h
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-08.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Pattern : NSObject

@property double speed;
@property double direction;
@property double fillRatio;
@property double zoomRatio;

- (Pattern*) initWithSpeed: (double) s Direction: (double) d FillRatio: (double) f ZoomRatio: (double) z;

@end

NS_ASSUME_NONNULL_END
