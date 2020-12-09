//
//  ControlViewTarget.h
//  MoireStudies
//
//  Created by Jialiang Xiang on 2020-12-08.
//

#ifndef ControlViewTarget_h
#define ControlViewTarget_h

@protocol ControlViewTarget <NSObject>

- (BOOL)setSpeedTo: (double)s;
- (BOOL)setDirectionTo: (double)d;
- (BOOL)setFillRatioTo: (double)f;
- (BOOL)setZoomRatioTo: (double)z;

@end

#endif /* ControlViewTarget_h */
