//
//  MaySensorOrientationChecker.h
//  RCTOrientation
//
//  Created by nakien97 on 11/06/2022.
//  Copyright © 2022 Wonday. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>

typedef void (^MaySensorCallback) (UIInterfaceOrientation orientation);

@interface MaySensorOrientationChecker : NSObject

@property (assign, nonatomic) UIInterfaceOrientation orientation;

- (void)getDeviceOrientationWithBlock:(MaySensorCallback)callback;
- (UIInterfaceOrientation)getOrientationBy:(CMAcceleration)acceleration;
- (AVCaptureVideoOrientation)convertToAVCaptureVideoOrientation:(UIInterfaceOrientation)orientation;

@end
