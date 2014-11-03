//
//  SettingTableViewCell.h
//  DoctorClient
//
//  Created by JiangTeng on 14/10/30.
//  Copyright (c) 2014年 com.usc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewCell : UITableViewCell


@property (nonatomic, strong) UILabel *dataLabel;

- (void)updateIconImageName:(NSString*)imageName
               andIconLabel:(NSString*)iconLabel
                    andData:(NSString*)data
               andShowArrow:(BOOL)isShowArrow;

- (void)updateData:(NSString*)data;


@end
