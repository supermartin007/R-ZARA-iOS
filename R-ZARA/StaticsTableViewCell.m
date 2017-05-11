//
//  StaticsTableViewCell.m
//  Malum
//
//  Created by Mars on 8/1/16.
//  Copyright © 2016 Mars. All rights reserved.
//

#import "StaticsTableViewCell.h"

@implementation StaticsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [commonUtils setRoundedRectBorderImage:_photoImageView withBorderWidth:2.0f withBorderColor:appController.appMainColor withBorderRadius:_photoImageView.frame.size.width / 2.0f];    // Configure the view for the selected state

}

@end
