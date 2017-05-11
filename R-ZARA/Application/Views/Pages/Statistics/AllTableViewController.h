//
//  AllTableViewController.h
//  Malum
//
//  Created by Mars on 6/25/16.
//  Copyright © 2016 Mars. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *allTableView;


@end
