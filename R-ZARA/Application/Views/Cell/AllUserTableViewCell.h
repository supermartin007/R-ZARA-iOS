//
//  AllUserTableViewCell.h
//  Malum
//
//  Created by Mars on 6/23/16.
//  Copyright © 2016 Mars. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllUserTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userPhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *addFriendBtn;

@end
