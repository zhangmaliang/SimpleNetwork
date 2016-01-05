//
//  NetworkTool.m
//  PJ
//
//  Created by apple on 15/12/3.
//  Copyright © 2015年 dj0708. All rights reserved.
//  网络框架简易封装（带提示框）

#import "NetworkTool.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>

#define kLastWindow [UIApplication sharedApplication].keyWindow

@implementation NetworkTool

#pragma mark - API方法

+ (BOOL)hasNetworkReachability{
    return _networkReachability;
}

+ (AFHTTPRequestOperation *)Get:(NSString *)urlStr
                     parameters:(NSDictionary *)parameters
                        success:(successBlock)success
                        failure:(failureBlock)failure{
    
    return [self Get:urlStr parameters:parameters  graceTime:NetworkRequestGraceTimeTypeNormal isHTTPRequestSerializer:YES isHTTPResponseSerializer:NO success:success failure:failure];
}


+ (AFHTTPRequestOperation *)Get:(NSString *)urlStr
                     parameters:(NSDictionary *)parameters
                      graceTime:(NetworkRequestGraceTimeType)graceTime
        isHTTPRequestSerializer:(BOOL)isHTTPRequestSerializer
       isHTTPResponseSerializer:(BOOL)isHTTPResponseSerializer
                        success:(successBlock)success
                        failure:(failureBlock)failure{
    
    AFHTTPRequestOperationManager *manager = [self manager:isHTTPRequestSerializer isHTTPResponseSerializer:isHTTPResponseSerializer];
    MBProgressHUD *hud = [self hud:graceTime];
    
    return [manager GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        hud.taskInProgress = NO;
        [hud hide:YES];
        
        if (success) {
            success(responseObject,operation);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        hud.taskInProgress = NO;
        [hud hide:YES];
        
        if (failure) {
            failure(error,operation);
        }
    }];
}

+ (AFHTTPRequestOperation *)Post:(NSString *)urlStr
                      parameters:(NSDictionary *)parameters
                         success:(successBlock)success
                         failure:(failureBlock)failure{
    
    return [self Post:urlStr parameters:parameters graceTime:NetworkRequestGraceTimeTypeNormal isHTTPRequestSerializer:YES isHTTPResponseSerializer:NO success:success failure:failure];
}

+ (AFHTTPRequestOperation *)Post:(NSString *)urlStr
                      parameters:(NSDictionary *)parameters
                       graceTime:(NetworkRequestGraceTimeType)graceTime
         isHTTPRequestSerializer:(BOOL)isHTTPRequestSerializer
        isHTTPResponseSerializer:(BOOL)isHTTPResponseSerializer
                         success:(successBlock)success
                         failure:(failureBlock)failure{
    
    
    AFHTTPRequestOperationManager *manager = [self manager:isHTTPRequestSerializer isHTTPResponseSerializer:isHTTPResponseSerializer];
    
    // 获取转圈控件
    MBProgressHUD *hud = [self hud:graceTime];
    
    
    // oper和operation指向同一个操作，但是状态不同，oper为isReady状态，operation是isFinished状态
    AFHTTPRequestOperation *oper = [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id responseObject) {
        
        // 任务结束，设置状态
        hud.taskInProgress = NO;
        [hud hide:YES];
        
        if (success) {
            success(responseObject,operation);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        hud.taskInProgress = NO;
        [hud hide:YES];
        
        if (failure) {
            failure(error,operation);
        }
    }];
    
    return oper;
}


#pragma mark - 私有方法

+ (AFHTTPRequestOperationManager *)manager:(BOOL)isHTTPRequestSerializer
                  isHTTPResponseSerializer:(BOOL)isHTTPResponseSerializer{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // AFN默认请求序列化器为HTTP类型
    if (!isHTTPRequestSerializer) {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    // AFN默认响应序列化器为JSON类型
    if (isHTTPResponseSerializer) {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    
    // 需要设置的请求头写在此处,如设置token
//    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];

    manager.requestSerializer.timeoutInterval = 10;
    
    return manager;
}


+ (MBProgressHUD *)hud:(NetworkRequestGraceTimeType)graceTimeType{
    NSTimeInterval graceTime = 0;
    switch (graceTimeType) {
        case NetworkRequestGraceTimeTypeNone:
            return nil;
            break;
        case NetworkRequestGraceTimeTypeNormal:
            graceTime = 0.5;
            break;
        case NetworkRequestGraceTimeTypeLong:
            graceTime = 1.0;
            break;
        case NetworkRequestGraceTimeTypeShort:
            graceTime = 0.1;
            break;
        case NetworkRequestGraceTimeTypeAlways:
            graceTime = 0;
            break;
    }
    
    MBProgressHUD *hud = [self hud];
    [kLastWindow addSubview:hud];
    hud.graceTime = graceTime;
    
    // 设置该属性，graceTime才能生效
    hud.taskInProgress = YES;
    [hud show:YES];
    
    return hud;
}

// 网络请求频率很高，不必每次都创建\销毁一个hud，只需创建一个反复使用即可
+ (MBProgressHUD *)hud{
    MBProgressHUD *hud = objc_getAssociatedObject(self, _cmd);
    
    if (!hud) {
        // 参数kLastWindow仅仅是用到了其CGFrame，并没有将hud添加到上面
        hud = [[MBProgressHUD alloc] initWithWindow:kLastWindow];
        hud.labelText = @"加载中...";
        
        objc_setAssociatedObject(self, _cmd, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        NSLog(@"创建了一个HUD");
    }
    return hud;
}

static BOOL _networkReachability;
// 开启网络检测
+ (void)openNetworkCheckReachability{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
            case AFNetworkReachabilityStatusReachableViaWWAN:
                _networkReachability = YES;
                break;
            default:
                _networkReachability = NO;
                break;
        }
    }];
}

+ (void)load{
    [self openNetworkCheckReachability];
}

@end
