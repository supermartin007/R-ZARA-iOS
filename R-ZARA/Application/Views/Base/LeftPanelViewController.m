//
//  LeftPanelViewController.m
//  Silver
//
//  Created by Silver on 1/15/15.
//  Copyright (c) 2015 Silver. All rights reserved.
//

#import "LeftPanelViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SideMenuTableViewCell.h"
#import "MySidePanelController.h"
#import "HomeViewController.h"
#import "ProfileSettingsViewController.h"
#import "FriendsViewController.h"
#import "AllUserViewController.h"
#import "StatisticsViewController.h"
#import "PostRewardViewController.h"
#import "MyRewardViewController.h"
#import "AppDelegate.h"

@interface LeftPanelViewController () {
    float bottom_margin;
}

@property (nonatomic, strong) IBOutlet UITableView *menuTableView;
@property (nonatomic, strong) NSMutableArray *menuPages, *ownermenuPages;

@property (nonatomic, strong) IBOutlet UIView *containerView, *topView, *userPhotoContainerInnerView, *userPhotoContainerView;
@property (nonatomic, strong) IBOutlet UILabel *userNameLabel, *userAboutLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userPhotoImageView;


@end

@implementation LeftPanelViewController
@synthesize menuPages, ownermenuPages;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.sidePanelController.slideDelegate = self;
    bottom_margin = (IS_IPHONE_6_OR_ABOVE ? 88.0f : 40.0f);
    
    menuPages = [[NSMutableArray alloc] init];
    menuPages = [appController.menuPages mutableCopy];
    ownermenuPages = [[NSMutableArray alloc] init];
    ownermenuPages = [appController.ownermenuPages mutableCopy];
    
    
    
    
    [self initView];
}
-(void)viewWillAppear:(BOOL)animated{
    
    if (appController.userAvator != nil) {
        _userPhotoImageView.image = appController.userAvator;
    }else{
        
        NSString *PhotoUrl;
        if ([[appController.currentUser objectForKey:@"user_photo_url"] rangeOfString:@"https://graph.facebook.com"].location == NSNotFound || [[appController.currentUser objectForKey:@"user_photo_url"] isEqualToString:@"0"]) {
            
            PhotoUrl = [NSString stringWithFormat:@"%@%@", MEDIA_URL_USERS,[ appController.currentUser objectForKey:@"user_photo_url"]];
            
        }else{
            NSLog(@"Facebook image url is!!!%@", [appController.currentUser objectForKey:@"user_photo_url"]);
            PhotoUrl = [NSString stringWithFormat:@"%@",[ appController.currentUser objectForKey:@"user_photo_url"]];
        }
        
        [commonUtils setImageViewAFNetworking:_userPhotoImageView withImageUrl:PhotoUrl withPlaceholderImage:[UIImage imageNamed:@"user"]];
        
//        if (![[appController.currentUser objectForKey:@"user_photo_url"] isEqualToString:@""]) {
//            NSString *imageUrl = [NSString stringWithFormat:@"%@%@", MEDIA_URL_USERS,[ appController.currentUser objectForKey:@"user_photo_url"]];
//            
//            NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
//            [req addValue:@"image/*" forHTTPHeaderField:@"Accept"];
//            [_userPhotoImageView setImageWithURLRequest:req placeholderImage:[UIImage imageNamed:@"user"] success:nil failure:nil];
//        }else{
//            _userPhotoImageView.image = [UIImage imageNamed:@"user"];
//        }
        
    }
}

- (void)initView {

    [commonUtils cropCircleView:self.userPhotoContainerView];
    [commonUtils cropCircleView:self.userPhotoContainerInnerView];
    [commonUtils setRoundedRectView:_userPhotoImageView withCornerRadius:_userPhotoImageView.frame.size.height/2.0f];
    
    [self.userNameLabel setText:[appController.currentUser objectForKey:@"user_full_name"]];
    
    NSString *PhotoUrl;
    if ([[appController.currentUser objectForKey:@"user_photo_url"] rangeOfString:@"https://graph.facebook.com"].location == NSNotFound || [[appController.currentUser objectForKey:@"user_photo_url"] isEqualToString:@"0"]) {
        PhotoUrl = [NSString stringWithFormat:@"%@%@", MEDIA_URL_USERS,[ appController.currentUser objectForKey:@"user_photo_url"]];
        
    }else{
        NSLog(@"Facebook image url is!!!%@", [appController.currentUser objectForKey:@"user_photo_url"]);
        PhotoUrl = [NSString stringWithFormat:@"%@",[ appController.currentUser objectForKey:@"user_photo_url"]];
    }
    
    [commonUtils setImageViewAFNetworking:_userPhotoImageView withImageUrl:PhotoUrl withPlaceholderImage:[UIImage imageNamed:@"user"]];

    
//    if (![[appController.currentUser objectForKey:@"user_photo_url"] isEqualToString:@""]) {
//        NSString *imageUrl = [NSString stringWithFormat:@"%@%@", MEDIA_URL_USERS,[ appController.currentUser objectForKey:@"user_photo_url"]];
//        
//        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
//        [req addValue:@"image/*" forHTTPHeaderField:@"Accept"];
//        [_userPhotoImageView setImageWithURLRequest:req placeholderImage:[UIImage imageNamed:@"user"] success:nil failure:nil];
//    }else{
//        _userPhotoImageView.image = [UIImage imageNamed:@"user"];
//    }



    
}

- (void)viewDidLayoutSubviews {
    CGRect containerFrame = self.containerView.frame;
    containerFrame.size.width = self.sidePanelController.leftVisibleWidth;
    [self.containerView setFrame:containerFrame];
    
    CGRect topFrame = self.topView.frame;
    [self.topView setFrame:CGRectMake(0, 0, containerFrame.size.width, topFrame.size.height)];
    
    [self.menuTableView setFrame: CGRectMake(0, self.topView.frame.size.height, containerFrame.size.width, containerFrame.size.height - topFrame.size.height-25.0f)]; //- bottom_margin)];

    
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rownum;
    if ([[appController.currentUser objectForKey:@"user_type"] isEqualToString:@"1"]) {
        rownum = (int)[ownermenuPages count];
    }else{
        rownum = (int)[menuPages count];
    }
    return rownum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int height;
    if ([[appController.currentUser objectForKey:@"user_type"] isEqualToString:@"1"]) {
        height = (int)tableView.frame.size.height / (float)[ownermenuPages count];
    }else{
         height = (int)tableView.frame.size.height / (float)[menuPages count];
    }
    return height;//tableView.frame.size.height / (float)[menuPages count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(SideMenuTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (SideMenuTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SideMenuTableViewCell *cell = (SideMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"sideMenuCell"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    if ([[appController.currentUser objectForKey:@"user_type"] isEqualToString:@"1"]) {
       dic = [ownermenuPages objectAtIndex:indexPath.row];
    }else{
       dic = [menuPages objectAtIndex:indexPath.row];
    }
    //NSMutableDictionary *dic = [menuPages objectAtIndex:indexPath.row];
    
    [cell setTag:[[dic objectForKey:@"tag"] intValue]];
    [cell.titleLabel setText: [dic objectForKey:@"title"]];
    
    NSString *icon = [dic objectForKey:@"icon"];
    if([appController.currentMenuTag isEqualToString:[dic objectForKey:@"tag"]]) {
        icon = [icon stringByAppendingString:@"_active"];
        [cell.titleLabel setTextColor:RGBA(15, 112, 183, 1)];
    } else {
        [cell.titleLabel setTextColor:RGBA(117, 120, 123, 1)];
    }
    [cell.iconImageView setImage:[UIImage imageNamed:icon]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Page Transition

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SideMenuTableViewCell *cell = (SideMenuTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if ([[appController.currentUser objectForKey:@"user_type"] isEqualToString:@"1"]) {
        appController.currentMenuTag = [[ownermenuPages objectAtIndex:indexPath.row] objectForKey:@"tag"];
        [tableView reloadData];

    }else{
        appController.currentMenuTag = [[menuPages objectAtIndex:indexPath.row] objectForKey:@"tag"];
        [tableView reloadData];

    }

//    appController.currentMenuTag = [[menuPages objectAtIndex:indexPath.row] objectForKey:@"tag"];
//    [tableView reloadData];
    
    HomeViewController *homeViewController;
    ProfileSettingsViewController *profileViewController;
    FriendsViewController * friendsViewController;
    AllUserViewController *allUserViewController;
    StatisticsViewController *statisticsViewController;
    PostRewardViewController *postRewardViewContrller;
    MyRewardViewController *myRewardViewController;
    
    UINavigationController *navController;
    
    switch (cell.tag) {
        case 1:
            homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeview"];
            navController = [[UINavigationController alloc] initWithRootViewController: homeViewController];
            self.sidePanelController.centerPanel = navController;
            break;
        case 2:
            profileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"profileview"];
                        
            navController = [[UINavigationController alloc] initWithRootViewController: profileViewController];
            self.sidePanelController.centerPanel = navController;
            break;
        case 3:
            friendsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"friendsview"];
            navController = [[UINavigationController alloc] initWithRootViewController: friendsViewController];
            self.sidePanelController.centerPanel = navController;
            break;
        case 4:
            statisticsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"statisticsview"];
            navController = [[UINavigationController alloc] initWithRootViewController: statisticsViewController];
            self.sidePanelController.centerPanel = navController;
            break;
        case 5:
            allUserViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"alluserview"];
            navController = [[UINavigationController alloc] initWithRootViewController: allUserViewController];
            self.sidePanelController.centerPanel = navController;
            break;
        case 6:
        myRewardViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"myreward"];
        navController = [[UINavigationController alloc] initWithRootViewController: myRewardViewController];
        self.sidePanelController.centerPanel = navController;
        break;
        case 7:
            postRewardViewContrller = [self.storyboard instantiateViewControllerWithIdentifier:@"postview"];
            navController = [[UINavigationController alloc] initWithRootViewController: postRewardViewContrller];
            self.sidePanelController.centerPanel = navController;
            break;
            
        default:
            break;
    }
    
}

#pragma mark -  Left Side Menu Show

- (void)onMenuShow {
//    if([commonUtils getUserDefault:@"is_my_profile_changed"]) {
//        [commonUtils removeUserDefault:@"is_my_profile_changed"];
//        [self initView];
//    }
}
- (IBAction)LogOutBtnOnClick:(id)sender {
    [self jumpToLoginView];
}
#pragma mark - Events
- (void)jumpToLoginView {
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rootNav"];
      AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
     [appDelegate.window addSubview:viewController.view];
      appDelegate.window.rootViewController = viewController;
//    [appDelegate.window makeKeyAndVisible];
    
//    [self.navigationController.tabBarController dismissViewControllerAnimated:NO completion:nil];
}
- (void)onMenuHide {

}

@end

