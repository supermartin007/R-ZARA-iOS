//
//  LoginViewController.m
//  Malum
//
//  Created by Mars on 6/16/16.
//  Copyright © 2016 Mars. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>{
     UITextField *currentTextField;
}
@property (weak, nonatomic) IBOutlet UIButton *facebookLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *emailLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField, *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];


}
-(void)initUI{
    [commonUtils setRoundedRectBorderView:_emailLoginBtn withBorderWidth:0.0f withBorderColor:[UIColor clearColor] withBorderRadius:10.0f];
    [commonUtils setRoundedRectBorderView:_facebookLoginBtn withBorderWidth:0.0f withBorderColor:[UIColor clearColor] withBorderRadius:10.0f];

}
- (IBAction)EmailLoginBtnOnClick:(id)sender {
    
    if(self.isLoadingUserBase) return;
    
    if([commonUtils getUserDefault:@"currentLatitude"] != nil && [commonUtils getUserDefault:@"currentLongitude"] != nil) {
        if([commonUtils isFormEmpty:[@[self.emailTextField.text, self.passwordTextField.text] mutableCopy]]) {
            [commonUtils showVAlertSimple:@"Warning" body:@"Please complete entire form" duration:1.2];
        } else if(![commonUtils validateEmail:self.emailTextField.text]) {
            [commonUtils showVAlertSimple:@"Warning" body:@"Email address is not in a vaild format" duration:1.2];
        } else if([self.passwordTextField.text length] < 6 || [self.passwordTextField.text length] > 10) {
            [commonUtils showVAlertSimple:@"Warning" body:@"Password length must be between 6 and 10 characters" duration:1.2];
        } else {
            
            NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
            [paramDic setObject:self.emailTextField.text forKey:@"user_email"];
            [paramDic setObject:self.passwordTextField.text forKey:@"user_password"];
            [paramDic setObject:[commonUtils getUserDefault:@"currentLatitude"] forKey:@"user_location_latitude"];
            [paramDic setObject:[commonUtils getUserDefault:@"currentLongitude"]  forKey:@"user_location_longitude"];
            
//            [paramDic setObject:@"29.760212" forKey:@"user_location_latitude"];
//            [paramDic setObject:@"-95.369456"  forKey:@"user_location_longitude"];
            [self requestAPILogin:paramDic];
            
//            if([commonUtils getUserDefault:@"user_apns_id"] != nil) {
//                [paramDic setObject:[commonUtils getUserDefault:@"user_apns_id"] forKey:@"user_apns_id"];
//                [self requestAPILogin:paramDic];
//            } else {
//                [appController.vAlert doAlert:@"Notice" body:@"Failed to get your device token.\nTherefore, you will not be able to receive notification for the new activities." duration:2.0f done:^(DoAlertView *alertView) {
//                    [self requestAPILogin:paramDic];
//                }];
//            }
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location is required to share and discover content"
                                                        message:@"You must allow \"Malum\" to access your location to use this app."
                                                       delegate:self
                                              cancelButtonTitle:@"Go to Settings"
                                              otherButtonTitles:nil];
        [alert show];
    }

}
#pragma mark - API Request - User Login
- (void)requestAPILogin:(NSMutableDictionary *)dic {
    self.isLoadingUserBase = YES;
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestDataLogin:) toTarget:self withObject:dic];
}
- (void)requestDataLogin:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_USER_LOGIN withJSON:(NSMutableDictionary *) params];
    self.isLoadingUserBase = NO;
    [commonUtils hideActivityIndicator];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            appController.currentUser = [result objectForKey:@"current_user"];
            appController.userFriends = [result objectForKey:@"users_friends"];
            [commonUtils setUserDefaultDic:@"current_user" withDic:appController.currentUser];
            
            [self performSelector:@selector(requestOverLogin) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
        } else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"Please complete entire form";
            [commonUtils showVAlertSimple:@"Failed" body:msg duration:1.4];
        }
    } else {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.0];
    }
}
- (IBAction)facebookLogInBtnOnClick:(id)sender {
    if(self.isLoadingUserBase) return;
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile", @"email", @"user_birthday", @"user_photos"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in with token : @%@", result.token);
            [self fetchUserInfo];
           
         }
     }];
}

- (void)fetchUserInfo {
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken] tokenString]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, gender, bio, location, friends, hometown, friendlists"}]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 if (!error) {
                     NSLog(@"facebook fetched info : %@", result);
                     
                     if([commonUtils getUserDefault:@"currentLatitude"] != nil && [commonUtils getUserDefault:@"currentLongitude"] != nil) {
                         
                         NSDictionary *temp = (NSDictionary *)result;
                         NSMutableDictionary *userTemp = [[NSMutableDictionary alloc] initWithDictionary:temp];
                         NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                         [userInfo setObject:[temp objectForKey:@"id"] forKey:@"user_facebook_id"];
                         
                         if([commonUtils checkKeyInDic:@"email" inDic:userTemp]) {
                             [userInfo setObject:[temp objectForKey:@"email"] forKey:@"user_email"];
                         }
                         
                         if([commonUtils checkKeyInDic:@"first_name" inDic:userTemp]) {
//                             [userInfo setObject:[temp objectForKey:@"first_name"] forKey:@"user_first_name"];
                                                      }
                         if([commonUtils checkKeyInDic:@"last_name" inDic:userTemp]) {
//                             [userInfo setObject:[temp objectForKey:@"last_name"] forKey:@"user_last_name"];
                             
                         }
                         NSString *fullName = [[[temp objectForKey:@"first_name"] stringByAppendingString:@" "]stringByAppendingString:[temp objectForKey:@"last_name"]];
                         [userInfo setObject:fullName forKey:@"user_full_name"];
                         
//                         NSString *gender = @"1";
//                         if([commonUtils checkKeyInDic:@"gender" inDic:userTemp]) {
//                             if([[temp objectForKey:@"gender"] isEqualToString:@"female"]) gender = @"2";
//                         }
//                         [userInfo setObject:gender forKey:@"user_gender"];
                         
//                         NSString *age = @"30";
//                         if([commonUtils checkKeyInDic:@"age" inDic:userTemp]) {
//                             age = [NSString stringWithFormat:@"%@", [temp objectForKey:@"age"]];
//                         }
//                         [userInfo setObject:age forKey:@"user_age"];
                         
                         if([commonUtils getUserDefault:@"currentLatitude"] && [commonUtils getUserDefault:@"currentLongitude"]) {
                             [userInfo setObject:[commonUtils getUserDefault:@"currentLatitude"] forKey:@"user_location_latitude"];
                             [userInfo setObject:[commonUtils getUserDefault:@"currentLongitude"] forKey:@"user_location_longitude"];
                         }
                         NSString *fbProfilePhoto = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [temp objectForKey:@"id"]];
                         [userInfo setObject:fbProfilePhoto forKey:@"user_photo_url"];
                         
                         [userInfo setObject:@"2" forKey:@"signup_mode"];
                         
                         if([commonUtils getUserDefault:@"user_apns_id"] != nil) {
                             [userInfo setObject:[commonUtils getUserDefault:@"user_apns_id"] forKey:@"user_apns_id"];
                             
                             self.isLoadingUserBase = YES;
                             [commonUtils showActivityIndicatorColored:self.view];
                             [NSThread detachNewThreadSelector:@selector(requestData:) toTarget:self withObject:userInfo];
                             //[self requestData:userInfo];
                             
                         } else {
                             [appController.vAlert doAlert:@"Notice" body:@"Failed to get your device token.\n\nTherefore, you will not be able to receive notification for the new activities." duration:2.0f done:^(DoAlertView *alertView) {
                                 
                                 self.isLoadingUserBase = YES;
                                 [commonUtils showActivityIndicatorColored:self.view];
                                 [NSThread detachNewThreadSelector:@selector(requestData:) toTarget:self withObject:userInfo];
                                 //[self requestData:userInfo];
                             }];
                         }
                     } else {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location is required to share and discover content"
                                                                         message:@"You must allow \"Woof Social\" to access your location to use this app."
                                                                        delegate:self
                                                               cancelButtonTitle:@"Go to Settings"
                                                               otherButtonTitles:nil];
                         [alert show];
                     }
                     
                     
                 } else {
                     NSLog(@"Error %@",error);
                 }
             }];
            
        });
    }
    
}

#pragma mark - API Request - User Signup After FB Login
- (void) requestData:(id) params {
    
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_USER_SIGNUP withJSON:(NSMutableDictionary *) params];
    
    self.isLoadingUserBase = NO;
    [commonUtils hideActivityIndicator];
    
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            appController.currentUser = [result objectForKey:@"current_user"];
            [commonUtils setUserDefaultDic:@"current_user" withDic:appController.currentUser];
            [self performSelector:@selector(requestOver) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
            
        } else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"Please complete entire form";
            [commonUtils showVAlertSimple:@"Warning" body:msg duration:1.4];
        }
    } else {
        
        //        [[FBSession activeSession] closeAndClearTokenInformation];
        //        [FBSession setActiveSession:nil];
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.0];
    }
}

- (void)requestOverLogin {
    [self navToMainView];
}
- (void)requestOver {
    [self navToMainView];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(self.isLoadingUserBase) return NO;
//    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    //    if (![_repeatpwd.text isEqualToString:_pwd.text]) {
    //        [ commonUtils showVAlertSimple:@"Warning" body:@"No Match Password!" duration:1.2];
    //    }
    return [textField resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
