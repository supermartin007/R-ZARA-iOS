//
//  SocializeViewController.m
//  Malum
//
//  Created by Mars on 6/18/16.
//  Copyright © 2016 Mars. All rights reserved.
//

#import "SocializeViewController.h"
#import "GroupTableViewCell.h"

@interface SocializeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startGroupBtn;
@property (weak, nonatomic) IBOutlet UITableView *groupTable;
@property (weak, nonatomic) IBOutlet UIView *containeView;

@end

@implementation SocializeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self initUI];
}
-(void)initUI{
    _containeView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _containeView.layer.borderWidth = 2.0f;
    [commonUtils setRoundedRectBorderButton:_startGroupBtn withBorderWidth:0.0f withBorderColor:[UIColor clearColor] withBorderRadius:10.0f];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 15;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GroupTableViewCell* cell=(GroupTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"groupcell"];
    
    return cell;
    
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
