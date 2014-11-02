//
//  ChatController.m
//  PatientClient
//
//  Created by dlz225 on 14-10-23.
//  Copyright (c) 2014年 duan. All rights reserved.
//

#import "ChatController.h"
#import "NSString+duan.h"
#import "ChatCell.h"
#define kGap 10

@interface ChatController () <UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (nonatomic,strong) UIView *inputView;
@property (nonatomic,strong) UITextView *inputTextView;   // 输入框
@property (nonatomic,strong) UIButton *sendBtn;     // 发送按钮
@property (nonatomic,strong) UITableView *chatTabView;
@property (nonatomic,strong) NSMutableArray *chatArray;

@end

@implementation ChatController

- (instancetype)init
{
    if (self = [super init]) {
        [self initNavigationUI];
        [self addSubview];
        
        // 让tableview的cell显示在最底部
        [self.chatTabView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.chatArray count]-1 inSection:0] atScrollPosition: UITableViewScrollPositionBottom animated:YES];

    }
    return self;
}

- (void)initNavigationUI
{
    // 初始化数组
    NSArray *Arr = @[@{@"user":@"Doctor A",@"content":@"hello！！！"},@{@"user":@"Doctor A",@"content":@"hello！！！"},@{@"user":@"Doctor A",@"content":@"hello！！！"},@{@"user":@"Doctor A",@"content":@"hello！！！"},@{@"user":@"Doctor A",@"content":@"hello！！！"},@{@"user":@"Doctor A",@"content":@"hello！！！"},@{@"user":@"Doctor A",@"content":@"hello！！！"},@{@"user":@"Doctor A",@"content":@"hello！！！"},@{@"user":@"Doctor A",@"content":@"hello！！！"},@{@"user":@"Doctor A",@"content":@"hello！！！"},@{@"user":@"Doctor A",@"content":@"hello！！！"},@{@"user":@"Doctor A",@"content":@"hello！！！"},@{@"user":@"Doctor A",@"content":@"hello！！！"},@{@"user":@"Doctor A",@"content":@"hello！！！"},@{@"user":@"Doctor A",@"content":@"hello！！！"},@{@"user":@"Doctor B",@"content":@"hddd"},@{@"user":@"Doctor D",@"content":@"heleeeeeeeeeeewerwerwqqweqweqweqweqweqweqweqweqweqweqwelo！！！"},];
    _chatArray = [NSMutableArray arrayWithArray:Arr];
    
    // 标题
    self.title = @"Dialog Chat";
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    // 设置滚动size
    self.scrollView.contentSize = CGSizeMake(0, [UIScreen mainScreen].bounds.size.height - 20 - 44);
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

- (void)rightButton
{
    
}

- (void)addSubview
{
    
    // tableview
    UITableView *tabView = [[UITableView alloc] initWithFrame:CGRectMake(kGap, 10, [UIScreen mainScreen].bounds.size.width - 2 * kGap, [UIScreen mainScreen].bounds.size.height - 44 - 90 + 8) style:UITableViewStylePlain];
    // 去掉灰色下划线
    tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabView.dataSource = self;
    tabView.delegate = self;
    [self.scrollView addSubview:tabView];
    self.chatTabView = tabView;
    
    // 输入栏
    UIView *v1 = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].applicationFrame.size.height - 44 - 44, [UIScreen mainScreen].bounds.size.width, 44)];
    [v1 setBackgroundColor:[UIColor colorWithRed:28 / 255 green:184 / 255 blue:255 / 255 alpha:0.5]];
    [self.scrollView addSubview:v1];
    self.inputView = v1;
    
    UITextView *textview = [[UITextView alloc] initWithFrame:CGRectMake(2 * kGap, 7, [UIScreen mainScreen].bounds.size.width - 90, 30)];
    // 设置textview边框
    textview.layer.borderWidth = 1.0;
    textview.layer.borderColor = [[UIColor grayColor] CGColor];
    textview.layer.cornerRadius = 5.0;
    [textview setFont:[UIFont systemFontOfSize:17]];
    textview.contentInset = UIEdgeInsetsZero;
    // 自适应高度
//    textview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    textview.delegate = self;
    [self.inputView addSubview:textview];
    self.inputTextView = textview;
    
    // Send Button
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 64,7,50,30);
    [btn1 setBackgroundImage:[UIImage imageNamed:@"senditem.png"] forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn1 setTitle:@"Send" forState:UIControlStateNormal];
    [btn1.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [btn1 addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchDown];
    [self.inputView addSubview:btn1];
    self.sendBtn = btn1;
    
    // 监听鼠标事件
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self.scrollView addGestureRecognizer:tap];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeKeyBoard:) name:UIKeyboardWillChangeFrameNotification object:nil];

}

- (void)send
{
    NSLog(@"%@",self.self.inputTextView.text);
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

#pragma mark - tableview delegate method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _chatArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentical = @"ChatCell";
//    static CGFloat count = 0;
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentical];
    if (!cell) {
        cell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentical];
        cell.dataArray = _chatArray;
    }
    cell.indexPath = indexPath;
    
//    count += cell.contentLabel.frame.size.height;
//    if (indexPath.row == _chatArray.count - 1) {
//        self.tabViewTrueHeight = count;
//    }
//    NSLog(@"last:%f",self.tabViewTrueHeight);
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
        return siz.height + 12 + 8;
    }
}


#pragma mark textview 计算文字高度改变控件高度
- (void)textViewDidChange:(UITextView *)textView
{
    UIFont *font = [UIFont systemFontOfSize:17];
    CGSize size = [NSString getSizeFromText:textView.text ForFont:font MaxSize:CGSizeMake(self.inputTextView.frame.size.width - 10, 90)];
    
    // 内容为2行时
    if (((int)size.height) / 20 == 2) {

        [self.sendBtn setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 64 ,17,50,30)];
        [self.inputView setFrame:CGRectMake(0, [UIScreen mainScreen].applicationFrame.size.height - 44 - 44 - 15, [UIScreen mainScreen].bounds.size.width, size.height + 30)];
        [self.inputTextView setFrame:CGRectMake(2 * kGap, 7,[UIScreen mainScreen].bounds.size.width - 90 , 45)];

    }
    // [UIScreen mainScreen].bounds.size.width - 64,7,50,30
    // 内容大于2行时，显示3行内容
    else if (((int)size.height) / 20 > 2)
    {
        [self.sendBtn setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 64 ,27,50,30)];
        [self.inputView setFrame:CGRectMake(0, [UIScreen mainScreen].applicationFrame.size.height - 44 - 44 - 35, [UIScreen mainScreen].bounds.size.width, size.height + 30)];
        [self.inputTextView setFrame:CGRectMake(2 * kGap, 7,[UIScreen mainScreen].bounds.size.width - 90 , 65)];
    }
    // 内容为1行时
    else
    {
        [self.inputView setFrame:CGRectMake(0, [UIScreen mainScreen].applicationFrame.size.height - 44 - 44, [UIScreen mainScreen].bounds.size.width, size.height + 30)];
        [self.inputTextView setFrame:CGRectMake(2 * kGap, 7,[UIScreen mainScreen].bounds.size.width - 90 , 30)];

    }
    [self.inputTextView scrollRangeToVisible:NSMakeRange([self.inputTextView.text length] - 1, 0)];

}

- (void)viewDidLoad {
    [super viewDidLoad];
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
