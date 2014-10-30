//
//  UItils.h
//  DoctorClient
//
//  Created by JiangTeng on 14/10/28.
//  Copyright (c) 2014年 com.usc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UItils : NSObject
+ (UIColor *)colorForHex:(NSString *)hexColor alpha:(CGFloat)alpha;
+ (NSDate *)dateFomatterForString:(NSString *)s;
+ (NSString *)parseLongDate:(NSDate *)date;

@end
