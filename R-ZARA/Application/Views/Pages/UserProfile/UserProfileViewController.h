//
//  UserProfileViewController.h
//  Malum
//
//  Created by Mars on 6/23/16.
//  Copyright © 2016 Mars. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileViewController : BaseViewController
@property(nonatomic, assign) NSUInteger userIndex;
@property (nonatomic , strong) UIImage *userPicture;
@property (nonatomic, strong) NSString *userName, *userOccupation, *userMalumName, *userMalumAddress;
@end
