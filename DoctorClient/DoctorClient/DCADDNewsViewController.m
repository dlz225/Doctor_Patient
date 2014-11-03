//
//  DCADDNewsViewController.m
//  DoctorClient
//
//  Created by JiangTeng on 14/10/29.
//  Copyright (c) 2014年 com.usc. All rights reserved.
//

#import "DCADDNewsViewController.h"

@interface DCADDNewsViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UIScrollView *bgScrollView;
//@property (nonatomic, strong) UILabel *contentTitle;
@property (nonatomic, strong) UILabel *endTime;
@property (nonatomic, strong) UIButton *publish;

@property (nonatomic, strong) UIButton *rightItemBtn;
@end

@implementation DCADDNewsViewController

- (id)init{
    self = [super init];
    
    if (self) {
        [self initSubview];
    }
    
    return self;
}


- (void)initSubview{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"navigationbar_back"];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    btn.bounds = (CGRect){CGPointZero,image.size};
    [btn addTarget:self action:@selector(getBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIButton *addbtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage *addimage = [UIImage imageNamed:@"navigation_add"];
    [addbtn setTitle:@"Finish" forState:UIControlStateNormal];
//    [addbtn setBackgroundImage:addimage forState:UIControlStateNormal];
    [addbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    addbtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    addbtn.bounds = CGRectMake(0, 0, 50, 20);
    [addbtn addTarget:self action:@selector(editFinish) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addbtn];
    self.rightItemBtn = addbtn;

    
    
    
    UIScrollView *scroll = [[UIScrollView alloc] init];
//    [scroll setBackgroundColor:[UItils colorForHex:@"efeff4" alpha:1]];
    scroll.bounces = YES;
    scroll.clipsToBounds = NO;
    [self.view addSubview:scroll];
    self.bgScrollView = scroll;
    
    
    UITextView *textView = [[UITextView alloc] init];
    textView.font = [UIFont systemFontOfSize:20];
    textView.textColor = [UItils colorForHex:@"333333" alpha:1.0];
    textView.returnKeyType = UIReturnKeyDone;
    textView.delegate = self;
    [self.bgScrollView addSubview:textView];
    self.contentText = textView;
    
    UILabel *timelabel = [[UILabel alloc] init];
    timelabel.textColor = [UItils colorForHex:@"595657" alpha:0.8];
    timelabel.font = [UIFont systemFontOfSize:17];
    timelabel.textAlignment = NSTextAlignmentCenter;
    
    NSDate *nowDate = [NSDate new];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MMM-dd aa hh:mm"];
    NSString  *dateStr = [formatter stringFromDate:nowDate];
    
    timelabel.text = dateStr;
    [self.bgScrollView addSubview:timelabel];
    self.endTime = timelabel;
    
    
    UIButton *publishbtn = [[UIButton alloc] init];
    [publishbtn setTitle:@"publish" forState:UIControlStateNormal];
    publishbtn.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    
    [publishbtn setBackgroundImage:[UIImage imageNamed:@"CellSingle"]
                       forState:UIControlStateNormal];
    [publishbtn setBackgroundImage:[UIImage imageNamed:@"CellSingleHighlighted"]
                       forState:UIControlStateHighlighted];
   [publishbtn setTitleColor:[UItils colorForHex:@"000000" alpha:1.0f] forState:UIControlStateNormal];
    
//    [publishbtn setTitleColor:[UItils colorForHex:@"585456" alpha:1.0f] forState:UIControlStateNormal];
    [publishbtn addTarget:self action:@selector(publishNews) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:publishbtn];
    self.publish = publishbtn;
    
    
    [self.view setupSubviewTag];
    
    [self setupKeyboardNotification];
}


- (void)setupKeyboardNotification{
    __block DCADDNewsViewController *blockself = self;
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    blockself.rightItemBtn.hidden = NO;
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    blockself.rightItemBtn.hidden = YES;
                }];
}

- (void)publishNews{
    
    
    
}


- (void)editFinish{
    [self.contentText resignFirstResponder];
    
}

- (void)getBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
}



#pragma mark - textview deletage


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - setup subview frame
- (void)setupSbuviewFrame{
    
    CGSize size = self.view.frame.size;
    
    self.bgScrollView.frame = CGRectMake(0, 0, size.width, size.height);
    self.bgScrollView.contentSize = CGSizeMake(size.width, size.height + 0.5);
    
    self.endTime.frame = CGRectMake(0 , 20 , size.width, 20);
    self.contentText.frame = CGRectMake(15, 50, size.width -30, 200);
    
    
    self.publish.frame = CGRectMake(40, size.height - 80, size.width - 80, 40);
    
}



#pragma mark - self method

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"News";
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupSbuviewFrame];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setupSbuviewFrame];
    [self.contentText becomeFirstResponder];
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
