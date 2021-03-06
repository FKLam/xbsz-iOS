//
//  ResetViewController.m
//  xbsz
//
//  Created by lotus on 2016/12/24.
//  Copyright © 2016年 lotus. All rights reserved.
//

#import "ResetViewController.h"

@interface ResetViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UIImageView *appNameIV;

@property (nonatomic,strong) UITextField *userNameField;
@property (nonatomic,strong) UITextField *oldPasswordField;
@property (nonatomic,strong) UITextField *passwordFiled;

@property (nonatomic,strong) UIButton *registerBtn;


@end

@implementation ResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"重置密码";
    
    [self setShowTopRadius:NO];
    
    [self.view addSubview:self.appNameIV];
    
    [self.view addSubview:self.userNameField];
    [_userNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_appNameIV.mas_bottom).mas_offset(50);
        make.height.mas_equalTo(45);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(20);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-20);
    }];
    
    [self.view layoutIfNeeded];
    
    //设置上半部分圆角
    
    UIBezierPath *usernamePath = [UIBezierPath bezierPathWithRoundedRect:_userNameField.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *userMask = [[CAShapeLayer alloc] init];
    userMask.frame = _userNameField.bounds;
    userMask.path = usernamePath.CGPath;
    
    //设置边框
    CAShapeLayer *userLayer = [[CAShapeLayer alloc] init];
    userLayer.frame = _userNameField.bounds;
    userLayer.path = usernamePath.CGPath;
    userLayer.lineWidth = 1/CXMainScale;
    userLayer.strokeColor = CXLightGrayColor.CGColor;   // 边框颜色
    userLayer.fillColor = CXClearColor.CGColor;
    
    _userNameField.layer.mask = userMask;
    [_userNameField.layer addSublayer:userLayer];
    
    
    
    [self.view addSubview:self.oldPasswordField];
    [_oldPasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_userNameField.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left).mas_equalTo(20);
        make.right.mas_equalTo(self.view.mas_right).mas_equalTo(-20);
        make.height.mas_equalTo(45);
    }];
    
    [self.view layoutIfNeeded];
    
    UIBezierPath *nickPath = [UIBezierPath bezierPathWithRect:_oldPasswordField.bounds];
    
    
    CAShapeLayer *nickMask = [[CAShapeLayer alloc] init];
    nickMask.path = nickPath.CGPath;
    nickMask.frame = _oldPasswordField.bounds;
    
    CAShapeLayer *nickLayer = [[CAShapeLayer alloc] init];
    nickLayer.frame = _passwordFiled.bounds;
    nickLayer.path = nickPath.CGPath;
    nickLayer.lineWidth = 1/CXMainScale;
    nickLayer.strokeColor = CXLightGrayColor.CGColor;
    nickLayer.fillColor = CXClearColor.CGColor;
    
    _oldPasswordField.layer.mask = nickMask;
    [_oldPasswordField.layer addSublayer:nickLayer];
    
    
    
    //覆盖两文本框中间加深的那条线
    UIView *middleLine1 = [[UIView alloc] init];
    middleLine1.backgroundColor = CXWhiteColor;
    [self.view addSubview:middleLine1];
    [middleLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1/CXMainScale);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(20);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-20);
        make.bottom.mas_equalTo(_oldPasswordField.mas_top);
    }];
    
    
    
    [self.view addSubview:self.passwordFiled];
    [_passwordFiled mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(_oldPasswordField.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left).mas_equalTo(20);
        make.right.mas_equalTo(self.view.mas_right).mas_equalTo(-20);
        make.height.mas_equalTo(45);
    }];
    
    [self.view layoutIfNeeded];
    
    //设置下半部分圆角
    UIBezierPath *passwordPath = [UIBezierPath bezierPathWithRoundedRect:_passwordFiled.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(4, 4)];
    
    CAShapeLayer *passwordMask = [[CAShapeLayer alloc] init];
    passwordMask.path = passwordPath.CGPath;
    passwordMask.frame = _passwordFiled.bounds;
    
    CAShapeLayer *passwordLayer = [[CAShapeLayer alloc] init];
    passwordLayer.frame = _passwordFiled.bounds;
    passwordLayer.path = passwordPath.CGPath;
    passwordLayer.lineWidth = 1/CXMainScale;
    passwordLayer.strokeColor = CXLightGrayColor.CGColor;
    passwordLayer.fillColor = CXClearColor.CGColor;
    
    _passwordFiled.layer.mask = passwordMask;
    [_passwordFiled.layer addSublayer:passwordLayer];
    
    //覆盖两文本框中间加深的那条线
    UIView *middleLine2 = [[UIView alloc] init];
    middleLine2.backgroundColor = CXWhiteColor;
    [self.view addSubview:middleLine2];
    [middleLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1/CXMainScale);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(20);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-20);
        make.bottom.mas_equalTo(_passwordFiled.mas_top);
    }];
    
    
    [self.view addSubview:self.registerBtn];
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(20);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-20);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(_passwordFiled.mas_bottom).mas_offset(30);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter / setter

- (UIImageView *)appNameIV{
    if(!_appNameIV){
        _appNameIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_app_name"]];//#f16c4d
        _appNameIV.frame = CGRectMake((CXScreenWidth-180)/2, 120, 180, 50);
    }
    return _appNameIV;
}

- (UITextField *)userNameField{
    if(!_userNameField){
        _userNameField = [[UITextField alloc] init];
        _userNameField.placeholder = @"用户名";
        _userNameField.backgroundColor = CXWhiteColor;
        _userNameField.clearButtonMode=UITextFieldViewModeWhileEditing;
        _userNameField.returnKeyType = UIReturnKeyNext;
        [_userNameField setFont:[UIFont systemFontOfSize:16.0]];
        [_userNameField setTextColor:CXLightGrayColor];
        _userNameField.delegate = self;
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 33, 17)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_name"]];
        imageView.frame = CGRectMake(10, 0, 13, 17);
        [leftView addSubview:imageView];
        
        _userNameField.leftView = leftView;
        _userNameField.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
    }
    return _userNameField;
}

- (UITextField  *)oldPasswordField{
    if(!_oldPasswordField){
        _oldPasswordField = [[UITextField alloc] init];
        _oldPasswordField.placeholder = @"原始密码";
        _oldPasswordField.backgroundColor = CXWhiteColor;
        _oldPasswordField.returnKeyType = UIReturnKeyDone;
        _oldPasswordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        [_oldPasswordField setFont:CXSystemFont(16)];
        [_oldPasswordField setTextColor:CXLightGrayColor];
        _oldPasswordField.delegate = self;
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 33, 17)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_password"]];
        imageView.frame = CGRectMake(10, 0, 13, 17);
        [leftView addSubview:imageView];
        
        _oldPasswordField.leftView = leftView;
        _oldPasswordField.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
        
    }
    return _oldPasswordField;
}

- (UITextField *)passwordFiled{
    if(!_passwordFiled){
        _passwordFiled = [[UITextField alloc] init];
        _passwordFiled.placeholder = @"新密码(6~20位)";
        _passwordFiled.backgroundColor = CXWhiteColor;
        _passwordFiled.returnKeyType = UIReturnKeyDone;
        _passwordFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordFiled.secureTextEntry = YES;
        
        [_passwordFiled setFont:CXSystemFont(16)];
        [_passwordFiled setTextColor:CXLightGrayColor];
        _passwordFiled.delegate = self;
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 33, 17)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_password"]];
        imageView.frame = CGRectMake(10, 0, 13, 17);
        [leftView addSubview:imageView];
        
        _passwordFiled.leftView = leftView;
        _passwordFiled.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
        
        
    }
    return _passwordFiled;
}


- (UIButton *)registerBtn{
    if(!_registerBtn){
        _registerBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerBtn setTitle:@"重置密码" forState:UIControlStateNormal];
        [_registerBtn setTitleColor:CXWhiteColor forState:UIControlStateNormal];
        [_registerBtn setBackgroundColor:CXMainColor];
        _registerBtn.layer.cornerRadius = 20;
        [_registerBtn setClipsToBounds:YES];
    }
    return  _registerBtn;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == _userNameField){
        [_passwordFiled becomeFirstResponder];
    }else{
        CXLog(@"点击注册");
        [self.view endEditing:YES];
    }
    return YES;
    
}
@end
