//
//  UserProfileViewController.m
//  Malum
//
//  Created by Mars on 6/23/16.
//  Copyright © 2016 Mars. All rights reserved.
//

#import "UserProfileViewController.h"

@interface UserProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userPhotoImageView;
@property (weak, nonatomic) IBOutlet UIView *profileView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel, *userOccupationLabel, *userMalumNameLabel, *userMalumAddressLabel;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self LoadData];
    [self initUI];
}
-(void)initUI{
    [commonUtils setRoundedRectBorderImage:_userPhotoImageView withBorderWidth:2.0f withBorderColor:appController.appMainColor withBorderRadius:_userPhotoImageView.frame.size.width / 2.0f];
    _profileView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _profileView.layer.borderWidth = 2.0f;
    _profileView.layer.cornerRadius = 10.0f;
    
    _userPhotoImageView.image = _userPicture;
    _userNameLabel.text = _userName;
    _userOccupationLabel.text = _userOccupation;
    _userMalumNameLabel.text = _userMalumName;
    _userMalumAddressLabel.text = _userMalumAddress;
    
  

}
-(void)LoadData{
  
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
