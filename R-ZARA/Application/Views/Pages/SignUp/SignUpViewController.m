//
//  SignUpViewController.m
//  Malum
//
//  Created by Mars on 6/17/16.
//  Copyright © 2016 Mars. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()<UITextFieldDelegate>{
     UITextField *currentTextField;
}
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UITextField *UserFullNameTextField, *UserEmailTextField, *UserPassWordTextField, *ConfirmPassTextField;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}
-(void)initUI{
    [commonUtils setRoundedRectBorderView:_registerBtn withBorderWidth:0.0f withBorderColor:[UIColor clearColor] withBorderRadius:10.0f];
}
- (IBAction)backBtnOnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)SignUpBtnOnClick:(id)sender {
    if(self.isLoadingUserBase) return;
     if([commonUtils getUserDefault:@"currentLatitude"] != nil && [commonUtils getUserDefault:@"currentLongitude"] != nil) {
    if([commonUtils isFormEmpty:[@[self.UserFullNameTextField.text, self.UserEmailTextField.text, self.UserPassWordTextField.text, self.ConfirmPassTextField.text] mutableCopy]]) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Please complete the entire form" duration:1.2];
        
    } else if(![commonUtils validateEmail:self.UserEmailTextField.text]) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Email address is not in a vaild format." duration:1.2];
    } else if([self.UserPassWordTextField.text length] < 6 || [self.UserPassWordTextField.text length] > 10) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Password length should be 6 to 10." duration:1.2];
    } else if(![self.UserPassWordTextField.text isEqualToString:self.ConfirmPassTextField.text]) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Password confirm does not match." duration:1.2];
    } else {
        
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        
        [paramDic setObject:self.UserFullNameTextField.text forKey:@"user_full_name"];
        [paramDic setObject:self.UserEmailTextField.text forKey:@"user_email"];
        [paramDic setObject:self.UserPassWordTextField.text forKey:@"user_password"];
        [paramDic setObject:@"1" forKey:@"signup_mode"];
        [paramDic setObject:[commonUtils getUserDefault:@"currentLatitude"] forKey:@"user_location_latitude"];
        [paramDic setObject:[commonUtils getUserDefault:@"currentLongitude"] forKey:@"user_location_longitude"];
//        [paramDic setObject:@"30.14216252" forKey:@"user_location_latitude"];
//        [paramDic setObject:@"-95.44682356"  forKey:@"user_location_longitude"];
        [self requestAPISignUP:paramDic];
        
//        if([commonUtils getUserDefault:@"user_apns_id"] != nil) {
//            [paramDic setObject:[commonUtils getUserDefault:@"user_apns_id"] forKey:@"user_apns_id"];
//            [self requestAPISignUP:paramDic];
//        } else {
//            [appController.vAlert doAlert:@"Notice" body:@"Failed to get your device token.\nTherefore, you will not be able to receive notification for the new activities." duration:2.0f done:^(DoAlertView *alertView) {
//                [self requestAPISignUP:paramDic];
//                }];
//        }
        }
     }else {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location is required to share and discover content"
                                                         message:@"You must allow \"Malum\" to access your location to use this app."
                                                        delegate:self
                                               cancelButtonTitle:@"Go to Settings"
                                               otherButtonTitles:nil];
         [alert show];
     }


}




#pragma mark - API Request - User Login
- (void)requestAPISignUP:(NSMutableDictionary *)dic {
    self.isLoadingUserBase = YES;
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestDataSignUp:) toTarget:self withObject:dic];
}
- (void)requestDataSignUp:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_USER_SIGNUP withJSON:(NSMutableDictionary *) params];
    self.isLoadingUserBase = NO;
    [commonUtils hideActivityIndicator];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            appController.currentUser = [result objectForKey:@"current_user"];
            [commonUtils setUserDefaultDic:@"current_user" withDic:appController.currentUser];
            
            [self performSelector:@selector(requestOverSignUp) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
        } else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"Please complete entire form";
            [commonUtils showVAlertSimple:@"Failed" body:msg duration:1.4];
        }
    } else {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.0];
    }
}
- (void)requestOverSignUp {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
