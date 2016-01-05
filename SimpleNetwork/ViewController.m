//
//  ViewController.m
//  SimpleNetwork
//
//  Created by apple on 15/12/31.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ViewController.h"
#import "NetworkTool.h"


@interface ViewController ()

@end

@implementation ViewController

static NSString *const urlString = @"https://www.taobao.com";

// 不延时，总是出现提示框
- (IBAction)click1 {
    [self requestNetwork:NetworkRequestGraceTimeTypeAlways];
    
}

// 延时短的，0.1s内网络数据未返回才出现提示框
- (IBAction)click2:(id)sender {
    [self requestNetwork:NetworkRequestGraceTimeTypeShort];
}

// 延时长的，1s内网络数据未返回才出现提示框
- (IBAction)click3:(id)sender {
    [self requestNetwork:NetworkRequestGraceTimeTypeLong];

}
// 延时普通的，0.5s内网络数据未返回才出现提示框
- (IBAction)click4:(id)sender {
    [self requestNetwork:NetworkRequestGraceTimeTypeNormal];

}
// 永不出现提示框
- (IBAction)click5:(id)sender {
    [self requestNetwork:NetworkRequestGraceTimeTypeNone];
}

- (void)requestNetwork:(NetworkRequestGraceTimeType)graceTimeType{
    
    if (![NetworkTool hasNetworkReachability]) { // 没有网络，返回
        return;
    }
    
    // 公司中一般请求不需要设置请求\响应序列化器，此处因为访问的是网页，返回的是text/plain，需要手动设置响应序列化器为HTTP类型
    [NetworkTool Post:urlString parameters:nil graceTime:graceTimeType isHTTPRequestSerializer:YES isHTTPResponseSerializer:YES success:^(NSDictionary *response, AFHTTPRequestOperation *operation) {
        
        NSLog(@"网络请求成功");
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        NSLog(@"网络请求失败");
    }];
}

@end
