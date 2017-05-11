//
//  AllTableViewCell.m
//  Malum
//
//  Created by Mars on 6/25/16.
//  Copyright © 2016 Mars. All rights reserved.
//

#import "AllTableViewCell.h"

@implementation AllTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    [commonUtils setRoundedRectBorderImage:_allPhotoImageView withBorderWidth:2.0f withBorderColor:appController.appMainColor withBorderRadius:_allPhotoImageView.frame.size.width / 2.0f];
}

@end
