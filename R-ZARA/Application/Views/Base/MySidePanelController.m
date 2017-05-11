//
//  MySidePanelController.m
//  Silver
//
//  Created by Silver on 7/25/14.
//  Copyright (c) 2014 Silver. All rights reserved.
//

#import "MySidePanelController.h"
#import "HomeViewController.h"

@interface MySidePanelController ()


@end

@implementation MySidePanelController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    self.leftGapPercentage = 240.0f / 320.0f;
    [super viewDidLoad];
}


-(void)viewWillAppear:(BOOL)animated
{
    int i = 0;
    i++;
}

-(NSUInteger)supportedInterfaceOrientations{
    
    UIDevice *device = [UIDevice currentDevice];
    
    if(device.userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        self.bounceOnCenterPanelChange = NO;
        if (UIInterfaceOrientationIsLandscape((UIInterfaceOrientation)device.orientation))
        {
            //NSLog(@"Change to custom UI for landscape");
            self.rightGapPercentage = 0.30f;
            
        }
        else if (UIInterfaceOrientationIsPortrait((UIInterfaceOrientation)device.orientation))
        {
            //NSLog(@"Change to custom UI for portrait");
            self.rightGapPercentage = 0.40f;
            
        }

        return UIInterfaceOrientationMaskAll;
    }
    else
    {
        self.rightGapPercentage = 0.85f;
        return UIInterfaceOrientationMaskPortrait;
    }
    

}

/*
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // Do any additional setup after loading the view.
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {    // The iOS device = iPhone or iPod Touch
        
    }
    else if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    { // The iOS device = iPad
        
        
        if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
        {
            NSLog(@"Change to custom UI for landscape");
            self.rightGapPercentage = 0.40f;
            
        }
        else if (toInterfaceOrientation == UIInterfaceOrientationPortrait ||
                 toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            NSLog(@"Change to custom UI for portrait");
            self.rightGapPercentage = 0.85f;
            
        }
    }
    
}
*/



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) awakeFromNib {
    HomeViewController *rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeview"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController: rootViewController];
    [self setCenterPanel:navController];
    
//    if ([[appController.currentUser objectForKey:@"user_type"] isEqualToString:@"1"]) {
//         [self setLeftPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"OwnerleftPanelPage"]];
//    }else{
        [self setLeftPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"leftPanelPage"]];
    
}


#pragma mark - JA side panels UI edit
- (void)styleContainer:(UIView *)container animate:(BOOL)animate duration:(NSTimeInterval)duration {
}

- (void)stylePanel:(UIView *)panel {
}

@end
