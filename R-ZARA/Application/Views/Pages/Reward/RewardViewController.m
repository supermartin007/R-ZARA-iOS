//
//  RewardViewController.m
//  Malum
//
//  Created by Mars on 6/17/16.
//  Copyright © 2016 Mars. All rights reserved.
//

#import "RewardViewController.h"
#import "RewardCellViewController.h"

@interface RewardViewController ()
@property (weak, nonatomic) IBOutlet UIView *localView, *entertaimmentView, *onlineView, *foodView, *apparelView;
@property (strong, nonatomic) NSMutableArray *allArray, *entertainmentArray, *onlineArray, *foodArray, *apparelArray;
@property (weak, nonatomic) IBOutlet UILabel *localLabel;

@end

@implementation RewardViewController
@synthesize allArray, entertainmentArray, onlineArray, foodArray, apparelArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
}
-(void)initUI{
    _localView.layer.borderColor = [UIColor whiteColor].CGColor;
    _localView.layer.borderWidth = 1.0f;
    _entertaimmentView.layer.borderColor = [UIColor whiteColor].CGColor;
    _entertaimmentView.layer.borderWidth = 1.0f;

    _onlineView.layer.borderColor = [UIColor whiteColor].CGColor;
    _onlineView.layer.borderWidth = 1.0f;
    
    _foodView.layer.borderColor = [UIColor whiteColor].CGColor;
    _foodView.layer.borderWidth = 1.0f;
    
    _apparelView.layer.borderColor = [UIColor whiteColor].CGColor;
    _apparelView.layer.borderWidth = 1.0f;

}
-(void)initData{
    allArray = [[NSMutableArray alloc] init];
    entertainmentArray = [[NSMutableArray alloc] init];
    onlineArray = [[NSMutableArray alloc] init];
    foodArray = [[NSMutableArray alloc] init];
    apparelArray = [[NSMutableArray alloc] init];
}
-(void)viewWillAppear:(BOOL)animated{
    allArray = [[NSMutableArray alloc] init];
    entertainmentArray = [[NSMutableArray alloc] init];
    onlineArray = [[NSMutableArray alloc] init];
    foodArray = [[NSMutableArray alloc] init];
    apparelArray = [[NSMutableArray alloc] init];
    if(self.isLoadingBase) return;
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
    
    [self requestAPIDownReward:paramDic];
    
}
#pragma mark - API Request - User Rewards
- (void)requestAPIDownReward:(NSMutableDictionary *)dic {
    self.isLoadingBase = YES;
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestDataReward:) toTarget:self withObject:dic];
}
- (void)requestDataReward:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_ALL_REWARDS withJSON:(NSMutableDictionary *) params];
    self.isLoadingBase = NO;
    [commonUtils hideActivityIndicator];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            _localLabel.text = [result objectForKey:@"user_rewards_location"];
            appController.allRewardArray = [result objectForKey:@"user_rewards"];
            for (int i=0; i <appController.allRewardArray.count; i++) {
                NSString *category;
                category = [[appController.allRewardArray objectAtIndex:i] objectForKey:@"rw_category"];
                if ([category isEqualToString:@"Entertainment"]) {
                    [entertainmentArray addObject:[appController.allRewardArray objectAtIndex:i]];
                }
                if ([category isEqualToString:@"Online"]) {
                    [onlineArray addObject:[appController.allRewardArray objectAtIndex:i]];

                }
                if ([category isEqualToString:@"Food"]) {
                    [foodArray addObject:[appController.allRewardArray objectAtIndex:i]];

                }
                if ([category isEqualToString:@"Apparel"]) {
                    [apparelArray addObject:[appController.allRewardArray objectAtIndex:i]];

                }
            }
            appController.entertainment = entertainmentArray;
            appController.online = onlineArray;
            appController.food = foodArray;
            appController.apparel = apparelArray;
            
            NSLog(@"array is !!!%@", appController.entertainment);
            
        }
    } else {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.0];
    }
}
-(IBAction)ButtonClick:(id)sender{
    UIButton *button=(UIButton *)sender;
    
    if ([button tag] == 0) {
        if (entertainmentArray == nil) {
            [commonUtils showVAlertSimple:@"Alert" body:@"You could not the get the entertainment rewards with your points in your location" duration:1.0];
        }else{
            RewardCellViewController *rewardsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rewardcellview"];
            rewardsViewController.categoryIndex = [button tag];
            rewardsViewController.category = @"Entertainment";
            [self.navigationController pushViewController:rewardsViewController animated:YES];
        }
        
    }else if ([button tag] == 1){
        if (entertainmentArray == nil) {
            [commonUtils showVAlertSimple:@"Alert" body:@"You could not the get the entertainment rewards with your points in your location" duration:1.0];
        }else{
            RewardCellViewController *rewardsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rewardcellview"];
            rewardsViewController.categoryIndex = [button tag];
            rewardsViewController.category = @"Online";
            [self.navigationController pushViewController:rewardsViewController animated:YES];
        }
        
    }else if ([button tag] == 2){
        if (entertainmentArray == nil) {
            [commonUtils showVAlertSimple:@"Alert" body:@"You could not the get the entertainment rewards with your points in your location" duration:1.0];
        }else{
            RewardCellViewController *rewardsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rewardcellview"];
            rewardsViewController.categoryIndex = [button tag];
            rewardsViewController.category = @"Food";
            [self.navigationController pushViewController:rewardsViewController animated:YES];
        }
        
    }else if ([button tag] == 3){
        if (entertainmentArray == nil) {
            [commonUtils showVAlertSimple:@"Alert" body:@"You could not the get the entertainment rewards with your points in your location" duration:1.0];
        }else{
            RewardCellViewController *rewardsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rewardcellview"];
            rewardsViewController.categoryIndex = [button tag];
            rewardsViewController.category = @"Apparel";
            [self.navigationController pushViewController:rewardsViewController animated:YES];
        }
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
