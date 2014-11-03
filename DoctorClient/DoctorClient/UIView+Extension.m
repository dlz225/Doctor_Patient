//
//  UIView+Extension.m
//  DoctorClient
//
//  Created by JiangTeng on 14/10/31.
//  Copyright (c) 2014年 com.usc. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)setupSubviewTag{
    self.tag = kTagNumReservedForExcludingViews;
    for (UIView *view in self.subviews) {
        [view setupSubviewTag];
    }
}

@end
