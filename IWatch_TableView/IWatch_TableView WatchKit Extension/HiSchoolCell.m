//
//  HiSchoolCell.m
//  IWatch_TableView
//
//  Created by chairman on 16/5/9.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#import "HiSchoolCell.h"
#import <WatchKit/WatchKit.h>
#import "HiSchool.h"
@interface HiSchoolCell()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *avatarImage;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *nikeNameLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *contentLabel;

@end

@implementation HiSchoolCell
- (void)setCellContent:(HiSchool *)content {
    [self.avatarImage setImageData:content.avatarData];
    [self.nikeNameLabel setText:content.name];
    [self.contentLabel setText:content.content];
}
@end
