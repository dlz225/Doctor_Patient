//
//  NSString+Extension.h
//  DoctorClient
//
//  Created by JiangTeng on 14/10/28.
//  Copyright (c) 2014年 com.usc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (CGSize)sizeWithTextAttributes:(NSDictionary*)attributes
                            font:(UIFont*)theFont
               constrainedToSize:(CGSize)size;

@end
