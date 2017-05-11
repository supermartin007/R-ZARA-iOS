//
//  AllUserTableViewCell.m
//  Malum
//
//  Created by Mars on 6/23/16.
//  Copyright © 2016 Mars. All rights reserved.
//

#import "AllUserTableViewCell.h"

@implementation AllUserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [commonUtils setRoundedRectBorderImage:_userPhotoImageView withBorderWidth:2.0f withBorderColor:appController.appMainColor withBorderRadius:_userPhotoImageView.frame.size.width / 2.0f];    // Configure the view for the selected state

}

@end
