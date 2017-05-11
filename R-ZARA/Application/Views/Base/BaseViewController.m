//
//  BaseViewController.m
//  Silver
//
//  Created by Silver on 1/9/15.
//  Copyright (c) 2015 Silver. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if([commonUtils getUserDefault:@"current_user_user_id"] != nil) {
                    appController.currentUser = [commonUtils getUserDefaultDicByKey:@"current_user"];
        appController.points = [appController.currentUser objectForKey:@"user_malum_rank"];
                } else {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
//    if(![commonUtils checkKeyInDic:@"user_id" inDic:appController.currentUser] || ![commonUtils checkKeyInDic:@"user_photo_url" inDic:appController.currentUser] || ![commonUtils checkKeyInDic:@"user_full_name" inDic:appController.currentUser]) {
//        if([commonUtils getUserDefault:@"current_user_user_id"] != nil) {
//            appController.currentUser = [commonUtils getUserDefaultDicByKey:@"current_user"];
//        } else {
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }
//    }
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.isLoadingBase = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
}
- (BOOL)prefersStatusBarHidden {
    return NO;
}

# pragma Top Menu Events
- (IBAction)menuClicked:(id)sender {
    if(self.isLoadingBase) return;
    [self.sidePanelController showLeftPanelAnimated: YES];
}
- (IBAction)menuBackClicked:(id)sender {
    if(self.isLoadingBase) return;
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)menuDismissClicked:(id)sender {
    if(self.isLoadingBase) return;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Log Out
- (IBAction)onClickLogOut:(id)sender {
    if(self.isLoadingBase) return;
    
    [commonUtils removeUserDefaultDic:@"current_user"];
    [commonUtils removeUserDefault:@"flag_location_query_enabled"];
    appController.currentUser = [[NSMutableDictionary alloc] init];
    appController.currentUserType = @"";
    [commonUtils setUserDefault:@"logged_out" withFormat:@"1"];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
