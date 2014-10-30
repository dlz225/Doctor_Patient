//
//  LoginViewController.m
//  login
//
//  Created by 肖尧 on 14-10-18.
//  Copyright (c) 2014年 xiaoyao. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"


@interface LoginViewController ()<UITextFieldDelegate>


@property(nonatomic,strong) UITextField *userInput;
@property(nonatomic, strong) UITextField *passwordInput;

@end

@implementation LoginViewController


#pragma mark self method

- (id)init{
    self = [super init];
    if (self) {
        
        
        [self initSubview];
    }
    
    return self;
}


- (void)initSubview{
    
    self.userInput = [[UITextField alloc] initWithFrame:CGRectMake(110, 100, 150, 40)];
    self.userInput.backgroundColor = [UIColor whiteColor];
    self.userInput.borderStyle = UITextBorderStyleRoundedRect;
    self.userInput.delegate = self;
    self.userInput.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter ;//文字内容 垂直居中
    self.userInput.userInteractionEnabled = YES;
    self.userInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.userInput.returnKeyType = UIReturnKeyDone;
    self.userInput.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.userInput becomeFirstResponder];
    self.userInput.placeholder = @"Username";
    [self.view addSubview:self.userInput];
    
    
    self.passwordInput = [[UITextField alloc] initWithFrame:CGRectMake(110, 200, 150, 40)];
    self.passwordInput.backgroundColor = [UIColor whiteColor];
    self.passwordInput.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordInput.delegate = self;
    self.passwordInput.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter ;//文字内容 垂直居中
    self.passwordInput.secureTextEntry = YES;
    self.passwordInput.userInteractionEnabled = YES;
    self.passwordInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordInput.returnKeyType = UIReturnKeyDone;
    self.passwordInput.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.view addSubview:self.passwordInput];
    self.passwordInput.placeholder = @"Password";
    
    UIButton *loginButton =[[UIButton alloc] initWithFrame:CGRectMake(100, 300, 80, 40)];
    loginButton.backgroundColor = [UIColor whiteColor];
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(onloginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    UIButton *registerButton =[[UIButton alloc] initWithFrame:CGRectMake(100, 350, 80, 40)];
    registerButton.backgroundColor = [UIColor whiteColor];
    [registerButton setTitle:@"Register" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(pushRVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    
    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 100, 40)];
    userName.backgroundColor = [UIColor whiteColor];
    userName.text = @"Username:";
    [self.view addSubview:userName];
    
    UILabel *passWord= [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 100, 40)];
    passWord.backgroundColor = [UIColor whiteColor];
    passWord.text = @"Password:";
    [self.view addSubview:passWord];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    // Do any additional setup after loading the view.
}

- (void)pushRVC
{
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self presentViewController:registerVC
                       animated:YES
                     completion:^{
        
    }];
}








#pragma mark -------------------
- (void)onloginButtonClicked:(UIButton*)button{
    [self dologin];
    
}
- (void)dologin
{
    
    self.view.window.rootViewController = [DCMainViewController shareMainViewController];
    return ;
    
    NSString *name = self.userInput.text;
    NSString *pwd = self.passwordInput.text;
    NSString *message = nil;
    if (name == nil) {
        message = @"Account can not be empty";
    }else if (pwd == nil){
        message = @ "Password can not be empty";
    }else{
      //login success
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:name forKey:kLoginName];
        [userDefault setObject:pwd forKey:name];
        [userDefault synchronize];
        
        NSMutableDictionary *para = [NSMutableDictionary dictionary];
        [para setObject:pwd forKey:@"userVo.passWord"];
        [para setObject:name forKey:@"userVo.userName"];
        [para setObject:@(1) forKey:@"userVo.userType"];
        
        [DCAPIClient userAuth:@"login!login"
                   parameters:para
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
                          NSString *str = [responseObject objectForKey:@"userInfo"];
                          
                          [[DCAPIClient sharedAPIClient] setAccessToken:str];
                          NSLog(@"%@",str);
                          self.view.window.rootViewController = [DCMainViewController shareMainViewController];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
        
        
        
    }
}

#pragma mark -------------------
#pragma mark UITextFieldDelegate


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)_userInput shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    // return NO to not change text
    if (range.location > 20)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@" Length cannot be greater than 20" delegate:nil cancelButtonTitle:@"close" otherButtonTitles:nil];
        [alertView show];
        
        
        return NO;
    }
    NSLog(@"inputText: %@", self.userInput.text);
    return YES;
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
