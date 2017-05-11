//
//  FriendsViewController.m
//  Malum
//
//  Created by Mars on 6/17/16.
//  Copyright © 2016 Mars. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendsTableViewCell.h"
#import "UserProfileViewController.h"

@interface FriendsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *containeView;
@property (strong, nonatomic) NSMutableArray *friendsArray;
@property (weak, nonatomic) IBOutlet UITableView *friendsTableView;


@end

@implementation FriendsViewController
@synthesize friendsArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self initUI];
    [self initData];
}
-(void)initUI{
    _containeView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _containeView.layer.borderWidth = 2.0f;
    _friendsTableView.separatorColor = [UIColor clearColor];
}
-(void)initData{
}
-(void)viewWillAppear:(BOOL)animated{
    if(self.isLoadingBase) return;
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
    
    [self requestAPIUserFriends:paramDic];
    
}
#pragma mark - API Request - User Friends
- (void)requestAPIUserFriends:(NSMutableDictionary *)dic {
    self.isLoadingBase = YES;
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestDataUsersFriends:) toTarget:self withObject:dic];
}
- (void)requestDataUsersFriends:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_USER_FRIENDS withJSON:(NSMutableDictionary *) params];
    self.isLoadingBase = NO;
    [commonUtils hideActivityIndicator];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            friendsArray = [result objectForKey:@"users_friends"];
            [_friendsTableView reloadData];
            
        }
    } else {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.0];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return friendsArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    dic = [friendsArray objectAtIndex:indexPath.row];

    FriendsTableViewCell* cell=(FriendsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"friendscell"];
      NSString *imageUrl;
    if ([[dic objectForKey:@"user_photo_url"] rangeOfString:@"https://graph.facebook.com"].location == NSNotFound) {
        imageUrl = [NSString stringWithFormat:@"%@%@", MEDIA_URL_USERS,[ dic objectForKey:@"user_photo_url"]];
        
    }else{
        NSLog(@"Facebook image url is!!!%@", [dic objectForKey:@"user_photo_url"]);
        imageUrl = [NSString stringWithFormat:@"%@",[ dic objectForKey:@"user_photo_url"]];
    }
    
    [commonUtils setImageViewAFNetworking:cell.userPhotoImageView withImageUrl:imageUrl withPlaceholderImage:[UIImage imageNamed:@"user"]];

//    cell.userPhotoImageView.image = [UIImage imageNamed:[dic objectForKey:@"user_photo_url"]];
    cell.userName.text = [dic objectForKey:@"user_full_name"];
       
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    dic = [friendsArray objectAtIndex:indexPath.row];
    
    FriendsTableViewCell* cell=(FriendsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"friendscell"];
    NSString *imageUrl;
    if ([[dic objectForKey:@"user_photo_url"] rangeOfString:@"https://graph.facebook.com"].location == NSNotFound) {
        imageUrl = [NSString stringWithFormat:@"%@%@", MEDIA_URL_USERS,[ dic objectForKey:@"user_photo_url"]];
        
    }else{
        NSLog(@"Facebook image url is!!!%@", [dic objectForKey:@"user_photo_url"]);
        imageUrl = [NSString stringWithFormat:@"%@",[ dic objectForKey:@"user_photo_url"]];
    }
    [commonUtils setImageViewAFNetworking:cell.userPhotoImageView withImageUrl:imageUrl withPlaceholderImage:[UIImage imageNamed:@"user"]];
    NSLog(@"%@", dic);
    UserProfileViewController *userProfilePage = [self.storyboard instantiateViewControllerWithIdentifier:@"userprofileview"];
//    userProfilePage.userIndex = indexPath.row;
    userProfilePage.userPicture = cell.userPhotoImageView.image;
    userProfilePage.userName = [dic objectForKey:@"user_full_name"];
    userProfilePage.userMalumName = [dic objectForKey:@"user_malum_name"];
    userProfilePage.userMalumAddress = [dic objectForKey:@"user_malum_address"];
    userProfilePage.userOccupation = [dic objectForKey:@"user_occupation"];
    [self.navigationController pushViewController:userProfilePage animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
