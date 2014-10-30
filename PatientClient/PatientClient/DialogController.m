//
//  DialogController.m
//  PatientClient
//
//  Created by dlz225 on 14-10-23.
//  Copyright (c) 2014年 duan. All rights reserved.
//

#import "DialogController.h"
#import "ChatCell.h"
#import "NSString+duan.h"
#import "ChatController.h"

#define kGap 10
#define kLabelHeight 30

@interface DialogController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) UIView *firstView;
@property (nonatomic,strong) UITableView *secondView;
@property (nonatomic,strong) UILabel *subjectLabel;
@property (nonatomic,strong) UILabel *doctorLabel;
@property (nonatomic,strong) UILabel *patientLabel;
@property (nonatomic,strong) UIButton *takePicBtn;
@property (nonatomic,strong) UIButton *VideoChatBtn;

@property (nonatomic,strong) UITableView *chatTabView;
@property (nonatomic,strong) NSMutableArray *chatArray;

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
    NSArray *Arr = @[@{@"user":@"Doctor A",@"content":@"hello！！！"},@{@"user":@"Doctor B",@"content":@"hddd"},@{@"user":@"Doctor D",@"content":@"heleeeeeeeeeeewerwerwqqwgggggggweqweqwgggweqweqwelo！！！"}];
    _chatArray = [NSMutableArray arrayWithArray:Arr];
    
    // 标题
    self.title = @"Telemedicine";
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    // 设置滚动size
    self.scrollView.contentSize = CGSizeMake(0, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:self.scrollView];
    
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
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Action" style:UIBarButtonItemStylePlain target:self action:@selector(rightButton)];
    [self.scrollView setBackgroundColor:[UIColor whiteColor]];
    
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
    [self.scrollView addSubview:view];
    self.firstView = view;
    // 第一块区域中的控件
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(kGap, 10, 80, kLabelHeight)];
    lab.text = @"Subject:";
    [lab setFont:[UIFont systemFontOfSize:17]];
    [self.firstView addSubview:lab];
    self.subjectLabel = lab;
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 120, kLabelHeight)];
    lab2.text = @"Doctor:";
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
    lab4.text = @"Doctor:";
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
    lab6.text = @"Patient:";
    [lab6 setFont:[UIFont systemFontOfSize:17]];
    [lab6 setTextAlignment:NSTextAlignmentLeft];
    [self.firstView addSubview:lab6];
    self.patientContentLabel = lab6;
    
    // enable video chat按钮
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(2 * kGap,[UIScreen mainScreen].bounds.size.height - 44 - 40 - 44, [UIScreen mainScreen].bounds.size.width - 4 * kGap, 44);
    [btn2 setBackgroundColor:[UIColor blueColor]];
    [btn2 setTitle:@"Enable Video Chat" forState:UIControlStateNormal];
    [btn2.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [self.scrollView addSubview:btn2];
    self.VideoChatBtn = btn2;
    
    
    // take picture按钮
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(2 * kGap, CGRectGetMinY(btn2.frame) - 44 - 20, [UIScreen mainScreen].bounds.size.width - 4 * kGap, 44);
    [btn1 setBackgroundColor:[UIColor blueColor]];
    [btn1 setTitle:@"Take Picture" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(takePicAction) forControlEvents:UIControlEventTouchUpInside];
    [btn1.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    [self.scrollView addSubview:btn1];
    self.takePicBtn = btn1;
    

    // tableview
    UITableView *tabView = [[UITableView alloc] initWithFrame:CGRectMake(kGap, 110, [UIScreen mainScreen].bounds.size.width - 2 * kGap, [UIScreen mainScreen].bounds.size.height - CGRectGetMinY(self.takePicBtn.frame) - 25 + 8) style:UITableViewStylePlain];
    tabView.contentSize = CGSizeMake(0, tabView.frame.size.height + 0.5);
    // 去掉灰色下划线
    tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabView.dataSource = self;
    tabView.delegate = self;
    [self.scrollView addSubview:tabView];
    self.chatTabView = tabView;
    
}

- (void)takePicAction
{
    ChatController *chat = [[ChatController alloc] init];
    [self.navigationController pushViewController:chat animated:YES];
}

// send按钮
//- (void)send
//{
//
//    NSLog(@"%@",self.inputField.text);
//}

- (void)rightButton
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _chatArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentical = @"telemedicineCell";
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentical];
    if (!cell) {
        cell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentical];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataArray = _chatArray;
    }
    
    cell.indexPath = indexPath;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = _chatArray[indexPath.row][@"content"];
    CGSize siz = [NSString getSizeFromText:str ForFont:[UIFont systemFontOfSize:15] MaxSize:CGSizeMake(180, MAXFLOAT)];
    if (siz.height + 15 <= 44) {
        return 44;
    }
    else
    {
        return siz.height + 20;
    }
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
