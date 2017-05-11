//
//  MyRewardDetailViewController.m
//  Malum
//
//  Created by Mars on 7/25/16.
//  Copyright © 2016 Mars. All rights reserved.
//

#import "MyRewardDetailViewController.h"

@interface MyRewardDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *rewardPictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *rewardNameLabel, *rewardCategoryLabel, *rewardPlaceLabel, *rewardLocalLabel, *rewardPointLabel;
@property (weak, nonatomic) IBOutlet UITextView *rewardDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;


@end

@implementation MyRewardDetailViewController

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
    [commonUtils setRoundedRectBorderView:_doneBtn withBorderWidth:1.0f withBorderColor:[UIColor whiteColor] withBorderRadius:_doneBtn.layer.frame.size.height/2.0f];
    
    NSLog(@"Reward ID is %@", _rewardId);
    
}
- (IBAction)doneBtnOnClick:(id)sender {
    if(self.isLoadingBase) return;
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
    [paramDic setObject:_rewardId forKey:@"rw_id"];
    
    [self requestAPIRemoveMyReward:paramDic];
}
#pragma mark - API Request - User Rewards Remove
- (void)requestAPIRemoveMyReward:(NSMutableDictionary *)dic {
    self.isLoadingBase = YES;
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestDataReward:) toTarget:self withObject:dic];
}
- (void)requestDataReward:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_USER_REWARD_REMOVE withJSON:(NSMutableDictionary *) params];
    self.isLoadingBase = NO;
    [commonUtils hideActivityIndicator];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            [commonUtils showVAlertSimple:@"Success" body:@"You  has gotton reward!" duration:1.0];
        }
    } else {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.0];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
