//
//  StatisticsViewController.m
//  Malum
//
//  Created by Mars on 6/24/16.
//  Copyright © 2016 Mars. All rights reserved.
//

#import "StatisticsViewController.h"
#import "StaticsTableViewCell.h"


@interface StatisticsViewController ()<UITableViewDelegate, UITableViewDataSource>{

    int  onTimeSwitchVal;
    int  onUserSwitchVal;
    
    NSMutableArray *allUserArray;
    NSMutableArray *friendsArray;
    
    NSMutableArray *tblContentArray;
    
    
}
@property (strong, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIButton *DayBtn, *weekBtn, *monthBtn, *allBtn, *friendsBtn;
@property (strong, nonatomic) IBOutlet UIView *dateView;
@property (strong, nonatomic) IBOutlet UILabel *allLineLabel, *friendsLineLabel;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) NSMutableArray *todayAllArray, *weekAllArray, *monthAllArray, *todayFriendArray, *weekFriendArray, *monthFriendArray;
@property (weak, nonatomic) IBOutlet UITableView *statisticTableView;

//@property (strong, nonatomic) AllTableViewController *allTableVC;
//@property (strong, nonatomic) FriendsTableViewController *friendTableVC;

@end

@implementation StatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
    onTimeSwitchVal = 1;
    onUserSwitchVal = 4;
    
   
    [self initUI];
    [self initData];
    
}
-(void)initData{
    
    allUserArray = [[NSMutableArray alloc] init];
    friendsArray = [[NSMutableArray alloc] init];

    
    _todayAllArray = [[NSMutableArray alloc] init];
    _weekAllArray = [[NSMutableArray alloc] init];
    _monthAllArray = [[NSMutableArray alloc] init];
    _todayFriendArray = [[NSMutableArray alloc] init];
    _weekFriendArray = [[NSMutableArray alloc] init];
    _monthFriendArray = [[NSMutableArray alloc] init];
    
    tblContentArray = [[NSMutableArray alloc] init];
    

}
-(void)viewWillAppear:(BOOL)animated{
    if(self.isLoadingBase) return;
    
    allUserArray = [[NSMutableArray alloc] init];
    friendsArray = [[NSMutableArray alloc] init];
    
    
    _todayAllArray = [[NSMutableArray alloc] init];
    _weekAllArray = [[NSMutableArray alloc] init];
    _monthAllArray = [[NSMutableArray alloc] init];
    _todayFriendArray = [[NSMutableArray alloc] init];
    _weekFriendArray = [[NSMutableArray alloc] init];
    _monthFriendArray = [[NSMutableArray alloc] init];

    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
    
    [self requestAPIAllUsers:paramDic]; // output allUserArray ,friendsArray
    
    [self tableviewReload];
    
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
            

            allUserArray = [result objectForKey: @"users"];
            friendsArray = [result objectForKey:@"users_friends"];
            NSLog(@"All Users are%@", allUserArray);
            NSLog(@"All Friends are%@", friendsArray);

           
        }
    } else {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.0];
    }
}
-(void)viewDidAppear:(BOOL)animated{
}

-(void)initUI{
    _lineView1.frame = CGRectMake(_DayBtn.frame.origin.x,
                                  _DayBtn.frame.size.height,
                                  _DayBtn.frame.size.width,
                                  _dateView.frame.size.height - _DayBtn.frame.size.height);
    _allLineLabel.backgroundColor = RGBA(91, 168, 221, 1);
    _friendsLineLabel.backgroundColor = [UIColor lightGrayColor];
    _allBtn.titleLabel.textColor = RGBA(91, 168, 221, 1);
    _friendsBtn.titleLabel.textColor = [UIColor lightGrayColor];
    
    
}
-(void)tableviewReload{
    
    
    if(onTimeSwitchVal == 1 &&  onUserSwitchVal == 4){
        _todayAllArray = [[NSMutableArray alloc] init];
        for (int i=0; i< allUserArray.count; i++) {
                            if ([[[allUserArray objectAtIndex:i] objectForKey:@"isToday"] intValue] == 1) {
                                [_todayAllArray addObject:[allUserArray objectAtIndex:i]];
            
                            }
        }
       
        tblContentArray = _todayAllArray;
        
        [self.statisticTableView reloadData];
    }else if (onTimeSwitchVal == 2 && onUserSwitchVal == 4){
        _weekAllArray = [[NSMutableArray alloc] init];
        for (int i=0; i< allUserArray.count; i++) {
            if ([[[allUserArray objectAtIndex:i] objectForKey:@"isWeek"] intValue] == 1) {
                [_weekAllArray addObject:[allUserArray objectAtIndex:i]];
                    
            }
        }
        
        tblContentArray = _weekAllArray;
        
        [self.statisticTableView reloadData];
    }else if (onTimeSwitchVal == 3 && onUserSwitchVal == 4)
    {
        _monthAllArray = [[NSMutableArray alloc] init];
        for (int i=0; i< allUserArray.count; i++) {
            if ([[[allUserArray objectAtIndex:i] objectForKey:@"isMonth"] intValue] == 1) {
                [_monthAllArray addObject:[allUserArray objectAtIndex:i]];
                
            }
        }
        
        tblContentArray = _monthAllArray;

        [self.statisticTableView reloadData];
        
    }else if(onTimeSwitchVal == 1 &&  onUserSwitchVal == 5){
        _todayFriendArray = [[NSMutableArray alloc] init];
        for (int i=0; i< friendsArray.count; i++) {
            if ([[[friendsArray objectAtIndex:i] objectForKey:@"isToday"] intValue] == 1) {
                [_todayFriendArray addObject:[friendsArray objectAtIndex:i]];
                
            }
        }
        
        tblContentArray = _todayFriendArray;
        
        [self.statisticTableView reloadData];
        
        [self.statisticTableView reloadData];
    }else if (onTimeSwitchVal == 2 && onUserSwitchVal == 5){
        _weekFriendArray = [[NSMutableArray alloc] init];
        for (int i=0; i< friendsArray.count; i++) {
            if ([[[friendsArray objectAtIndex:i] objectForKey:@"isWeek"] intValue] == 1) {
                [_weekFriendArray addObject:[friendsArray objectAtIndex:i]];
                
            }
        }
        
        tblContentArray = _weekFriendArray;
        
        [self.statisticTableView reloadData];
        
        [self.statisticTableView reloadData];
    }else if (onTimeSwitchVal == 3 && onUserSwitchVal == 5){
        _monthFriendArray = [[NSMutableArray alloc] init];
        for (int i=0; i< friendsArray.count; i++) {
            if ([[[friendsArray objectAtIndex:i] objectForKey:@"isMonth"] intValue] == 1) {
                [_monthFriendArray addObject:[friendsArray objectAtIndex:i]];
                
            }
        }
        
        tblContentArray = _monthFriendArray;
        
        [self.statisticTableView reloadData];
        
        [self.statisticTableView reloadData];
    }
}

#pragma mark Tableview Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tblContentArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *userDic = [[NSMutableDictionary alloc] init];
    userDic = [tblContentArray objectAtIndex:indexPath.row];
    
      StaticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StaticsTableViewCell" forIndexPath:indexPath];
    NSString *imageUrl;
    
    if ([[userDic objectForKey:@"user_photo_url"] rangeOfString:@"https://graph.facebook.com"].location == NSNotFound) {
        imageUrl = [NSString stringWithFormat:@"%@%@", MEDIA_URL_USERS,[ userDic objectForKey:@"user_photo_url"]];
        
    }else{
        NSLog(@"Facebook image url is!!!%@", [userDic objectForKey:@"user_photo_url"]);
        imageUrl = [NSString stringWithFormat:@"%@",[ userDic objectForKey:@"user_photo_url"]];
    }
    
    [commonUtils setImageViewAFNetworking:cell.photoImageView withImageUrl:imageUrl withPlaceholderImage:[UIImage imageNamed:@"user"]];
    
    //cell.photoImageView.image = [UIImage imageNamed:[userDic objectForKey:@"user_photo_url"]];
    cell.userNameLabel.text = [userDic objectForKey:@"user_full_name"];
    cell.userRankLable.text = [userDic objectForKey:@"user_malum_rank"];
    return cell;
}
-(IBAction)userButtonClick:(UIButton*)sender{
    
   
    if ([sender tag] == 304){
        
        _allLineLabel.backgroundColor = RGBA(91, 168, 221, 1);
        _friendsLineLabel.backgroundColor = [UIColor lightGrayColor];
        _allBtn.titleLabel.textColor = RGBA(91, 168, 221, 1);
        _friendsBtn.titleLabel.textColor = [UIColor lightGrayColor];
       
        onUserSwitchVal = 4;
    }else if ([sender tag] == 305){
        _friendsLineLabel.backgroundColor = RGBA(91, 168, 221, 1);
        _allLineLabel.backgroundColor = [UIColor lightGrayColor];
        _friendsBtn.titleLabel.textColor = RGBA(91, 168, 221, 1);
        _allBtn.titleLabel.textColor = [UIColor lightGrayColor];
        
        onUserSwitchVal = 5;
    }

    
    [self tableviewReload];
    
}
-(IBAction)timeButtonClick:(UIButton*)sender{

    if ([sender tag] == 301) {
        [UIView animateWithDuration:0.3f animations:^{
            _lineView1.frame =  CGRectMake(_DayBtn.frame.origin.x, _DayBtn.frame.size.height, _lineView1.frame.size.width, _lineView1.frame.size.height);
        }];
        
        onTimeSwitchVal = 1;
        
        
    }else if ([sender tag] == 302){
        [UIView animateWithDuration:0.3f animations:^{
            _lineView1.frame =  CGRectMake(_weekBtn.frame.origin.x, _weekBtn.frame.size.height, _lineView1.frame.size.width, _lineView1.frame.size.height);
        }];
        onTimeSwitchVal = 2;
    }else if ([sender tag] == 303){
        [UIView animateWithDuration:0.3f animations:^{
            _lineView1.frame =  CGRectMake(_monthBtn.frame.origin.x, _monthBtn.frame.size.height, _lineView1.frame.size.width, _lineView1.frame.size.height);
        }];
        onTimeSwitchVal = 3;
    }
     [self tableviewReload];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
