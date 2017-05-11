//
//  PointsCollectViewController.m
//  Malum
//
//  Created by Mars on 6/17/16.
//  Copyright © 2016 Mars. All rights reserved.
//

#import "PointsCollectViewController.h"
#import "AppDelegate.h"

@interface PointsCollectViewController ()
@property (strong, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *userPointsLabel;

@end

@implementation PointsCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.pointViewController = self;
    _userPointsLabel.text = appController.points;
    
//    _pointsLabel.text = @"ok";
    
    
    // Do any additional setup after loading the view.
}

-(void)addPoint : (NSInteger)points {
   
    [_pointsLabel setText:[NSString stringWithFormat:@"%d", ((int) (points / 600))]];
    NSLog(@"%@", _pointsLabel.text);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.pointViewController = nil;
}
- (IBAction)saveRankBtnOnClick:(id)sender {
    if(self.isLoadingBase) return;
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
    [paramDic setObject:_pointsLabel.text forKey:@"user_rank"];
    
    [self requestAPIRankUpdate:paramDic];
}
#pragma mark - API Request - User Rank Update
- (void)requestAPIRankUpdate:(NSMutableDictionary *)dic {
    self.isLoadingBase = YES;
    [commonUtils showActivityIndicatorColored:self.view];
    [NSThread detachNewThreadSelector:@selector(requestDataRank:) toTarget:self withObject:dic];
}
- (void)requestDataRank:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_UPLOAD_RANK withJSON:(NSMutableDictionary *) params];
    self.isLoadingBase = NO;
    [commonUtils hideActivityIndicator];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            appController.points = [result objectForKey:@"user_rank"];
            NSLog(@"%@", appController.points);
            _userPointsLabel.text = appController.points;
        }
    } else {
        [commonUtils showVAlertSimple:@"Connection Error" body:@"Please check your internet connection status" duration:1.0];
    }
}



@end
