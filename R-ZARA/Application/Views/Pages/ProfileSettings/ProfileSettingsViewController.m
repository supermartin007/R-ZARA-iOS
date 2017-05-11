//
//  ProfileSettingsViewController.m
//  Malum
//
//  Created by Mars on 6/17/16.
//  Copyright © 2016 Mars. All rights reserved.
//

#import "ProfileSettingsViewController.h"

@interface ProfileSettingsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *profileSettingBtn;
@property (weak, nonatomic) IBOutlet UIImageView *profilePhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userOccupationLabel;

@end

@implementation ProfileSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
 
    
    [self initUI];
}
-(void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"User Avatar = %@", appController.userAvator);
    
    if (appController.userAvator != nil) {
        _profilePhotoImageView.image = appController.userAvator;
    }else{
        NSLog(@"current_user%@", appController.currentUser);
        NSString *PhotoUrl;
        if ([[appController.currentUser objectForKey:@"user_photo_url"] rangeOfString:@"https://graph.facebook.com"].location == NSNotFound || [[appController.currentUser objectForKey:@"user_photo_url"] isEqualToString:@"0"]) {
            
            PhotoUrl = [NSString stringWithFormat:@"%@%@", MEDIA_URL_USERS,[ appController.currentUser objectForKey:@"user_photo_url"]];
            
        }else{
            NSLog(@"Facebook image url is!!!%@", [appController.currentUser objectForKey:@"user_photo_url"]);
            PhotoUrl = [NSString stringWithFormat:@"%@",[ appController.currentUser objectForKey:@"user_photo_url"]];
        }
        
        [commonUtils setImageViewAFNetworking:_profilePhotoImageView withImageUrl:PhotoUrl withPlaceholderImage:[UIImage imageNamed:@"user"]];
        
        
    }

//    if (appController.userAvator != nil) {
//        _profilePhotoImageView.image = appController.userAvator;
//    }else{
//        NSString *PhotoUrl;
//        if ([[appController.currentUser objectForKey:@"user_photo_url"] rangeOfString:@"https://graph.facebook.com"].location == NSNotFound) {
//            NSLog(@"photo url is %@", [appController.currentUser objectForKey:@"user_photo_url"]);
//            
//            if ([[appController.currentUser objectForKey:@"user_photo_url"] isEqualToString:@"0"]) {
//                PhotoUrl = nil;
//            }else{
//                PhotoUrl = [NSString stringWithFormat:@"%@%@", MEDIA_URL_USERS,[ appController.currentUser objectForKey:@"user_photo_url"]];
//            }
//            
//            
//        }else{
//            NSLog(@"Facebook image url is!!!%@", [appController.currentUser objectForKey:@"user_photo_url"]);
//            PhotoUrl = [NSString stringWithFormat:@"%@",[ appController.currentUser objectForKey:@"user_photo_url"]];
//        }
//
//        
//        if (PhotoUrl == nil) {
//            _profilePhotoImageView.image = [UIImage imageNamed:@"user.png"];
//        }else{
//            [commonUtils setImageViewAFNetworking:_profilePhotoImageView withImageUrl:PhotoUrl withPlaceholderImage:[UIImage imageNamed:@"user.png"]];
//        }
//    }
}
-(void)initUI{
    [commonUtils setRoundedRectBorderView:_profileSettingBtn withBorderWidth:0.0f withBorderColor:[UIColor clearColor] withBorderRadius:10.0f];
    [self.profileNameLabel setText:[appController.currentUser objectForKey:@"user_full_name"]];
    
    _userOccupationLabel.text = [appController.currentUser objectForKey:@"user_place"];
    [commonUtils setRoundedRectView:_profilePhotoImageView withCornerRadius:_profilePhotoImageView.frame.size.height/2.0f];
    
    NSString *PhotoUrl;
    if ([[appController.currentUser objectForKey:@"user_photo_url"] rangeOfString:@"https://graph.facebook.com"].location == NSNotFound) {
        NSLog(@"photo url is %@", [appController.currentUser objectForKey:@"user_photo_url"]);
        
        if ([[appController.currentUser objectForKey:@"user_photo_url"] isEqualToString:@"0"]) {
            PhotoUrl = nil;
        }else{
            PhotoUrl = [NSString stringWithFormat:@"%@%@", MEDIA_URL_USERS,[ appController.currentUser objectForKey:@"user_photo_url"]];
        }
        
        
    }else{
        NSLog(@"Facebook image url is!!!%@", [appController.currentUser objectForKey:@"user_photo_url"]);
        PhotoUrl = [NSString stringWithFormat:@"%@",[ appController.currentUser objectForKey:@"user_photo_url"]];
    }
    
    if (PhotoUrl == nil) {
        _profilePhotoImageView.image = [UIImage imageNamed:@"user.png"];
    }else{
        [commonUtils setImageViewAFNetworking:_profilePhotoImageView withImageUrl:PhotoUrl withPlaceholderImage:[UIImage imageNamed:@"user.png"]];
    }
    

    

//    NSLog(@"%@", [appController.currentUser objectForKey:@"user_photo_url"]);
//    if (![[appController.currentUser objectForKey:@"user_photo_url"] isEqualToString:@""]) {
//        NSString *imageUrl = [NSString stringWithFormat:@"%@%@", MEDIA_URL_USERS,[ appController.currentUser objectForKey:@"user_photo_url"]];
//        
//        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
//        [req addValue:@"image/*" forHTTPHeaderField:@"Accept"];
//        [_profilePhotoImageView setImageWithURLRequest:req placeholderImage:[UIImage imageNamed:@"user"] success:nil failure:nil];
//    }else{
//        _profilePhotoImageView.image = [UIImage imageNamed:@"user"];
//    }
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
