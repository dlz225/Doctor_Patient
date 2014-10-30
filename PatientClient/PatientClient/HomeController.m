//
//  HomeController.m
//  PatientClient
//
//  Created by dlz225 on 14-10-19.
//  Copyright (c) 2014年 duan. All rights reserved.
//

#import "HomeController.h"
#import "ResumeController.h"
#import "StartChatController.h"
#import "NSString+duan.h"
#import "PCAPIClient.h"
#import "PCAPIClient.h"

#define kLabelHeight 44     
#define kCellHeight 60
#define kGap 10     // 设置屏幕两边的间距
#define kTableViewWidth [UIScreen mainScreen].bounds.size.width-2*kGap
#define kButtonHeight 50

@interface HomeController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UITableView *msgTableView;
@property (nonatomic,strong) NSMutableArray *msgArray;

@end

@implementation HomeController

- (id)init{
    self = [super init];
    if (self) {
        
        [self initNavigationUI];
        [self initProperty];  
    }
    
    return self;
}

- (void)addData{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addData];
}

#pragma mark 设置基本属性

- (void)initNavigationUI
{
    self.title = @"TeleMedicine";
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    // 设置滚动size
    self.scrollView.contentSize = CGSizeMake(0, [UIScreen mainScreen].bounds.size.height + 1);
    [self.view addSubview:self.scrollView];
    
    // 左边按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"navigationbar_pop.png"];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    UIImage *image2 = [UIImage imageNamed:@"navigationbar_pop_highlighted.png"];
    [btn setBackgroundImage:image2 forState:UIControlStateHighlighted];
    btn.bounds = (CGRect){CGPointZero,image.size};
    self.leftItem = btn;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    // 右边按钮
    [self.view setBackgroundColor:[UIColor whiteColor]];
}


- (void)initProperty
{
    // 初始化数组,创建假数据
//    NSArray *Arr = @[@"das的撒的飞阿尔穷人多发发发撒旦法撒旦法师法师的范德萨发",@"das的撒的飞阿尔穷人多发发发撒旦法撒旦法师法师的范德萨发das的撒的飞阿尔穷人多发发发撒旦法撒旦法师法师发发发撒旦法撒旦法师法师发发发撒旦法撒旦法师法师",@"das的撒的飞阿",@"das的撒的飞阿",@"das的撒的飞阿",@"das的撒的飞阿尔穷人多发发发撒旦法撒旦法师法师的范德萨发"];
//    _msgArray = [NSMutableArray arrayWithArray:Arr];
    [[PCAPIClient sharedAPIClient] getPath:@"newsFlash!queryAllByPatientId" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"--------list----------");
//        NSArray *arr = [NSArray arrayWithArray:responseObject[@"newsVoList"]];
//        for (int i = 0; i < arr.count; i++) {
//            NSLog(@"%@",arr[i]);
//        }
        NSLog(@"%@",responseObject[@"newsVoList"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
    }];
    
    // 设置消息框标题
    self.titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"NEWSFLASH";
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    CGRect windowBounds = [UIScreen mainScreen].bounds;
    _titleLabel.frame = CGRectMake(0, windowBounds.size.height * 0.13, windowBounds.size.width, kLabelHeight);
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.scrollView addSubview:self.titleLabel];

    // 设置消息
    _msgTableView = [[UITableView alloc] initWithFrame:CGRectMake(kGap, _titleLabel.frame.origin.y + kLabelHeight , kTableViewWidth, [UIScreen mainScreen].bounds.size.height - 3 * kLabelHeight - CGRectGetMaxY(self.titleLabel.frame) - 40) style:UITableViewStylePlain];

    _msgTableView.dataSource = self;
    _msgTableView.delegate = self;
    // 去掉灰色下划线
    _msgTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.scrollView addSubview:_msgTableView];
    
    // start按钮
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame = CGRectMake(2 * kGap, _msgTableView.frame.origin.y + _msgTableView.frame.size.height + 20, kTableViewWidth - 2 *kGap, kButtonHeight);
    [startBtn setBackgroundColor:[UIColor blueColor]];
    [startBtn setTitle:@"Start New Chat" forState:UIControlStateNormal];
    [startBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [self.scrollView addSubview:startBtn];
    self.startButton = startBtn;
    
    // Resume按钮
    UIButton *ResumeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ResumeBtn.frame = CGRectMake(2 * kGap, startBtn.frame.origin.y + kButtonHeight + 20, kTableViewWidth - 2 *kGap, kButtonHeight);
    [ResumeBtn setBackgroundColor:[UIColor blueColor]];
    [ResumeBtn setTitle:@"Resume Previous Chat" forState:UIControlStateNormal];
    [ResumeBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [self.scrollView addSubview:ResumeBtn];
    self.resumeButton = ResumeBtn;
}


- (void)homeLeftButton
{
    NSLog(@"左边按钮");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _msgArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentical = @"HomeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentical];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentical];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel setFont:[UIFont systemFontOfSize:17]];
    cell.textLabel.text = _msgArray[indexPath.row];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13]];
    cell.detailTextLabel.text = @"2014--10--22";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = self.msgArray[indexPath.row];
    CGSize siz = [NSString getSizeFromText:str ForFont:[UIFont systemFontOfSize:17] MaxSize:CGSizeMake(kTableViewWidth - 20, MAXFLOAT)];
    if (siz.height + 10 <= 44) {
        return 44;
    }
    else
    {
        return siz.height + 10;
    }
}


@end
