//
//  AppDelegate.m
//  Malum
//
//  Created by Mars on 6/16/16.
//  Copyright © 2016 Mars. All rights reserved.
//

#import "AppDelegate.h"
#import <Google/Analytics.h>
#import "PointsCollectViewController.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Facebook Integration
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    // Location Management
    [self updateLocationManager];
    
//    // Push Notification
//    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
//        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//    } else {
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
//    }
//    if(launchOptions != nil && [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]) {
//        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//        appController.apnsMessage = [[userInfo objectForKey:@"aps"] objectForKey:@"info"];
//        [commonUtils setUserDefault:@"apns_message_arrived" withFormat:@"1"];
//    }
    
    
    return YES;
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    
    NSString* newToken = [[[NSString stringWithFormat:@"%@",deviceToken]
                           stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [commonUtils setUserDefault:@"user_apns_id" withFormat:newToken];
    NSLog(@"My saved token is: %@", [commonUtils getUserDefault:@"user_apns_id"]);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    appController.apnsMessage = [[NSMutableDictionary alloc] init];
    appController.apnsMessage = [[userInfo objectForKey:@"aps"] objectForKey:@"info"];
    
    NSLog(@"APNS Info Fetched : %@", userInfo);
    NSLog(@"My Received Message : %@", appController.apnsMessage);
    
    [commonUtils setUserDefault:@"apns_message_arrived" withFormat:@"1"];
    
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//    AllFeedViewController *navController = (AllFeedViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"messageview"];
//    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:navController];
    //        if([commonUtils getUserDefault:@"current_user_user_id"] != nil) {
    //            navController.navigationBarHidden = NO;
    //        } else {
    //            navController.navigationBarHidden = YES;
    //        }
    //self.window.rootViewController = navigationVC;
    
    [application setApplicationIconBadgeNumber:[[[userInfo objectForKey:@"aps"] objectForKey:@"badgecount"] intValue]];
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    NSLog(@"Enter Background");
    
    appController.firstTime = [NSDate timeIntervalSinceReferenceDate];
    //NSLog(@"FIRST TIME%d", appController.firstTime);
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"Enter Forground");
    appController.lastTime = [NSDate timeIntervalSinceReferenceDate];
    //NSLog(@"LAST TIME%d", appController.lastTime);
    
    appController.timedifference = appController.lastTime - appController.firstTime;
    
    if (self.pointViewController) {
        PointsCollectViewController *pointview = (PointsCollectViewController *)self.pointViewController;
        [pointview addPoint:appController.timedifference];
    }

    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ];
}


#pragma mark - CLLocationManagerDelegate

- (void)updateLocationManager {
    
//    if([commonUtils getUserDefault:@"flag_location_query_enabled"] != nil && [[commonUtils getUserDefault:@"flag_location_query_enabled"] isEqualToString:@"1"])
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        [_locationManager setDistanceFilter:50.17f]; // Distance Filter as 0.5 mile (1 mile = 1609.34m)
        //locationManager.distanceFilter=kCLDistanceFilterNone;
        
        
        // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
        //    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        //        [_locationManager requestWhenInUseAuthorization];
        //    }
        
        
        
        if(IS_OS_8_OR_LATER) {
            [_locationManager requestAlwaysAuthorization];
        } else {
            [_locationManager requestWhenInUseAuthorization];
        }
        
        //[_locationManager requestWhenInUseAuthorization];
        [_locationManager startMonitoringSignificantLocationChanges];
        [_locationManager startUpdatingLocation];
    }
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
//    
//    if([commonUtils getUserDefault:@"flag_location_query_enabled"] != nil && [[commonUtils getUserDefault:@"flag_location_query_enabled"] isEqualToString:@"1"]) {
        if([commonUtils getUserDefault:@"currentLatitude"] == nil || [commonUtils getUserDefault:@"currentLongitude"] == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location is required to share and discover content"
                                                            message:@"You must allow \"Malum\" to access your location to use this app."
                                                           delegate:self
                                                  cancelButtonTitle:@"Go to Settings"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    //}
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: UIApplicationOpenSettingsURLString]];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"didUpdateToLocation: %@", [locations lastObject]);
    CLLocation *currentLocation = [locations lastObject];
    if (currentLocation != nil) {
        
        BOOL locationChanged = NO;
        if(![commonUtils getUserDefault:@"currentLatitude"] || ![commonUtils getUserDefault:@"currentLongitude"]) {
            locationChanged = YES;
        } else if(![[commonUtils getUserDefault:@"currentLatitude"] isEqualToString:[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]] || ![[commonUtils getUserDefault:@"currentLongitude"] isEqualToString:[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]]) {
            locationChanged = YES;
        }
        if(locationChanged) {
            [commonUtils setUserDefault:@"currentLatitude" withFormat:[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]];
            [commonUtils setUserDefault:@"currentLongitude" withFormat:[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]];
        }
    }
    //[locationManager stopUpdatingLocation];
    [self updateUserLocation];
}

- (void)updateUserLocation {
    //for update user's coordinate automatically
//    NSString *msg = [NSString stringWithFormat:@"%@:%@", [commonUtils getUserDefault:@"currentLatitude"], [commonUtils getUserDefault:@"currentLongitude"]];
//    [commonUtils showAlert:@"Location Updated" withMessage:msg];
    
     NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[commonUtils getUserDefault:@"currentLatitude"] forKey:@"user_location_latitude"];
    [paramDic setObject:[commonUtils getUserDefault:@"currentLongitude"] forKey:@"user_location_longitude"];
    
    [self requestAPIMatchUsers:paramDic];
}
#pragma mark - API Request - User Rank Update
- (void)requestAPIMatchUsers:(NSMutableDictionary *)dic {
//    self.isLoadingBase = YES;
//    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestDataRank:) toTarget:self withObject:dic];
}
- (void)requestDataRank:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_MATCH_USERS withJSON:(NSMutableDictionary *) params];
//    self.isLoadingBase = NO;
//    [commonUtils hideActivityIndicator];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.alertBody = @"You can mulum now!";
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }
    } else {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.0];
    }
}





@end
