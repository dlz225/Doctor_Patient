//
//  DCNewsModel.m
//  DoctorClient
//
//  Created by JiangTeng on 14/10/28.
//  Copyright (c) 2014年 com.usc. All rights reserved.
//

#import "DCNewsModel.h"

@implementation DCNewsModel


- (void)setDict:(NSDictionary *)dict{
    
    _dict = dict;
    
    self.content = [dict objectForKey:kNewsContent];
    self.startTime = [dict objectForKey:kNewsStartTime];
    self.endTime = [dict objectForKey:kNewsEndTime];
    self.n_id = [dict objectForKey:kNewsId];
    
    CGSize size = [self.content sizeWithTextAttributes:nil font:kNewsFont constrainedToSize:CGSizeMake(kNewsWeight, 1000)];
    self.height = size.height > 40 ? size.height:40;
}

@end
