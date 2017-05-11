//
//  FriendStatisticsTableViewCell.m
//  Malum
//
//  Created by Mars on 6/25/16.
//  Copyright © 2016 Mars. All rights reserved.
//

#import "FriendStatisticsTableViewCell.h"

@implementation FriendStatisticsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   [commonUtils setRoundedRectBorderImage:_FriendsPhotoImageView withBorderWidth:2.0f withBorderColor:appController.appMainColor withBorderRadius:_FriendsPhotoImageView.frame.size.width / 2.0f];}

@end
