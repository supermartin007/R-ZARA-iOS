//
//  AppDelegate.h
//  Malum
//
//  Created by Mars on 6/16/16.
//  Copyright © 2016 Mars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, retain) CLLocationManager *locationManager;
@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) UIViewController * pointViewController;
- (void)updateLocationManager;


@end

