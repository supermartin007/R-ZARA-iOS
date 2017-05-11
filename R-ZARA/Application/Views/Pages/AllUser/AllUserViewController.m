
//
//  AllUserViewController.m
//  Malum
//
//  Created by Mars on 6/23/16.
//  Copyright © 2016 Mars. All rights reserved.
//

#import "AllUserViewController.h"
#import "AllUserTableViewCell.h"

@interface AllUserViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *containeView;
@property (weak, nonatomic) IBOutlet UITableView *allUsersTable;
@property (nonatomic, strong) NSMutableArray *allusersArray;


@end

@implementation AllUserViewController
@synthesize allusersArray;

- (void)viewDidLoad {
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self initUI];
    [self initData];
}
-(void)initUI{
    _containeView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _containeView.layer.borderWidth = 2.0f;
    _allUsersTable.separatorColor = [UIColor clearColor];
       
}
-(void)initData{
    allusersArray = [[NSMutableArray alloc] init];
}
-(void)viewWillAppear:(BOOL)animated{
    if(self.isLoadingBase) return;
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
    
    [self requestAPIAllUsers:paramDic];
    
}
#pragma mark - API Request - All Users
- (void)requestAPIAllUsers:(NSMutableDictionary *)dic {
    self.isLoadingBase = YES;
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestDataAllUsers:) toTarget:self withObject:dic];
}
- (void)requestDataAllUsers:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_ALL_USERS withJSON:(NSMutableDictionary *) params];
    self.isLoadingBase = NO;
    [commonUtils hideActivityIndicator];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            allusersArray = [result objectForKey:@"users"];
            //appController.allUsers = [result objectForKey:@"users"];
            [_allUsersTable reloadData];
            
        }
    } else {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.0];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allusersArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *allUserDic = [[NSMutableDictionary alloc] init];
    allUserDic = [allusersArray objectAtIndex:indexPath.row];
    
    AllUserTableViewCell* cell=(AllUserTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"allusercell"];
    
//     [commonUtils setWFUserPhoto:cell.userPhotoImageView.image byPhotoUrl:[appController.currentUser objectForKey:@"user_photo_url"]];
    
     NSString *imageUrl;
    
    if ([[allUserDic objectForKey:@"user_photo_url"] rangeOfString:@"https://graph.facebook.com"].location == NSNotFound) {
        imageUrl = [NSString stringWithFormat:@"%@%@", MEDIA_URL_USERS,[ allUserDic objectForKey:@"user_photo_url"]];
        
    }else{
        NSLog(@"Facebook image url is!!!%@", [allUserDic objectForKey:@"user_photo_url"]);
        imageUrl = [NSString stringWithFormat:@"%@",[ allUserDic objectForKey:@"user_photo_url"]];
    }
    
    [commonUtils setImageViewAFNetworking:cell.userPhotoImageView withImageUrl:imageUrl withPlaceholderImage:[UIImage imageNamed:@"user"]];
    
     NSLog(@"Image URL is!!!%@", imageUrl);

       cell.userNameLabel.text = [allUserDic objectForKey:@"user_full_name"];
    UIButton *button = cell.addFriendBtn;
    [button setTag:[[allUserDic objectForKey:@"user_id"] intValue]];
    [button addTarget:self action:@selector(addFriends:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}
-(void)addFriends:(UIButton *)sender{
    if(self.isLoadingBase) return;
    int index = (int)sender.tag;
    NSLog(@"Clicked Button%d", index);
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
    [paramDic setObject:[NSString stringWithFormat:@"%i", index] forKey:@"ref_user_id"];
    [paramDic setObject:@"1" forKey:@"like"];
    [self requestAPIAddFriends:paramDic];
    
}
#pragma mark - API Request - User Login
- (void)requestAPIAddFriends:(NSMutableDictionary *)dic {
    self.isLoadingBase = YES;
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestDataAddFriends:) toTarget:self withObject:dic];
}
- (void)requestDataAddFriends:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_LIKE_USER withJSON:(NSMutableDictionary *) params];
    self.isLoadingBase = NO;
    [commonUtils hideActivityIndicator];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
           [commonUtils showVAlertSimple:@"Warning" body:@"You added John Smith as your friend!" duration:1.2];
            
        }
    } else {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.0];
    }
}

#pragma mark - API Request - User Login
- (void)requestAPILogin:(NSMutableDictionary *)dic {
    self.isLoadingBase = YES;
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestDataLogin:) toTarget:self withObject:dic];
}
- (void)requestDataLogin:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_USER_LOGIN withJSON:(NSMutableDictionary *) params];
    self.isLoadingBase = NO;
    [commonUtils hideActivityIndicator];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            appController.currentUser = [result objectForKey:@"current_user"];
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
