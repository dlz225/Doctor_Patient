//
//  ResumeController.m
//  PatientClient
//
//  Created by dlz225 on 14-10-21.
//  Copyright (c) 2014年 duan. All rights reserved.
//

#import "ResumeController.h"
#import "ResumeCell.h"
#import "LastChat.h"

@interface ResumeController ()

@property (nonatomic,assign) BOOL canEdit;  // 是否能修改状态
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation ResumeController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        [self initUI];
        [self addData];
        self.canEdit = NO;
    }
    return self;
}

- (void)initUI
{
    // 标题
    self.title = @"Previous Chat";
    
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(rightButton)];

    self.tableView.userInteractionEnabled = YES;
}

- (void)addData
{
    // 初始化数组
    NSArray *Arr = @[@{@"doctor":@"Doctor A",@"subject":@"hello！！！",@"time":@"2014-10-01"},@{@"doctor":@"Doctor B",@"subject":@"wo hjkkkjhk",@"time":@"2014-10-02"},@{@"doctor":@"Doctor c",@"subject":@"wo hjkkkjhk",@"time":@"2014-10-02"},@{@"doctor":@"Doctor d",@"subject":@"wo hjkkkjhk",@"time":@"2014-10-02"}];
    self.dataArray = [NSMutableArray arrayWithArray:Arr];
}

#pragma mark edit按钮
- (void)rightButton
{
    self.canEdit = !_canEdit;
    [self.tableView setEditing:self.canEdit animated:YES];
    
    // 更改edit按钮样式
    if (self.canEdit == YES) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(rightButton)];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(rightButton)];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentical = @"resumeCell";
    ResumeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentical];
    if (!cell) {
        cell = [[ResumeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentical];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.resumeArray = self.dataArray;
    }
    cell.indexPath = indexPath;
    cell.accessoryView.hidden = self.canEdit;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LastChat *lastChat = [[LastChat alloc] init];
    lastChat.doctorName = @"duan";
    [self.navigationController pushViewController:lastChat animated:YES];
}

//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return self.canEdit;
//}

#pragma mark 当用户提交了一个编辑操作就会调用（比如点击了“删除”按钮）
// 只要实现了这个方法，就会默认添加滑动删除功能
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 如果不是删除操作，直接返回
    if (editingStyle != UITableViewCellEditingStyleDelete) return;
    
    // 1.删除模型数据
    [self.dataArray removeObjectAtIndex:indexPath.row];
    
    // 2.刷新表格
    //    [tableView reloadData];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
}

@end
