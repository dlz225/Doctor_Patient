//
//  DCWaitingRoomViewController.m
//  DoctorClient
//
//  Created by JiangTeng on 14/10/31.
//  Copyright (c) 2014年 com.usc. All rights reserved.
//

#import "DCWaitingRoomViewController.h"

@interface DCWaitingRoomViewController ()

@end

@implementation DCWaitingRoomViewController

- (id)init{
    self = [super init];
    
    if (self) {
        [self initSubview];
    }
    
    return self;
}

- (void)initSubview{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"navigationbar"];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    UIImage *imageHight = [UIImage imageNamed:@"navigationbar_Hight"];
    [btn setBackgroundImage:imageHight forState:UIControlStateHighlighted];
    btn.bounds = (CGRect){CGPointZero,image.size};
    self.leftButton = btn;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

}



#pragma mark - self method
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"Waiting Room";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
