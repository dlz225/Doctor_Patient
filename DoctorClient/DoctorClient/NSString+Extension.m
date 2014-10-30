//
//  NSString+Extension.m
//  DoctorClient
//
//  Created by JiangTeng on 14/10/28.
//  Copyright (c) 2014年 com.usc. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (CGSize)sizeWithTextAttributes:(NSDictionary*)attributes
                            font:(UIFont*)theFont
               constrainedToSize:(CGSize)size
{
    CGSize textSize;
    
    // -sizeWithAttributes: method is available in iOS 7.0 and later
    if ( [self respondsToSelector:@selector(sizeWithAttributes:)] ) {
        CGRect textRect = [self boundingRectWithSize:size
                                             options:(NSStringDrawingUsesLineFragmentOrigin |
                                                      NSStringDrawingUsesFontLeading)
                                          attributes:attributes
                                             context:nil];
        textSize = textRect.size;
        textSize.width  = ceil(textSize.width);
        textSize.height = ceil(textSize.height);
        
    }
    else {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        textSize = [self sizeWithFont:theFont constrainedToSize:CGSizeMake(size.width, 10000.0)];
#pragma clang diagnostic pop
    }
    
    return textSize;
}



@end
