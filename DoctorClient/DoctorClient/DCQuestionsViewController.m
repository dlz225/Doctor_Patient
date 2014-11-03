//
//  DCQuestionsViewController.m
//  DoctorClient
//
//  Created by JiangTeng on 14/10/31.
//  Copyright (c) 2014年 com.usc. All rights reserved.
//

#import "DCQuestionsViewController.h"
#import "DCCustomQuestionViewController.h"



@interface DCQuestionsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *questionsTable;
@property (nonatomic, strong) NSMutableArray *questionsArray;
@property (nonatomic, strong) UIButton *addAuestionBtn;

@end

@implementation DCQuestionsViewController

- (id)init{
    self = [super init];
    if (self) {
        
        [self initMumber];
        [self initSubview];
        [self addData];
    }
    
    return self;
}



- (void)addData{
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    NSArray *array = [NSArray arrayWithObjects:@"Q1: Tell me what is the problem?",
                                               @"Q2: When did it start?",
                                               @"Q3: How did it start?",
                                               @"Q4: Is the problem spreading? Changing? Worsening?",
                                               @"Q5: What are the associated symptoms, What are the associated symptoms,ie?",nil];
    
    [para setObject:array forKey:kQuestionsArray];
    [para setObject:@"General" forKey:kQuestionType]; //Subject:  74
    
    
    NSMutableDictionary *para2 = [NSMutableDictionary dictionary];
    NSArray *array2 = [NSArray arrayWithObjects:@"Q1: Tell me what is the problem?",
                      @"Q2: When did it start?",
                      @"Q3: How did it start?",
                      @"Q4: Is the problem spreading? Worsening?",
                      @"Q5: What are the associated symptoms, itchy?",nil];
    [para2 setObject:array2 forKey:kQuestionsArray];
    [para2 setObject:@"Custom" forKey:kQuestionType];
    
    
    NSMutableDictionary *para3 = [NSMutableDictionary dictionary];
    NSArray *array3 = [NSArray array];
//    NSArray *array3 = [NSArray arrayWithObjects:@"You can subscribe to new issues",nil];
    [para3 setObject:array3 forKey:kQuestionsArray];
    [para3 setObject:@"Custom Question" forKey:kQuestionType];
    

    
    
    [self.questionsArray addObject:para];
    [self.questionsArray addObject:para2];
//    [self.questionsArray addObject:para3];
    
}

- (void)initMumber{
    self.questionsArray = [NSMutableArray array];
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
    
    UITableView *tableview = [[UITableView alloc] init];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.clipsToBounds = NO;
    [self.view addSubview:tableview];
    self.questionsTable = tableview;
    
    
    UIButton *addbtn = [[UIButton alloc] init];
    [addbtn setTitle:@"Custom Question" forState:UIControlStateNormal];
    [addbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    addbtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [addbtn addTarget:self action:@selector(addCustomQuestion) forControlEvents:UIControlEventTouchUpInside];
    [addbtn setBackgroundColor:[UItils colorForHex:@"6666cc" alpha:1]];
    [self.view addSubview:addbtn];
    self.addAuestionBtn = addbtn;
    
}



#pragma mark - tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.questionsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = [self.questionsArray[section] objectForKey:@"questionsarray"];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *quesIdentifier = @"DCQuestions";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:quesIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:quesIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSArray *array = [self.questionsArray[indexPath.section] objectForKey:kQuestionsArray];
    
    CGRect newframe = cell.textLabel.frame;
    newframe.origin.x = 10;
    newframe.size.width -= 10;
    cell.textLabel.frame =newframe;
    cell.textLabel.text = array[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = kTextColor;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setBackgroundColor:[UItils colorForHex:@"efeff4" alpha:1]];
    [btn setTitle:[self.questionsArray[section] objectForKey:kQuestionType] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -100, 0, 0)];
    
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    
    btn.tag = section;
    [btn addTarget:self action:@selector(tapSection:) forControlEvents:UIControlEventTouchUpInside];
    
//    if (section == ([self.questionsArray count] - 1)) {
//        [btn setBackgroundColor:[UItils colorForHex:@"6666cc" alpha:1]];
//
//    }
    
//    UILabel *label = [[UILabel alloc] init];
//    label.backgroundColor = [UItils colorForHex:@"efeff4" alpha:1];
//    label.text = [self.questionsArray[section] objectForKey:kQuestionType];
//    label.font = [UIFont boldSystemFontOfSize:17];
    
    return btn;
}


- (void)addCustomQuestion{
    DCCustomQuestionViewController *coustomQuestion = [[DCCustomQuestionViewController alloc] init];
    coustomQuestion.resultDict = [self.questionsArray firstObject];
    [self.navigationController pushViewController:coustomQuestion animated:YES];
}

- (void)tapSection:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    
    DCCustomQuestionViewController *coustomQuestion = [[DCCustomQuestionViewController alloc] init];
    coustomQuestion.resultDict = self.questionsArray[btn.tag];
    
    [self.navigationController pushViewController:coustomQuestion animated:YES];
    
    NSLog(@"%ld",btn.tag);
    
}


#pragma mark - setup Subview Frame

- (void)setupSubviewFrame{
    CGSize size = self.view.bounds.size;
    self.questionsTable.frame = CGRectMake(0, 0, size.width, size.height - 70);
    
    self.addAuestionBtn.frame = CGRectMake(20, CGRectGetMaxY(self.questionsTable.frame) + 15, size.width-40, 44);
}



#pragma mark - self method

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.questionsTable setBackgroundColor:[UIColor redColor]];
    self.title = @"Questions";
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.view setBackgroundColor:[UItils colorForHex:@"f1f1f7" alpha:1.0]];
    [self setupSubviewFrame];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setupSubviewFrame];
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
