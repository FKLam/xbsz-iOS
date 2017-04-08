//
//  CXNetwork+User.m
//  xbsz
//
//  Created by lotus on 2017/4/7.
//  Copyright © 2017年 lotus. All rights reserved.
//

#import "CXNetwork+User.h"

@implementation CXNetwork (User)

+ (void)JWLogin:(NSString *)username
       password:(NSString *)password
        success:(CXNetWorkSuccessBlock)success
        failure:(CXNetWorkFailureBlock)failure{
    NSDictionary *parameters = @{@"username": username, @"password":password,
                                 @"apnsKey":JWAPNSKey,@"serialNo":JWSerialNo};
    
    [self invokeUnsafePOSTRequest:JWLoginUrl parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        // 获取所有数据报头信息
        NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)task.response;
        NSDictionary *fields = [HTTPResponse allHeaderFields];// 原生NSURLConnection写法
        
        NSString *cookieString = [fields valueForKey:@"ssoCookie"];
        NSArray *arr = [cookieString JSONValue];
        NSString *CASTGC = [[arr objectAtIndex:0] valueForKey:@"cookieValue"];
        NSString *JWSessionID = [fields valueForKey:@"Set-Cookie"];
        JWSessionID = [JWSessionID stringByReplacingOccurrencesOfString:@"JSESSIONID=" withString:@""];
        JWSessionID = [JWSessionID stringByReplacingOccurrencesOfString:@"; Path=/; Secure" withString:@""];
        NSString *userPwd = [fields valueForKey:@"userPwd"];            //获取加密后的密码
        
        JWLocalUser *user = [JWLocalUser instance];
        user.JWUserName = username;
        user.JWPassword = password;             //明文密码
        user.JWEncryptPassword = userPwd;
        user.JWCastgc = CASTGC;
        if(JWSessionID)     user.JWSessionID = JWSessionID;
        user.time = [[NSDate new] stringWithFormat:@"yyyy-MM-dd HH:mm"];
        [user save];
        
        CallbackRsp(task.response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        InvokeFailure(error);
    }];
}


+ (void)JWRefreshLogin:(NSString *)url
               success:(CXNetWorkSuccessBlock)success
               failure:(CXNetWorkFailureBlock)failure{
    JWLocalUser *user = [JWLocalUser instance];
    if(![user isAuthorized])    return;
    
    //需要注入的Cookie
    NSString *cookieStr;
    if(![JWLocalUser instance].JWSessionID){
        cookieStr = [NSString stringWithFormat:@"CASTGC=%@",[JWLocalUser instance].JWCastgc];
    }else{
        cookieStr = [NSString stringWithFormat:@"JSESSIONID=%@;CASTGC=%@",[JWLocalUser instance].JWSessionID,[JWLocalUser instance].JWCastgc];
    }
    
    NSDictionary *parameters = @{@"username": user.JWUserName, @"password":user.JWEncryptPassword,
                                @"serialNo":JWSerialNo};

    [self invokeUnsafePOSTRequest:JWRefreshLoginURL parameters:parameters cookieStr:cookieStr success:^(NSURLSessionDataTask *task, id responseObject) {
        // 获取所有数据报头信息
        NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)task.response;
        NSDictionary *fields = [HTTPResponse allHeaderFields];
        
        NSString *cookieString = [fields valueForKey:@"ssoCookie"];
        NSArray *arr = [cookieString JSONValue];
        NSString *CASTGC = [[arr objectAtIndex:0] valueForKey:@"cookieValue"];
        
        NSString *JWSessionID = [fields valueForKey:@"Set-Cookie"];
        JWSessionID = [JWSessionID stringByReplacingOccurrencesOfString:@"JSESSIONID=" withString:@""];
        JWSessionID = [JWSessionID stringByReplacingOccurrencesOfString:@"; Path=/; Secure" withString:@""];
        
        JWLocalUser *user = [JWLocalUser instance];
        user.JWCastgc = CASTGC;
        if(JWSessionID != nil)  user.JWSessionID = JWSessionID;
        [user save];
        CallbackRsp(task.response);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        InvokeFailure(error);
    }];
}

@end
