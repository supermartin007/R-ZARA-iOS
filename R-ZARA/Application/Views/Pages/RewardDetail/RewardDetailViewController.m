//
//  RewardDetailViewController.m
//  Malum
//
//  Created by Mars on 7/22/16.
//  Copyright © 2016 Mars. All rights reserved.
//

#import "RewardDetailViewController.h"

@interface RewardDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *rewardPictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *rewardNameLabel, *rewardCategoryLabel, *rewardPlaceLabel, *rewardLocalLabel, *rewardPointLabel;
@property (weak, nonatomic) IBOutlet UITextView *rewardDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *deleteBtnImage;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end

@implementation RewardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}
-(void)initUI{
    _rewardPictureImageView.image = _rewardPicture;
    _rewardNameLabel.text = _rewardName;
    _rewardCategoryLabel.text = _rewardCategory;
    _rewardPlaceLabel.text = _rewardPlace;
    _rewardLocalLabel.text = _rewardLocation;
    _rewardPointLabel.text =_rewardPoint;
    _rewardDescriptionTextView.text = _rewardDescription;
    if ([[appController.currentUser objectForKey:@"user_type"] isEqualToString:@"1"]) {
        _deleteBtn.userInteractionEnabled = YES;
        [_deleteBtnImage setHidden:YES];
    }else{
        _deleteBtn.userInteractionEnabled = NO;
        [_deleteBtnImage setHidden:NO];
    }
    
}
- (IBAction)rewardDownBtnOnClick:(id)sender {
    NSLog(@"Current user is %@", appController.currentUser);
    if ([[appController.currentUser objectForKey:@"user_malum_rank"] intValue] < [_rewardPoint intValue]) {
        [commonUtils showVAlertSimple:@"Warning" body:@"You could not get the reward with your points. Please try to get more points with Malum." duration:1.0];
    }else{
    if(self.isLoadingBase) return;
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
    [paramDic setObject:_rewardId forKey:@"rw_id"];
    
    [self requestAPIAddMyReward:paramDic];
    }
}
#pragma mark - API Request - User Rewards Saved
- (void)requestAPIAddMyReward:(NSMutableDictionary *)dic {
    self.isLoadingBase = YES;
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestDataReward:) toTarget:self withObject:dic];
}
- (void)requestDataReward:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_USER_ADD_REWARDS withJSON:(NSMutableDictionary *) params];
    self.isLoadingBase = NO;
    [commonUtils hideActivityIndicator];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            [commonUtils showVAlertSimple:@"Success" body:@"You  can receive service with this reward. Please check the information of reward and try to get the it!" duration:1.0];
        } else if ([status intValue] ==2){
            NSString *message = [result objectForKey:@"msg"];
            [commonUtils showVAlertSimple:@"Success" body:message duration:1.0];
        }
    } else {
        
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.0];
    }
}
- (IBAction)deleteRewardBtnOnClick:(id)sender {
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
