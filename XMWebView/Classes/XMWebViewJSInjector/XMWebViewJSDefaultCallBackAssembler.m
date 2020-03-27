//
//  XMWebViewJSCallBackAssembler.m
//  XMWebView
//
//  Created by xiaoma on 2019/6/10.
//  Copyright © 2019 xiaoma. All rights reserved.
//

#import "XMWebViewJSDefaultCallBackAssembler.h"

NSString *const XMWebViewJSParserDefaultCallBackMethodName = @"XM_NativeCallBack";

@implementation XMWebViewJSDefaultCallBackAssembler

+ (instancetype)defaultCallBackAssembler {
    return [[XMWebViewJSDefaultCallBackAssembler alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.jsCallBackMethodName = XMWebViewJSParserDefaultCallBackMethodName;
    }
    return self;
}

- (NSString *)createCallBackJSStringWithJSMethod:(NSString *)jsMethodName parameters:(id)parameters {
    id data = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [NSString stringWithFormat:@"%@.%@(%@)",  self.jsCallBackMethodName, jsMethodName, jsonString];
}

@end
