//
//  EditProfileViewController.m
//  Malum
//
//  Created by Mars on 6/23/16.
//  Copyright © 2016 Mars. All rights reserved.
//

#import "EditProfileViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "VSDropdown.h"
#import "LoginViewController.h"

@interface EditProfileViewController ()<VSDropdownDelegate, UITextFieldDelegate, UIScrollViewDelegate>{
    NSMutableArray *optionArray;
    VSDropdown *_dropdown;
    UITextField *currentTextField;
}
@property (weak, nonatomic) IBOutlet UIView *profileView;
@property (weak, nonatomic) IBOutlet UIButton *profileSaveBtn, *logoutBtn;
@property (weak, nonatomic) IBOutlet UIImageView *userPhotoImageView;

@property (weak, nonatomic) IBOutlet UITextField *fullnameTextField, *occupationTextField, *malumNameTextField, *malumAddressTextField;
@property (weak, nonatomic) IBOutlet UIButton *optionBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation EditProfileViewController
BOOL isChangePhotos;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
}
-(void)initUI{
    _profileView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _profileView.layer.borderWidth = 2.0f;
    _profileView.layer.cornerRadius = 10.0f;
    [commonUtils setRoundedRectBorderView:_profileSaveBtn withBorderWidth:0.0f withBorderColor:[UIColor clearColor] withBorderRadius:10.0f];
    [commonUtils setRoundedRectBorderView:_logoutBtn withBorderWidth:0.0f withBorderColor:[UIColor clearColor] withBorderRadius:10.0f];
    [commonUtils setRoundedRectView:_userPhotoImageView withCornerRadius:_userPhotoImageView.frame.size.height/2.0f];
    
    _dropdown = [[VSDropdown alloc]initWithDelegate:self];
    
    [_dropdown setAdoptParentTheme:YES];
    [_dropdown setShouldSortItems:YES];
     NSLog(@"%@", [appController.currentUser objectForKey:@"user_photo_url"]);
    NSLog(@"%@", [appController.currentUser objectForKey:@"user_full_name"]);
    
    if (![[appController.currentUser objectForKey:@"user_photo_url"] isEqualToString:@""]) {
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@", MEDIA_URL_USERS,[ appController.currentUser objectForKey:@"user_photo_url"]];
        
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
        [req addValue:@"image/*" forHTTPHeaderField:@"Accept"];
        [_userPhotoImageView setImageWithURLRequest:req placeholderImage:[UIImage imageNamed:@"useravator"] success:nil failure:nil];
    }else{
        _userPhotoImageView.image = [UIImage imageNamed:@"useravator"];
    }
    if (([[appController.currentUser objectForKey:@"user_full_name"] isEqualToString:@""] || [[appController.currentUser objectForKey:@"user_full_name"] isEqualToString:@"0"])) {
        _fullnameTextField.text = @"";
    }else{

        _fullnameTextField.text = [NSString stringWithFormat:@"%@", [appController.currentUser objectForKey:@"user_full_name"]];
       
    }
    if (([[appController.currentUser objectForKey:@"user_occupation"] isEqualToString:@""] || [[appController.currentUser objectForKey:@"user_occupation"] isEqualToString:@"0"])) {
        _fullnameTextField.text = @"";
    }else{
        
        _occupationTextField.text = [appController.currentUser objectForKey:@"user_occupation"];
    }
    if (([[appController.currentUser objectForKey:@"user_malum_name"] isEqualToString:@""] || [[appController.currentUser objectForKey:@"user_malum_name"] isEqualToString:@"0"])) {
        _malumNameTextField.text = @"";
    }else{
        
        _malumNameTextField.text = [appController.currentUser objectForKey:@"user_malum_name"];
    }
    if (([[appController.currentUser objectForKey:@"user_malum_address"] isEqualToString:@""] || [[appController.currentUser objectForKey:@"user_malum_address"] isEqualToString:@"0"])) {
        _malumAddressTextField.text = @"";
    }else{
        
        _malumAddressTextField.text = [appController.currentUser objectForKey:@"user_malum_address"];
    }
    
    
    if ([[appController.currentUser objectForKey:@"user_malum_option"] isEqualToString:@""]) {
         _optionBtn.titleLabel.text = @"";//[appController.currentUser objectForKey:@"Option"];
        
    }else{
        
        _optionBtn.titleLabel.text = [appController.currentUser objectForKey:@"user_malum_option"];
         NSLog(@"%@", _optionBtn.titleLabel.text);
    }
   


}
-(void)initData{

    optionArray = [[NSMutableArray alloc]initWithArray:@[@"School",@"Work"] ];
     //appController.userAvator = [[UIImage alloc] init];
   
}
- (IBAction)takePhotoBtnOnClick:(id)sender {
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Take a Photo", @"From the Library" ,nil];
    
    [actionSheet showInView:self.view];
}
// Actionsheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self onAddImageFromCamera];
    }else if (buttonIndex == 1)
    {
        [self onAddImageFromLibrary];
    }
}
- (void)onAddImageFromCamera
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.videoQuality = UIImagePickerControllerQualityTypeMedium;
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerController.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
    pickerController.allowsEditing = NO;
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];
}


- (void)onAddImageFromLibrary
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
    pickerController.allowsEditing = NO;
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];
    
}
// Image Picker Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        
        UIImage *resultImage = [info objectForKey:UIImagePickerControllerEditedImage];
        if (!resultImage) {
            resultImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        [_userPhotoImageView setImage:resultImage];
//        [appController.currentUser setObject:resultImage forKey:@"user_avator"];
        appController.userAvator = resultImage;
        [commonUtils setRoundedRectView:_userPhotoImageView withCornerRadius:_userPhotoImageView.frame.size.height/2.0f];
        
        
        //        UIImageView * tempView = (UIImageView *) [UIImage objectAtIndex:activeProfileImageIndex];
        //        [tempView setImage:resultImage];
        //
        isChangePhotos = YES;
        NSString *photourl = [commonUtils encodeToBase64String:resultImage byCompressionRatio:0.3];
        [appController.currentUser setObject:photourl forKey:@"user_photo"];
        
    }
    NSLog(@"%@", appController.currentUser);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)optionBtnOnClick:(id)sender {
    [self showDropDownForButton:sender adContents:[self getOptionArray:optionArray] multipleSelection:NO];
}
- (NSMutableArray *)getOptionArray:(NSMutableArray *)arr {
    NSMutableArray *names = [[NSMutableArray alloc] init];
    names = optionArray;
//    for(NSMutableDictionary *dic in arr) {
//        [names addObject:[@"" stringByAppendingString:[dic objectForKey:@"optionArray"]]];
//    }
    return names;
}
- (void)showDropDownForButton:(UIButton *)sender adContents:(NSArray *)contents multipleSelection:(BOOL)multipleSelection {
    
    [_dropdown setDrodownAnimation:rand() % 2];
    
//    [_dropdown setAllowMultipleSelection:multipleSelection];
    
    [_dropdown setupDropdownForView:sender];
    
    [_dropdown setShouldSortItems:NO];
    //    [_dropdown setSeparatorColor:sender.titleLabel.textColor];
    [_dropdown setSeparatorColor:[UIColor clearColor]];
    
    if (_dropdown.allowMultipleSelection) {
        [_dropdown reloadDropdownWithContents:contents andSelectedItems:[sender.titleLabel.text componentsSeparatedByString:@";"]];
    } else {
        [_dropdown reloadDropdownWithContents:contents andSelectedItems:@[sender.titleLabel.text]];
        //        [_dropdown reloadDropdownWithContents:contents keyPath:@"name" selectedItems:@[sender.titleLabel.text]];
    }
    [ _dropdown setTextColor:[UIColor blackColor]];
    
    
}

#pragma mark - VSDropdown Delegate methods.
- (void)dropdown:(VSDropdown *)dropDown didChangeSelectionForValue:(NSString *)str atIndex:(NSUInteger)index selected:(BOOL)selected {
    UIButton *btn = (UIButton *)dropDown.dropDownView;
    NSString *allSelectedItems = [dropDown.selectedItems componentsJoinedByString:@";"];
//    _optionLabel.text = allSelectedItems;
    [btn setTitle:allSelectedItems forState:UIControlStateNormal];
}

- (IBAction)LogOutBtnOnClick:(id)sender {
    if(self.isLoadingBase) return;
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
    [paramDic setObject:@"1" forKey:@"device_type"];
    [self requestAPIUserLogout:paramDic];
    
}

#pragma mark - API REQUEST - User Logout
- (void)requestAPIUserLogout:(NSMutableDictionary *)dic {
    self.isLoadingBase = YES;
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestDataUserLogout:) toTarget:self withObject:dic];
}

- (void) requestDataUserLogout:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_USER_LOGOUT withJSON:(NSMutableDictionary *) params];
    
    self.isLoadingBase = NO;
    [commonUtils hideActivityIndicator];
    
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary*)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            //[self requestOverUserLogout];
            [self performSelector:@selector(requestOverUserLogout) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
        } else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"Please fill form correctly.";
            [commonUtils showVAlertSimple:@"Warning" body:msg duration:1.4];
        }
    } else {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.0];
    }
    
}
- (void)requestOverUserLogout {
    [commonUtils removeUserDefaultDic:@"current_user"];
//    [commonUtils removeUserDefault:@"flag_location_query_enabled"];
    appController.currentUser = [[NSMutableDictionary alloc] init];
    [commonUtils setUserDefault:@"logged_out" withFormat:@"1"];
    LoginViewController *LoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginView"];
    [self.navigationController pushViewController:LoginViewController animated:YES];
}
- (IBAction)profileUpdateBtnOnClick:(id)sender {
    if(self.isLoadingBase) return;
    
    
    
            NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
            [appController.currentUser setObject:self.fullnameTextField.text forKey:@"user_full_name"];
            [appController.currentUser setObject:self.occupationTextField.text forKey:@"user_occupation"];
            [appController.currentUser setObject:self.malumNameTextField.text forKey:@"user_malum_name"];
            [appController.currentUser setObject:self.malumAddressTextField.text forKey:@"user_malum_address"];
            [appController.currentUser setObject:self.optionBtn.titleLabel.text forKey:@"user_malum_option"];
    
//            [appController.currentUser setObject:[appController.currentUser objectForKey:@"user_photo"] forKey:@"user_photo"];
            paramDic = appController.currentUser;
    
    
            [self requestAPIProfileUpdate:paramDic];
    
}

#pragma mark - API Request - User Login
- (void)requestAPIProfileUpdate:(NSMutableDictionary *)dic {
    self.isLoadingBase = YES;
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestDataProfile:) toTarget:self withObject:dic];
}
- (void)requestDataProfile:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_PROFILE_UPDATE withJSON:(NSMutableDictionary *) params];
    self.isLoadingBase = NO;
    [commonUtils hideActivityIndicator];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
           [commonUtils showVAlertSimple:@"Success" body:@"Your profile updated successfully!" duration:1.0];
            appController.currentUser = [result objectForKey:@"current_user"];
            NSLog(@"Current User is %@", appController.currentUser);
        }
    } else {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.0];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(self.isLoadingBase) return NO;
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    return [textField resignFirstResponder];
}
#pragma mark - TextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(self.isLoadingBase) return NO;
    currentTextField = textField;
    [textField setText:@""];
    float offset = 0;
    if(currentTextField == self.fullnameTextField) {
        offset = 0;
    } else if(currentTextField == self.occupationTextField) {
        offset = 40;
    }
    else if(currentTextField == self.malumNameTextField) {
        offset = 80;
    }
    else if(currentTextField == self.malumAddressTextField) {
        offset = 120;
    }
    
    [self.scrollView setContentOffset:CGPointMake(0, offset) animated:YES];
    
    return YES;
    
}

#pragma mark - ScrollView Tap
- (void) onTappedScreen {
    [currentTextField resignFirstResponder];
    [self.containerScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
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
