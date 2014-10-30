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
@property (nonatomic, strong) UILabel *contentTitle;
@property (nonatomic, strong) UILabel *endTime;
@property (nonatomic, strong) UIButton *publish;

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
    
    
    UIScrollView *scroll = [[UIScrollView alloc] init];
    [scroll setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:scroll];
    self.bgScrollView = scroll;
    
    UILabel *title = [[UILabel alloc] init];
    [title setBackgroundColor:[UIColor clearColor]];
    title.font = [UIFont systemFontOfSize:13];
    title.textColor = [UItils colorForHex:@"595657" alpha:1.0];
    title.text = @"Context";
    [self.bgScrollView addSubview:title];
    self.contentTitle = title;
    
    UITextView *textView = [[UITextView alloc] init];
    textView.font = [UIFont systemFontOfSize:12];
    textView.textColor = [UItils colorForHex:@"595657" alpha:1.0];
    textView.layer.borderWidth = 0.5;
    textView.layer.borderColor = [UItils colorForHex:@"e5e1e2" alpha:1.0].CGColor;
    textView.returnKeyType = UIReturnKeyDone;
    textView.delegate = self;
    [self.bgScrollView addSubview:textView];
    self.contentText = textView;
    
    UILabel *timelabel = [[UILabel alloc] init];
    timelabel.textColor = [UItils colorForHex:@"595657" alpha:1.0];
    timelabel.font = [UIFont systemFontOfSize:12];
    timelabel.text = @"End Time";
//    [self.bgScrollView addSubview:timelabel];
    self.endTime = timelabel;
    
    
    UIButton *publishbtn = [[UIButton alloc] init];
    [publishbtn setTitle:@"publish" forState:UIControlStateNormal];
    publishbtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [publishbtn setTitleColor:[UItils colorForHex:@"585456" alpha:1.0f] forState:UIControlStateNormal];
    [publishbtn addTarget:self action:@selector(publishNews) forControlEvents:UIControlEventTouchUpInside];
    [self.bgScrollView addSubview:publishbtn];
    self.publish = publishbtn;
    
    
    
    [self setupSubviewTag:self.view];
}


- (void)publishNews{
    
    
    
}



- (void)setupSubviewTag:(UIView *)supView{
    supView.tag = kTagNumReservedForExcludingViews;
    for (UIView *view in supView.subviews) {
        [self setupSubviewTag:view];
    }
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
    self.bgScrollView.contentSize = CGSizeMake(size.width, size.height-61);
    
    self.contentTitle.frame = CGRectMake(20, 80, 100, 15);
    self.contentText.frame = CGRectMake(80, 50, size.width - 80 -20, 200);
    
    float timeY = CGRectGetMaxY(self.contentText.frame) + 30;
    self.endTime.frame = CGRectMake(20,timeY , 100, 15);
    
    self.publish.frame = CGRectMake((size.width -150)*0.5, size.height - 150, 150, 30);
    
}



#pragma mark - self method

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
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
