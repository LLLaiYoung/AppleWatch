//
//  ViewController.m
//  IWatch_TableView
//
//  Created by chairman on 16/5/9.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

/** https://github.com/CYBoys/iWatch */

/** The iOS app and iWatch the communication between the use of 'WCSession' */
/** Touch the screen to send data to iWatch  */
/** Please run on the iOS side, make sure the iphone app */

#import "ViewController.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import "HiSchool.h"
#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size
#define WEAKSELF __weak typeof(self) weakSelf = self;
@interface ViewController ()
<
WCSessionDelegate
>
@property WCSession *session;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak) UILabel *label;
@property (nonatomic, assign,getter=isTimerStatus) BOOL timerStatus;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"HiSchool&iWatch";
    self.session = [WCSession defaultSession];
    self.session.delegate = self;
    //* 必须激活session */
    [self.session activateSession];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    button.center = self.view.center;
    button.layer.cornerRadius = 10;
    button.layer.masksToBounds = YES;
    [button setTitle:[self dateStr] forState:UIControlStateNormal];
    button.tintColor = [UIColor whiteColor];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(sendMessageToiWatch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.button = button;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100,SCREEN_SIZE.width-(100*2) , 200)];
    label.font = [UIFont systemFontOfSize:20];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"点击按钮发送信息到iWatch";
    [self.view addSubview:label];
    self.label = label;

    self.timer =  [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateBtnTitle) userInfo:nil repeats:YES];
 
    self.timerStatus = YES;
}
- (void)updateBtnTitle {
    [self.button setTitle:[self dateStr] forState:UIControlStateNormal];
}
- (void)sendMessageToiWatch {
    if (!self.isTimerStatus) {
        //* 开始定时器 */
        NSDate *date = [NSDate distantPast];
        [self.timer setFireDate:date];
        self.label.text = @"点击按钮发送信息到iWatch";
    }
    NSData *avatarData = UIImagePNGRepresentation([UIImage imageNamed:@"IMG_0852"]);
    
    NSString *contnet = [@"Hello," stringByAppendingString:[NSString stringWithFormat:@"--%@",[self dateStr]]];
    NSDictionary *infoDic = @{kWCAvarat:avatarData,kWCName:@"LaiYoung",kWCContent:contnet};
    //* 发送数据到iWatch端 */
    //* 方式1  */
    [self.session transferCurrentComplicationUserInfo:infoDic];
    //* 方式2 */
//    [self.session sendMessage:infoDic replyHandler:nil errorHandler:nil];
}

- (NSString *)dateStr {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH时mm分ss秒"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}
#pragma mark - WCSessionDelegate
- (void)session:(WCSession *)session didFinishUserInfoTransfer:(WCSessionUserInfoTransfer *)userInfoTransfer error:(NSError *)error {
    NSLog(@"%@",error);
}
//* 接收数据方式1 配合 transferUserInfo */
-(void)session:(WCSession *)session didReceiveUserInfo:(NSDictionary<NSString *,id> *)userInfo {
    NSLog(@"currentThread---1 = %@",[NSThread currentThread]);
    //currentThread---1 = <NSThread: 0x7fc299db1f30>{number = 2, name = (null)}
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"currentThread---2 = %@",[NSThread currentThread]);
        //currentThread---2 = <NSThread: 0x7f8092607e40>{number = 1, name = main}
        weakSelf.label.text = [NSString stringWithFormat:@"iWatch:%@\n%@",userInfo[@"iWatch"],[weakSelf dateStr]];
        //* 暂停定时器 */
        NSDate *date = [NSDate distantFuture];
        [weakSelf.timer setFireDate:date];
    });

}
//* 接收数据方式2 配合 sendMessage: replyHandler: errorHandler: */
- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message {
    NSLog(@"currentThread---1 = %@",[NSThread currentThread]);
    // currentThread---1 = <NSThread: 0x7fc4d9f08530>{number = 2, name = (null)}
    WEAKSELF
    //* 在主线程更新UI (不然会有延迟,应该是默认在子线程执行)*/
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"currentThread---2 = %@",[NSThread currentThread]);
        //currentThread---2 = <NSThread: 0x7fc4d9d01810>{number = 1, name = main}
        weakSelf.label.text =[NSString stringWithFormat:@"iWatch:%@\n%@",message[@"iWatch"],[weakSelf dateStr]];
        //* 暂停定时器 */
        NSDate *date = [NSDate distantFuture];
        [weakSelf.timer setFireDate:date];
        weakSelf.timerStatus = NO;
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
