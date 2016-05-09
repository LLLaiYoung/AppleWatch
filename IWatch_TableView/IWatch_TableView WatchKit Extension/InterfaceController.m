//
//  InterfaceController.m
//  IWatch_TableView WatchKit Extension
//
//  Created by chairman on 16/5/9.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "InterfaceController.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import "HiSchool.h"
#import "HiSchoolCell.h"
@interface InterfaceController()
<
WCSessionDelegate
>
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *countLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *tableView;
/** 所有接受对象 */
@property (nonatomic, strong) NSMutableArray *allReceiveObjects;
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
    [WCSession defaultSession];
    [[WCSession defaultSession] setDelegate:self];
    [[WCSession defaultSession] activateSession];
}
#pragma mark - WCSessionDelegate
- (void)session:(WCSession *)session didReceiveUserInfo:(NSDictionary<NSString *,id> *)userInfo {
    HiSchool *hischool = [HiSchool new];
    hischool.avatarData = userInfo[@"avatar"];
    hischool.name = userInfo[@"name"];
    hischool.content = userInfo[@"content"];
    [self.allReceiveObjects addObject:hischool];
    [self.countLabel setText:[NSString stringWithFormat:@"count:%i",self.allReceiveObjects.count]];
    [self.tableView setNumberOfRows:self.allReceiveObjects.count withRowType:@"HSCell"];
    for (NSInteger i=0; i<self.allReceiveObjects.count; i++) {
        HiSchoolCell *cell = [self.tableView rowControllerAtIndex:i];
        [cell setCellContent:hischool];
    }
}
- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



