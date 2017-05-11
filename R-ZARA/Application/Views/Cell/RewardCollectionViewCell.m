//
//  RewardCollectionViewCell.m
//  Malum
//
//  Created by Mars on 7/20/16.
//  Copyright © 2016 Mars. All rights reserved.
//

#import "RewardCollectionViewCell.h"

@implementation RewardCollectionViewCell

- (void)awakeFromNib {
    
    [self initView];
}

- (void)initView {
    [commonUtils setRoundedRectBorderView:_containerView withBorderWidth:2.0f withBorderColor:[UIColor darkGrayColor] withBorderRadius:0.0f];
}

@end
