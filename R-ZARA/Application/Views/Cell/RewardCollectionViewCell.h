//
//  RewardCollectionViewCell.h
//  Malum
//
//  Created by Mars on 7/20/16.
//  Copyright © 2016 Mars. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RewardCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *rewardCellImageView;
@property (weak, nonatomic) IBOutlet UILabel *rewardNameLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
