//
//  InterfaceController.m
//  IWatch_TableView WatchKit Extension
//
//  Created by chairman on 16/5/9.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

/** https://github.com/CYBoys/iWatch */

#import "InterfaceController.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import "HiSchool.h"
#import "HiSchoolCell.h"
#define WEAKSELF __weak typeof(self) weakSelf = self;
@interface InterfaceController()
<
WCSessionDelegate
>

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *headerBtn;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *tableView;
/** 所有接收对象 */
@property (nonatomic, strong) NSMutableArray *allReceiveObjects;
@property WCSession *session;
@end


@implementation InterfaceController
#pragma mark - lazy loading
- (NSMutableArray *)allReceiveObjects {
    if (!_allReceiveObjects) {
        _allReceiveObjects = [NSMutableArray array];
    }
    return _allReceiveObjects;
}
- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    self.session =[WCSession defaultSession];
    self.session.delegate = self;
    //* 必须激活session */
    [self.session activateSession];
}
- (IBAction)removeAllBtn {
    //* 删除 */
    NSRange range = NSMakeRange(0, self.allReceiveObjects.count);
    [self.tableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
    [self.headerBtn setTitle:@"已删除全部\n并发送消息到iOS"];
    [self.allReceiveObjects removeAllObjects];
    //* 发送数据到iOS */
    NSDictionary *infoDic = @{@"iWatch":@"iWatch已删除全部"};
    //* 方式1 */
//    [self.session sendMessage:infoDic replyHandler:nil errorHandler:nil];
    //* 方式2 */
    [self.session transferUserInfo:infoDic];
}
#pragma mark - WCSessionDelegate
//* 接收数据方式1 配合 transferCurrentComplicationUserInfo */
- (void)session:(WCSession *)session didReceiveUserInfo:(NSDictionary<NSString *,id> *)userInfo {
    [self setTableCell:userInfo];
}
//* 接收数据方式2 配合 sendMessage: replyHandler: errorHandler: */
- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message {
    [self setTableCell:message];
  }
- (void)setTableCell:(NSDictionary *)dic {
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        HiSchool *hischool = [HiSchool new];
        hischool.avatarData = dic[kWCAvarat];
        hischool.name = dic[kWCName];
        hischool.content = dic[kWCContent];
        [weakSelf.allReceiveObjects addObject:hischool];
        [weakSelf.headerBtn setTitle:[NSString stringWithFormat:@"count:%i\n点击此处删除全部",weakSelf.allReceiveObjects.count]];
        
        //* 新增数据 */
        [weakSelf.tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:0]  withRowType:@"HSCell"];
        HiSchoolCell *cell = [weakSelf.tableView rowControllerAtIndex:0];
        [cell setCellContent:hischool];
    });

}
- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



