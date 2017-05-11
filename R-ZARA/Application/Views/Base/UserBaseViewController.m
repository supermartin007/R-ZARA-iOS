//
//  UserBaseViewController.m
//  Silver
//
//  Created by Silver on 1/9/15.
//  Copyright (c) 2015 Silver. All rights reserved.
//

#import "UserBaseViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface UserBaseViewController ()

@end

@implementation UserBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if([commonUtils getUserDefault:@"current_user_user_id"] != nil) {
        appController.currentUser = [commonUtils getUserDefaultDicByKey:@"current_user"];
        MySidePanelController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"sidePanel"];
        [self.navigationController presentViewController:panelController animated:NO completion: nil];
        return;
    }
    if([[commonUtils getUserDefault:@"logged_out"] isEqualToString:@"1"]) {
        [commonUtils removeUserDefault:@"logged_out"];
        //        [[FBSession activeSession] closeAndClearTokenInformation];
        //        [FBSession setActiveSession:nil];
        
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logOut];
//        [self.navigationController popToRootViewControllerAnimated:NO];
        

    
        
    }
    
    self.isLoadingUserBase = NO;

}

//- (void)loggedOut {
//    if([[commonUtils getUserDefault:@"logged_out"] isEqualToString:@"1"]) {
//        [commonUtils removeUserDefault:@"logged_out"];
//        [self.navigationController popToRootViewControllerAnimated:NO];
//    }
//}
- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Nagivate Events
- (void) navToMainView {
    appController.currentMenuTag = @"1";
    MySidePanelController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"sidePanel"];
    [self.navigationController presentViewController:panelController animated:YES completion: nil];
}


//#pragma mark - Nagivate Events
//- (void)navToMainView {
//    appController.currentMenuTag = @"1";
//    if([commonUtils isUserLoggedIn]) {
//        [self updateLocation];
//        MySidePanelController *panelController = [self.storyboard instantiateViewControllerWithIdentifier:@"sidePanel"];
//        [self.navigationController presentViewController:panelController animated:NO completion: nil];
//        return;
//    }
//}

- (void)updateLocation {
//    [commonUtils setUserDefault:@"flag_location_query_enabled" withFormat:@"1"];
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateLocationManager];
}

- (IBAction)menuBackClicked:(id)sender {
    if(self.isLoadingUserBase) return;
    [self.navigationController popViewControllerAnimated:YES];
}

@end