//
//  HiSchool.h
//  IWatch_TableView
//
//  Created by chairman on 16/5/9.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSString *const kWCAvarat = @"avatar";
static NSString *const kWCName = @"name";
static NSString *const kWCContent = @"content";
@interface HiSchool : NSObject
/** avatar */
@property (nonatomic, strong) NSData *avatarData;
/** name */
@property (nonatomic, copy) NSString *name;
/** content */
@property (nonatomic, copy) NSString *content;
@end
