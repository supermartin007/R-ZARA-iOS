//
//  RewardCellViewController.m
//  Malum
//
//  Created by Mars on 7/20/16.
//  Copyright © 2016 Mars. All rights reserved.
//

#import "RewardCellViewController.h"
#import "RewardCollectionViewCell.h"
#import "RewardDetailViewController.h"

@interface RewardCellViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *rewardCollectionView;
@property (nonatomic, strong) NSMutableArray *rewardCellArray;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;

@end

@implementation RewardCellViewController
@synthesize rewardCellArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
    // Do any additional setup after loading the view.
}
-(void)initUI{
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)_rewardCollectionView.collectionViewLayout;
    
//    CGFloat availableWidthForCells = CGRectGetWidth(_rewardCollectionView.frame) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (kCellsPerRow - 1);
//    CGFloat cellWidth = availableWidthForCells / (float)kCellsPerRow;
    
//    CGFloat cellHeight = cellWidth;
//    
//    flowLayout.itemSize = CGSizeMake(cellWidth, cellHeight);
    
    _categoryLabel.text = _category;
    
    
}
-(void)initData{
    rewardCellArray = [[NSMutableArray alloc] init];
    switch (_categoryIndex) {
        case 0:
            rewardCellArray = appController.entertainment;
            break;
        case 1:
            rewardCellArray = appController.online;
            break;
        case 2:
            rewardCellArray = appController.food;
            break;
        case 3:
            rewardCellArray = appController.apparel;
            break;
            
        default:
            break;
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    return rewardCellArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    RewardCollectionViewCell *cell = (RewardCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"rewardcell" forIndexPath:indexPath];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    dic = [rewardCellArray objectAtIndex:indexPath.row];
    
     NSString *imageUrl = [NSString stringWithFormat:@"%@%@", MEDIA_URL_REWARDS,[ dic objectForKey:@"rw_icon_url"]];
    NSLog(@"%@", imageUrl);
   
    
    [commonUtils setImageViewAFNetworking:cell.rewardCellImageView withImageUrl:imageUrl withPlaceholderImage:[UIImage imageNamed:@"malum"]];
    cell.rewardNameLabel.text = [dic objectForKey:@"rw_name"];
    

    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RewardCollectionViewCell *cell = (RewardCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"rewardcell" forIndexPath:indexPath];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    dic = [rewardCellArray objectAtIndex:indexPath.row];
    
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@", MEDIA_URL_REWARDS,[ dic objectForKey:@"rw_icon_url"]];
    NSLog(@"%@", imageUrl);
    
    
    [commonUtils setImageViewAFNetworking:cell.rewardCellImageView withImageUrl:imageUrl withPlaceholderImage:[UIImage imageNamed:@"malum"]];
//    cell.rewardNameLabel.text = [dic objectForKey:@"rw_name"];
    
    RewardDetailViewController *rewardDetailView = [self.storyboard instantiateViewControllerWithIdentifier:@"rewarddetail"];
    rewardDetailView.rewardName = [dic objectForKey:@"rw_name"];
    rewardDetailView.rewardCategory = [dic objectForKey:@"rw_category"];
    rewardDetailView.rewardPlace = [dic objectForKey:@"rw_place_name"];
    rewardDetailView.rewardLocation = [dic objectForKey:@"rw_location"];
    rewardDetailView.rewardPoint = [dic objectForKey:@"rw_point"];
    rewardDetailView.rewardDescription =[dic objectForKey:@"rw_description"];
    rewardDetailView.rewardPicture = cell.rewardCellImageView.image;
    rewardDetailView.rewardId = [dic objectForKey:@"rw_id"];
    
    [self.navigationController pushViewController:rewardDetailView animated:YES];


    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    int cell_width, cell_height;
    cell_width = (_rewardCollectionView.frame.size.width - 5) / 2;
    cell_height = (_rewardCollectionView.frame.size.width - 5) / 2 * 16 / 13;
    
    return CGSizeMake(cell_width, cell_height);
    
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
