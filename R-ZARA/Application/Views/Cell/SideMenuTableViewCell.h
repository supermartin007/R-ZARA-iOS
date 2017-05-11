//
//  SideMenuTableViewCell.h
//  Silver
//
//  Created by Silver on 4/5/15.
//  Copyright (c) 2015 Silver. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenuTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;
@property (nonatomic, strong) IBOutlet UILabel *bgLabel, *titleLabel;
@property (nonatomic, strong) IBOutlet UIView *containerView;

@end