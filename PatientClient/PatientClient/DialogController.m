//
//  DialogController.m
//  PatientClient
//
//  Created by dlz225 on 14-10-23.
//  Copyright (c) 2014年 duan. All rights reserved.
//

#import "DialogController.h"
#import "QuestionCell.h"
#import "NSString+duan.h"
#import "ChatController.h"
#import "PCWaitingController.h"
#import "ResumeController.h"

#define kGap 15
#define kLabelHeight 30

@interface DialogController () <UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UIView *firstView;
@property (nonatomic,strong) UITableView *secondView;
@property (nonatomic,strong) UILabel *subjectLabel;
@property (nonatomic,strong) UILabel *doctorLabel;
@property (nonatomic,strong) UILabel *patientLabel;
@property (nonatomic,strong) UIButton *takePicBtn;
@property (nonatomic,strong) UIButton *VideoChatBtn;
@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,strong) UITextView *answer;

@property (nonatomic,strong) UITableView *chatTabView;
@property (nonatomic,strong) NSMutableArray *questionArray;

@end

@implementation DialogController

- (instancetype)init
{
    if (self = [super init]) {
        [self initNavigationUI];
        [self initSubview];
        
    }
    return self;
}


- (void)initNavigationUI
{
    
    // 初始化数组
    _questionArray = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"1where are you from?" forKey:@"question"];
        [dict setObject:@"" forKey:@"answer"];
        [_questionArray addObject:dict];
    }
    
    // 标题
    self.title = self.doctorName;
    
    // 左边按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"navigationbar_back.png"];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    UIImage *image2 = [UIImage imageNamed:@"navigationbar_back_highlighted.png"];
    [btn setBackgroundImage:image2 forState:UIControlStateSelected];
    btn.bounds = (CGRect){CGPointZero,image.size};
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.leftItem = btn;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    // 右边按钮
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Finish" style:UIBarButtonItemStylePlain target:self action:@selector(Finish)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
}

#pragma mark - 提交问题
- (void)Finish
{
    int nilCount = 0;
    for (int i = 0; i < self.questionArray.count; i++) {
        NSMutableDictionary *dict = self.questionArray[i];
        if ([dict[@"answer"] isEqualToString:@""]) {
            nilCount++;
        }

    }
    // 检测表格是否都填完
    if (nilCount) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please fill the form " delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        alert.tag = 0;
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Do you want to hand up? " delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        alert.tag = 1;
        [alert show];

    }
}

// 导航返回
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)initSubview
{
    // 第一块区域
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 110)];
    [self.view addSubview:view];
    self.firstView = view;
    // 第一块区域中的控件
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(kGap, 10, 80, kLabelHeight)];
    lab.text = @"Subject";
    [lab setFont:[UIFont systemFontOfSize:17]];
    [self.firstView addSubview:lab];
    self.subjectLabel = lab;
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 120, kLabelHeight)];
    [lab2 setFont:[UIFont systemFontOfSize:17]];
    [lab2 setTextAlignment:NSTextAlignmentLeft];
    [self.firstView addSubview:lab2];
    self.subjectContentLabel = lab2;
    
    UILabel *lab3 = [[UILabel alloc]initWithFrame:CGRectMake(kGap, 40, 80, kLabelHeight)];
    lab3.text = @"Doctor:";
    [lab3 setFont:[UIFont systemFontOfSize:17]];
    [self.firstView addSubview:lab3];
    self.doctorLabel = lab3;
    
    UILabel *lab4 = [[UILabel alloc]initWithFrame:CGRectMake(100, 40, 120, kLabelHeight)];
    [lab4 setFont:[UIFont systemFontOfSize:17]];
    [lab4 setTextAlignment:NSTextAlignmentLeft];
    [self.firstView addSubview:lab4];
    self.doctorContentLabel = lab4;
    
    UILabel *lab5 = [[UILabel alloc]initWithFrame:CGRectMake(kGap, 70, 80, kLabelHeight)];
    lab5.text = @"Patient:";
    [lab5 setFont:[UIFont systemFontOfSize:17]];
    [self.firstView addSubview:lab5];
    self.patientLabel = lab5;
    
    UILabel *lab6 = [[UILabel alloc]initWithFrame:CGRectMake(100, 70, 120, kLabelHeight)];
    lab6.text = @"Jack";
    [lab6 setFont:[UIFont systemFontOfSize:17]];
    [lab6 setTextAlignment:NSTextAlignmentLeft];
    [self.firstView addSubview:lab6];
    self.patientContentLabel = lab6;
    UILabel *lab7 = [[UILabel alloc]initWithFrame:CGRectMake(kGap, 100, [UIScreen mainScreen].bounds.size.width - 2 * kGap, kLabelHeight + 7)];
    lab7.text = @"Tip:Please fill the forms before seeing the doctor";
    [lab7 setTextColor:[UIColor redColor]];
    lab7.numberOfLines = 0;
    [lab7 setFont:[UIFont systemFontOfSize:15]];
    [lab7 setTextAlignment:NSTextAlignmentLeft];
    [self.firstView addSubview:lab7];
    self.tipLabel = lab7;
//    
//    // enable video chat按钮
//    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn2.frame = CGRectMake(2 * kGap,[UIScreen mainScreen].bounds.size.height - 44 - 40 - 44, [UIScreen mainScreen].bounds.size.width - 4 * kGap, 44);
//    [btn2 setBackgroundColor:[UIColor blueColor]];
//    [btn2 setTitle:@"Enable Video Chat" forState:UIControlStateNormal];
//    [btn2.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
//    [self.scrollView addSubview:btn2];
//    self.VideoChatBtn = btn2;
//    
//    
//    // take picture按钮
//    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn1.frame = CGRectMake(2 * kGap, CGRectGetMinY(btn2.frame) - 44 - 20, [UIScreen mainScreen].bounds.size.width - 4 * kGap, 44);
//    [btn1 setBackgroundColor:[UIColor blueColor]];
//    [btn1 setTitle:@"Take Picture" forState:UIControlStateNormal];
//    [btn1 addTarget:self action:@selector(takePicAction) forControlEvents:UIControlEventTouchUpInside];
//    [btn1.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
//    [self.scrollView addSubview:btn1];
//    self.takePicBtn = btn1;

//    // scrollview
//    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tipLabel.frame), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(self.tipLabel.frame))];
//    // 设置滚动size
//    self.scrollView.contentSize = CGSizeMake(0, [UIScreen mainScreen].bounds.size.height - 65 + 0.5);
//    [self.view addSubview:self.scrollView];
    // tableview
    UITableView *tabView = [[UITableView alloc] initWithFrame:CGRectMake(kGap, CGRectGetMaxY(self.tipLabel.frame) + 4, [UIScreen mainScreen].bounds.size.width - 2 * kGap, [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(self.tipLabel.frame) - 70) style:UITableViewStylePlain];
    tabView.contentSize = CGSizeMake(0, tabView.frame.size.height + 0.5);
    // 去掉灰色下划线
    tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    tabView.dataSource = self;
    tabView.delegate = self;
    [self.view addSubview:tabView];
    self.chatTabView = tabView;
    
    // 监听鼠标事件
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeKeyBoard:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark ---触摸关闭键盘----
-(void)handleTap:(UIGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
}


#pragma mark ----键盘高度变化------
-(void)changeKeyBoard:(NSNotification *)aNotifacation
{
    //获取到键盘frame 变化之前的frame
    NSValue *keyboardBeginBounds=[[aNotifacation userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect beginRect=[keyboardBeginBounds CGRectValue];
    
    //获取到键盘frame变化之后的frame
    NSValue *keyboardEndBounds=[[aNotifacation userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect endRect=[keyboardEndBounds CGRectValue];
    
    CGFloat deltaY=endRect.origin.y-beginRect.origin.y;
    //拿frame变化之后的origin.y-变化之前的origin.y，其差值(带正负号)就是我们self.view的y方向上的增量
    
    [CATransaction begin];
    [UIView animateWithDuration:0.4f animations:^{
        
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+deltaY, self.view.frame.size.width, self.view.frame.size.height)];
        [self.chatTabView setContentInset:UIEdgeInsetsMake(self.chatTabView.contentInset.top-deltaY, 0, 0, 0)];
        
    } completion:^(BOOL finished) {
        
    }];
    [CATransaction commit];
    
}


- (void)takePicAction
{
    ChatController *chat = [[ChatController alloc] init];
    [self.navigationController pushViewController:chat animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 判断是否是ios7以上，调整下拉刷新的边界
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.questionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentical = @"QuestionCell";
    QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentical];
    if (!cell) {
       cell = [[QuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentical];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.dict = self.questionArray[indexPath.row];
    
    UITextView *textview = [[UITextView alloc] init];
    textview.tag = indexPath.row;
   
    textview.text = self.questionArray[indexPath.row][@"answer"];
    textview.frame = CGRectMake(0,cell.cellHeight, [UIScreen mainScreen].bounds.size.width - 2*kGap, 55);
    // 将键盘的return改为Done
    textview.returnKeyType = UIReturnKeyDone;
    // 设置边框
    textview.layer.borderWidth = 1.0;
    textview.layer.borderColor = [[UIColor grayColor] CGColor];
    textview.layer.cornerRadius = 5.0;

    [cell addSubview:textview];
    textview.delegate = self;
    self.answer = textview;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = self.questionArray[indexPath.row][@"question"];
    CGSize siz = [NSString getSizeFromText:str ForFont:[UIFont systemFontOfSize:15] MaxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 70 - 10,MAXFLOAT)];
    
    return siz.height + 60;
}

#pragma mark - textview delegate
- (void)textViewDidChange:(UITextView *)textView
{
    NSMutableDictionary *dict = self.questionArray[textView.tag];
    [dict setObject:textView.text forKey:@"answer"];
    
//    if ([textView.text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
//    }

}

#pragma mark - alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1 && buttonIndex == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Already send the question to doctor,please wait for a moment" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        alert.tag = 2;
        [alert show];
    }
    // 填完问题后
    if (alertView.tag == 2 && buttonIndex == 0) {
        ResumeController *resume = [[ResumeController alloc] init];
        resume.lastCtlIsDiagCtrl = YES;
        [self.navigationController pushViewController:resume animated:YES];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

}

@end
