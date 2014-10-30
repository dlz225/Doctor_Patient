//
//  UItils.m
//  DoctorClient
//
//  Created by JiangTeng on 14/10/28.
//  Copyright (c) 2014年 com.usc. All rights reserved.
//

#import "UItils.h"

@implementation UItils

+ (UIColor *)colorForHex:(NSString *)hexColor alpha:(CGFloat)alpha
{
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [hexColor substringWithRange:range];
    range.location = 2;
    NSString *gString = [hexColor substringWithRange:range];
    range.location = 4;
    NSString *bString = [hexColor substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}


+ (NSDate *)dateFomatterForString:(NSString *)s
{
    // 2013-04-22T11:49:08.108+08:00
    NSDate *date = nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'.'SSSZ"];
    date = [formatter dateFromString:s];
    if (date == nil)  {
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        date = [formatter dateFromString:s];
    }
    
    return date;
}

+ (NSString *)parseLongDate:(NSDate *)date;
{
    NSString *dateStr = nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    dateStr = [formatter stringFromDate:date];
    return dateStr;
}


@end
