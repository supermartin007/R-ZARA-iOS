//
//  MyRewardViewController.m
//  Malum
//
//  Created by Mars on 7/25/16.
//  Copyright © 2016 Mars. All rights reserved.
//

#import "MyRewardViewController.h"
#import "RewardCollectionViewCell.h"
#import "MyRewardDetailViewController.h"
@interface MyRewardViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *myRewardCollectionView;
@property NSMutableArray *myRewards;

@end

@implementation MyRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated{
    if(self.isLoadingBase) return;
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
    
    [self requestAPIDownMyReward:paramDic];
}
#pragma mark - API Request - User Rewards
- (void)requestAPIDownMyReward:(NSMutableDictionary *)dic {
    self.isLoadingBase = YES;
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestDataReward:) toTarget:self withObject:dic];
}
- (void)requestDataReward:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_USER_REWARDS withJSON:(NSMutableDictionary *) params];
    self.isLoadingBase = NO;
    [commonUtils hideActivityIndicator];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            NSMutableArray *reward = [[NSMutableArray alloc] init];
            reward = [result objectForKey:@"user_rewards"];
            _myRewards = reward;
            [_myRewardCollectionView reloadData];
        }
    } else {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.0];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    return _myRewards.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    RewardCollectionViewCell *cell = (RewardCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"myrewardcell" forIndexPath:indexPath];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    dic = [_myRewards objectAtIndex:indexPath.row];
    
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@", MEDIA_URL_REWARDS,[ dic objectForKey:@"rw_icon_url"]];
    NSLog(@"%@", imageUrl);
    
    
    [commonUtils setImageViewAFNetworking:cell.rewardCellImageView withImageUrl:imageUrl withPlaceholderImage:[UIImage imageNamed:@"malum"]];
    cell.rewardNameLabel.text = [dic objectForKey:@"rw_name"];
    
    
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RewardCollectionViewCell *cell = (RewardCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"myrewardcell" forIndexPath:indexPath];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    dic = [_myRewards objectAtIndex:indexPath.row];
    
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@", MEDIA_URL_REWARDS,[ dic objectForKey:@"rw_icon_url"]];
    NSLog(@"%@", imageUrl);
    
    
    [commonUtils setImageViewAFNetworking:cell.rewardCellImageView withImageUrl:imageUrl withPlaceholderImage:[UIImage imageNamed:@"malum"]];
        cell.rewardNameLabel.text = [dic objectForKey:@"rw_name"];
    
    MyRewardDetailViewController *myRewardDetailView = [self.storyboard instantiateViewControllerWithIdentifier:@"myrewarddetail"];
    myRewardDetailView.rewardName = [dic objectForKey:@"rw_name"];
    myRewardDetailView.rewardCategory = [dic objectForKey:@"rw_category"];
    myRewardDetailView.rewardPlace = [dic objectForKey:@"rw_place_name"];
    myRewardDetailView.rewardLocation = [dic objectForKey:@"rw_location"];
    myRewardDetailView.rewardPoint = [dic objectForKey:@"rw_point"];
    myRewardDetailView.rewardDescription =[dic objectForKey:@"rw_description"];
    myRewardDetailView.rewardPicture = cell.rewardCellImageView.image;
    myRewardDetailView.rewardId = [dic objectForKey:@"rw_id"];
    
    [self.navigationController pushViewController:myRewardDetailView animated:YES];
    
    
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    int cell_width, cell_height;
    cell_width = (_myRewardCollectionView.frame.size.width - 5) / 2;
    cell_height = (_myRewardCollectionView.frame.size.width - 5) / 2 * 16 / 13;
    
    return CGSizeMake(cell_width, cell_height);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
