//
//  ViewController.m
//  IWatch_TableView
//
//  Created by chairman on 16/5/9.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

/** The iOS app and iWatch the communication between the use of 'WCSession' */
/** Touch the screen to send data to iWatch  */
/** Please run on the iOS side, make sure the iphone app */

#import "ViewController.h"
#import <WatchConnectivity/WatchConnectivity.h>
@interface ViewController ()
<
WCSessionDelegate
>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"HiSchool&iWatch";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[WCSession defaultSession] setDelegate:self];
    [[WCSession defaultSession] activateSession];
    NSData *avatarData = UIImagePNGRepresentation([UIImage imageNamed:@"braceletLiked"]);
    NSDictionary *infoDic = @{@"avatar":avatarData,@"name":@"LaiYoung",@"content":@"Hello LaiYoung"};
    [[WCSession defaultSession] transferCurrentComplicationUserInfo:infoDic];
}
#pragma mark - WCSessionDelegate
- (void)session:(WCSession *)session didFinishUserInfoTransfer:(WCSessionUserInfoTransfer *)userInfoTransfer error:(NSError *)error {
    NSLog(@"%@",error);
}
@end
