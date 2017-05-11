//
//  UserBaseViewController.h
//  Silver
//
//
//  Created by Silver on 1/9/15.
//  Copyright (c) 2015 Silver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface UserBaseViewController : UIViewController

@property (nonatomic, assign) BOOL isLoadingUserBase;

@property (nonatomic, strong) IBOutlet UIScrollView *containerScrollView;
@property (nonatomic, strong) IBOutlet UIView *topNavBarView, *containerView, *contentView, *noContentView;

- (void)navToMainView;
- (IBAction)menuBackClicked:(id)sender;
//- (void) loggedOut;

@end
