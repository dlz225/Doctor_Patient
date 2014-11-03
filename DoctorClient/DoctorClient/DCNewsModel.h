//
//  DCNewsModel.h
//  DoctorClient
//
//  Created by JiangTeng on 14/10/28.
//  Copyright (c) 2014年 com.usc. All rights reserved.
//

#import <Foundation/Foundation.h>
// newsFlashVo.{ newsContent,endTime

#define kNewsContent @"newsFlashVo.newsContent"
#define kNewsEndTime @"newsFlashVo.endTime"
#define kNewsStartTime @"newsFlashVo.startTime"
#define kNewsId @"newsFlashVo.id"


#define kNewsWeight (kMainSize.width - 10 - 80)
#define kNewsFont [UIFont systemFontOfSize:15]


@interface DCNewsModel : NSObject

@property (nonatomic, strong) NSString *n_id;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) NSDictionary *dict;

@end
