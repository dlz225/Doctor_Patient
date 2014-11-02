//
//  SearchController.m
//  PatientClient
//
//  Created by dlz225 on 14-10-31.
//  Copyright (c) 2014年 duan. All rights reserved.
//

#import "SearchController.h"
#import "startCell.h"
#import "UIScrollView+AH3DPullRefresh.h"

@interface SearchController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) UIButton *searchBtn;
@property (nonatomic,strong) UITableView *listTableView;    // 搜索列表
@end

@implementation SearchController


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
    // 标题
    self.title = @"Search Doctor";
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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    // 设置背景
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)initSubview
{
    // searchbar
    UISearchBar *search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 44)];
    search.placeholder = @"Doctor Name";
    search.delegate = self;
    [self.scrollView addSubview:search];
    self.searchBar = search;
    
    // 查询结果列表 tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(10, 50, [UIScreen mainScreen].bounds.size.width - 20, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
//    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.scrollView addSubview:tableview];
    self.listTableView = tableview;
    
    // 监听鼠标事件
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self.scrollView addGestureRecognizer:tap];
    
    // 下拉刷新
    __unsafe_unretained SearchController *blockSelf = self;
    [self.listTableView setPullToRefreshHandler:^{
        [blockSelf pullToRefresh];
    }];
    [self.listTableView setPullToRefreshViewActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.listTableView setPullToRefreshViewPullingText:@"pull loading..."];
    [self.listTableView setPullToRefreshViewReleaseText:@"let go load..."];
    [self.listTableView setPullToRefreshViewLoadingText:@"loading..."];
    [self.listTableView setPullToRefreshViewLoadedText:@""];
}

- (void)pullToRefresh{
    __block SearchController *blockself =self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [blockself addData];
        [blockself.listTableView refreshFinished];
    });
    
}


#pragma mark 导航返回
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark search doctor
- (void)SearchDoctor
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 判断是否是ios7以上，调整下拉刷新的边界
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---触摸关闭键盘----
-(void)handleTap:(UIGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
}

#pragma mark - 键盘上的search按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"search!!!!");
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentical = @"SearchCell";
    startCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentical];
    if (!cell) {
        cell = [[startCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentical];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}



@end
