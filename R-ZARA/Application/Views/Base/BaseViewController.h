//
//  BaseViewController.h
//  Silver
//
//  Created by Silver on 1/9/15.
//  Copyright (c) 2015 Silver. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, assign) BOOL isLoadingBase;

@property (nonatomic, strong) IBOutlet UIScrollView *containerScrollView;
@property (nonatomic, strong) IBOutlet UIView *topNavBarView, *containerView, *contentView, *noContentView;

- (IBAction)menuClicked:(id)sender;
- (IBAction)menuBackClicked:(id)sender;
- (IBAction)menuDismissClicked:(id)sender;
- (IBAction)onClickLogOut:(id)sender;

@end
