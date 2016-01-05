//
//  NetworkTool.h
//  PJ
//
//  Created by apple on 15/12/3.
//  Copyright © 2015年 dj0708. All rights reserved.
//  网络框架简易封装（带提示框）

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

// 网络提示框的出现时机，若干秒后网络数据还未返回则出现提示框
typedef NS_ENUM(NSUInteger, NetworkRequestGraceTimeType){
    NetworkRequestGraceTimeTypeNormal,  // 0.5s
    NetworkRequestGraceTimeTypeLong,    // 1s
    NetworkRequestGraceTimeTypeShort,   // 0.1s
    NetworkRequestGraceTimeTypeNone,     // 没有提示框
    NetworkRequestGraceTimeTypeAlways   // 总是有提示框
};


typedef void(^successBlock)(NSDictionary * response, AFHTTPRequestOperation * operation);
typedef void(^failureBlock)(NSError *error,AFHTTPRequestOperation * operation);


@interface NetworkTool : NSObject

// 是否有网络
+ (BOOL)hasNetworkReachability;


/**
 *  GET请求一般常用方法
 *
 *  graceTime               : 默认是NetworkRequestGraceTimeTypeNormal
 *  isHTTPRequestSerializer : 默认为YES
 *  isHTTPResponseSerializer: 默认是NO
 */
+ (AFHTTPRequestOperation *)Get:(NSString *)urlStr
                     parameters:(NSDictionary *)parameters
                        success:(successBlock)success
                        failure:(failureBlock)failure;

/**
 *  GET请求目标方法
 *
 *  @param urlStr                   网络请求的url
 *  @param parameters               请求体参数
 *  @param graceTime                网络提示框是否出现\什么时候出现枚举
 *  @param isHTTPRequestSerializer  YES代表是HTTP请求序列化器，NO代表是JSON请求序列化器
 *  @param isHTTPResponseSerializer YES代表是HTTP响应序列化器，NO代表是JSON响应序列化器
 *  @param success                  请求成功回调
 *  @param failure                  请求失败回调
 *
 *  @return 状态为isReady的当前操作AFHTTPRequestOperation
 */
+ (AFHTTPRequestOperation *)Get:(NSString *)urlStr
                     parameters:(NSDictionary *)parameters
                      graceTime:(NetworkRequestGraceTimeType)graceTime
        isHTTPRequestSerializer:(BOOL)isHTTPRequestSerializer
       isHTTPResponseSerializer:(BOOL)isHTTPResponseSerializer
                        success:(successBlock)success
                        failure:(failureBlock)failure;


/**
 *  POST请求一般常用方法
 *
 *  graceTime               : 默认是NetworkRequestGraceTimeTypeNormal
 *  isHTTPRequestSerializer : 默认为YES
 *  isHTTPResponseSerializer: 默认是NO
 */
+ (AFHTTPRequestOperation *)Post:(NSString *)urlStr
                      parameters:(NSDictionary *)parameters
                         success:(successBlock)success
                         failure:(failureBlock)failure;


/**
  *  POST请求目标方法
  *
  *  urlStr                   : 网络请求的url
  *  parameters               : 请求体参数
  *  isHTTPRequestSerializer  : YES代表是HTTP请求序列化器，NO代表是JSON请求序列化器
  *  isHTTPResponseSerializer : YES代表是HTTP响应序列化器，NO代表是JSON响应序列化器
  *  graceTime                : 网络提示框是否出现\什么时候出现枚举
  *  success                  : 请求成功回调
  *  failure                  : 请求失败回调
  *
  *  return                   : 状态为isReady的当前操作AFHTTPRequestOperation
 */
+ (AFHTTPRequestOperation *)Post:(NSString *)urlStr
                      parameters:(NSDictionary *)parameters
                       graceTime:(NetworkRequestGraceTimeType)graceTime
         isHTTPRequestSerializer:(BOOL)isHTTPRequestSerializer
        isHTTPResponseSerializer:(BOOL)isHTTPResponseSerializer
                         success:(successBlock)success
                         failure:(failureBlock)failure;


@end
