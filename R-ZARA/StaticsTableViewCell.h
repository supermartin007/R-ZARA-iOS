//
//  StaticsTableViewCell.h
//  Malum
//
//  Created by Mars on 8/1/16.
//  Copyright © 2016 Mars. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StaticsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userRankLable;

@end
