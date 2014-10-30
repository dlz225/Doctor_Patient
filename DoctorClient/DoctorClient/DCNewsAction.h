//
//  DCNewsAction.h
//  DoctorClient
//
//  Created by JiangTeng on 14/10/29.
//  Copyright (c) 2014年 com.usc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,DCNewsActionType){
    DCNewsActionDelete,
    DCNewsActionUpdate,
    DCNewsActionCancel
};

typedef void(^DCNewsActionBlock) (DCNewsActionType newsAction);

@interface DCNewsAction : UIView


- (void)beginWithCompletion:(DCNewsActionBlock)completion;
@end
