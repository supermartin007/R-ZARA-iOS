//
//  PostRewardViewController.m
//  Malum
//
//  Created by Mars on 7/15/16.
//  Copyright © 2016 Mars. All rights reserved.
//

#import "PostRewardViewController.h"
#import "VSDropdown.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface PostRewardViewController ()<UIScrollViewDelegate, UITextFieldDelegate, VSDropdownDelegate>{
    NSMutableArray *categoryArray;
    VSDropdown *_dropdown;
    UITextField *currentTextField;
}
@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *rewardIconImageView;
@property (weak, nonatomic) IBOutlet UITextField *rewardNameTextField, *rewardPlaceTextField, *rewardLocationTextField, *rewardPointTextField;
@property (weak, nonatomic) IBOutlet UIButton *categoryBtn;
@property (weak, nonatomic) IBOutlet UITextView *rewardDescriptionTextView;
@property (nonatomic, strong) NSString *iconurl;
@property (weak, nonatomic) IBOutlet UIButton *postBtn;


@end

@implementation PostRewardViewController
@synthesize iconurl;
BOOL isChangeIcon;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self initUI];
    [self initData];
    // Do any additional setup after loading the view.
}
-(void)initUI{
    _pictureView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _pictureView.layer.borderWidth = 2.0f;
    _pictureView.layer.cornerRadius = 10.0f;
    [_scrollView setContentSize:_pictureView.frame.size];
    _dropdown = [[VSDropdown alloc]initWithDelegate:self];
    [_dropdown setAdoptParentTheme:YES];
    [_dropdown setShouldSortItems:YES];
    [commonUtils setRoundedRectBorderView:_postBtn withBorderWidth:1.0f withBorderColor:[UIColor whiteColor] withBorderRadius:_postBtn.layer.frame.size.height/2.0f];

}
-(void)initData{
    
    categoryArray = [[NSMutableArray alloc]initWithArray:@[@"Entertainment",@"Online", @"Food", @"Apparel"] ];
    iconurl = [[NSString alloc] init];
    
    
}
- (IBAction)addPhotoButton:(id)sender {
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
        [_rewardIconImageView setImage:resultImage];
        //        [appController.currentUser setObject:resultImage forKey:@"user_avator"];
//        appController.userAvator = resultImage;
        [commonUtils setRoundedRectView:_rewardIconImageView withCornerRadius:_rewardIconImageView.frame.size.height/2.0f];
        
        
        //        UIImageView * tempView = (UIImageView *) [UIImage objectAtIndex:activeProfileImageIndex];
        //        [tempView setImage:resultImage];
        //
        isChangeIcon = YES;
        NSString *photourl = [commonUtils encodeToBase64String:resultImage byCompressionRatio:0.3];
        iconurl = photourl;
    }
//    NSLog(@"%@", appController.currentUser);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)categoryBtnOnClick:(id)sender {
    [self showDropDownForButton:sender adContents:[self getOptionArray:categoryArray] multipleSelection:NO];
}


- (NSMutableArray *)getOptionArray:(NSMutableArray *)arr {
    NSMutableArray *names = [[NSMutableArray alloc] init];
    names = categoryArray;
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
    [ _dropdown setTextColor:[UIColor lightGrayColor]];
    
    
}

#pragma mark - VSDropdown Delegate methods.
- (void)dropdown:(VSDropdown *)dropDown didChangeSelectionForValue:(NSString *)str atIndex:(NSUInteger)index selected:(BOOL)selected {
    UIButton *btn = (UIButton *)dropDown.dropDownView;
    NSString *allSelectedItems = [dropDown.selectedItems componentsJoinedByString:@";"];
    //    _optionLabel.text = allSelectedItems;
    [btn setTitle:allSelectedItems forState:UIControlStateNormal];
}
- (IBAction)postBtnOnClick:(id)sender {
    if(self.isLoadingBase) return;
    NSLog(@"ICON URL IS !!!%@", iconurl);
    if([commonUtils isFormEmpty:[@[self.rewardNameTextField.text, self.rewardPlaceTextField.text, self.rewardLocationTextField.text, self.rewardPointTextField.text, self.rewardDescriptionTextView.text] mutableCopy]]) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Please complete the entire form" duration:1.2];
        
    } else if([self.categoryBtn.titleLabel.text isEqualToString: @"Category"]) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Please select category." duration:1.2];
    } else if([iconurl isEqualToString:@""]) {
        [commonUtils showVAlertSimple:@"Warning" body:@"Please upload icon image." duration:1.2];

    } else {
    
    
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:self.rewardNameTextField.text forKey:@"reward_name"];
    [paramDic setObject:self.rewardPlaceTextField.text forKey:@"reward_place"];
    [paramDic setObject:self.categoryBtn.titleLabel.text forKey:@"reward_category"];
    [paramDic setObject:self.rewardLocationTextField.text forKey:@"reward_location"];
    [paramDic setObject:self.rewardPointTextField.text forKey:@"reward_point"];
    [paramDic setObject:self.rewardDescriptionTextView.text forKey:@"reward_description"];
    [paramDic setObject:iconurl forKey:@"reward_icon_url"];
    
    
    
    [self requestAPIPostReward:paramDic];
    
}
}

#pragma mark - API Request - User Login
- (void)requestAPIPostReward:(NSMutableDictionary *)dic {
        self.isLoadingBase = YES;
        [commonUtils showActivityIndicatorColored:self.view];
        [NSThread detachNewThreadSelector:@selector(requestDataReward:) toTarget:self withObject:dic];
}

- (void)requestDataReward:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_POST_REWARD withJSON:(NSMutableDictionary *) params];
    self.isLoadingBase = NO;
    [commonUtils hideActivityIndicator];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            [commonUtils showVAlertSimple:@"Success" body:@"You posted reward successfully!" duration:1.0];
        }
    } else {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.0];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(self.isLoadingBase) return NO;
    //    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    //    if (![_repeatpwd.text isEqualToString:_pwd.text]) {
    //        [ commonUtils showVAlertSimple:@"Warning" body:@"No Match Password!" duration:1.2];
    //    }
    return [textField resignFirstResponder];
}
#pragma mark - TextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(self.isLoadingBase) return NO;
    currentTextField = textField;
    [textField setText:@""];
//    float offset = 0;
//    if(currentTextField == self.rewardNameTextField) {
//        offset = 0;
//    } else if(currentTextField == self.occupationTextField) {
//        offset = 40;
//    }
//    else if(currentTextField == self.malumNameTextField) {
//        offset = 80;
//    }
//    else if(currentTextField == self.malumAddressTextField) {
//        offset = 120;
//    }
//    
//    [self.scrollView setContentOffset:CGPointMake(0, offset) animated:YES];
    
    return YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
