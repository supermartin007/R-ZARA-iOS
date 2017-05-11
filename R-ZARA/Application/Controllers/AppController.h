//  AppController.h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppController : NSObject

@property (nonatomic, strong) NSMutableArray *introSliderImages, *datas;
@property (nonatomic, strong) NSMutableDictionary *currentUser, *apnsMessage;
@property (nonatomic, strong) NSMutableArray *menuPages, *ownermenuPages;
@property (nonatomic, strong) UIImage *editProfileImage;
@property (nonatomic, assign) NSUInteger firstTime, lastTime, timedifference;


// Temporary Variables
@property (nonatomic, strong) NSString *currentUserType, *currentMenuTag, *points;
@property (nonatomic, assign) BOOL isMyProfileChanged, isPushedFromForgotPasswordSet, isForgotPasswordSet, isPushedFromRegister, isPushedFromLogin;
@property (nonatomic, strong) NSMutableDictionary *selectedUser;
@property (nonatomic, strong) NSMutableArray *allUsers, *userFriends;
@property (nonatomic, strong) UIImage *userAvator;
@property (nonatomic, strong) NSMutableArray *allRewardArray, *entertainment, *food, *online, *apparel;


// Utility Variables
@property (nonatomic, strong) UIColor *appMainColor, *appTextColor, *appThirdColor;
@property (nonatomic, strong) DoAlertView *vAlert;

+ (AppController *)sharedInstance;

@end