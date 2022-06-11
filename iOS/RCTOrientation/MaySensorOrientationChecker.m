//
//  MaySensorOrientationChecker.m
//  RCTOrientation
//
//  Created by nakien97 on 11/06/2022.
//  Copyright © 2022 Wonday. All rights reserved.
//

#import "MaySensorOrientationChecker.h"
#import <CoreMotion/CoreMotion.h>


@interface MaySensorOrientationChecker ()

@property (strong, nonatomic) CMMotionManager * motionManager;
@property (strong, nonatomic) MaySensorCallback orientationCallback;

@end

@implementation MaySensorOrientationChecker

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Initialization code
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.accelerometerUpdateInterval = 0.2;
        self.motionManager.gyroUpdateInterval = 0.2;
        self.orientationCallback = nil;
    }
    return self;
}

- (void)dealloc
{
    [self pause];
}

- (void)resume
{
    __weak __typeof(self) weakSelf = self;
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue new]
                                             withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                                 if (!error) {
                                                     self.orientation = [weakSelf getOrientationBy:accelerometerData.acceleration];
                                                 }
                                                 if (self.orientationCallback) {
                                                     self.orientationCallback(self.orientation);
                                                 }
                                             }];
}

- (void)pause
{
    [self.motionManager stopAccelerometerUpdates];
}

- (void)getDeviceOrientationWithBlock:(MaySensorCallback)callback
{
    __weak __typeof(self) weakSelf = self;
    self.orientationCallback = ^(UIInterfaceOrientation orientation) {
        if (callback) {
            callback(orientation);
        }
        weakSelf.orientationCallback = nil;
        [weakSelf pause];
    };
    [self resume];
}

- (UIInterfaceOrientation)getOrientationBy:(CMAcceleration)acceleration
{
    if(acceleration.x >= 0.75) {
        return UIInterfaceOrientationLandscapeLeft;
    }
    if(acceleration.x <= -0.75) {
        return UIInterfaceOrientationLandscapeRight;
    }
    if(acceleration.y <= -0.75) {
        return UIInterfaceOrientationPortrait;
    }
    if(acceleration.y >= 0.75) {
        return UIInterfaceOrientationPortraitUpsideDown;
    }
    return [[UIApplication sharedApplication] statusBarOrientation];
}

- (AVCaptureVideoOrientation)convertToAVCaptureVideoOrientation:(UIInterfaceOrientation)orientation
{
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
            return AVCaptureVideoOrientationPortrait;
        case UIInterfaceOrientationPortraitUpsideDown:
            return AVCaptureVideoOrientationPortraitUpsideDown;
        case UIInterfaceOrientationLandscapeLeft:
            return AVCaptureVideoOrientationLandscapeLeft;
        case UIInterfaceOrientationLandscapeRight:
            return AVCaptureVideoOrientationLandscapeRight;
        default:
            return 0; // unknown
    }
}

@end
