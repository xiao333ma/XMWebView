//
//  XMWebViewJSDefaultAssembler.m
//  XMWebView
//
//  Created by xiaoma on 2019/6/6.
//  Copyright © 2019 xiaoma. All rights reserved.
//

#import "XMWebViewJSDefaultAssembler.h"

static NSString * const XMWebViewJSDefaultAssemblerJSMethodName = @"XM_Native2JS";

@implementation XMWebViewJSDefaultAssembler

+ (instancetype)defaultAssembler {
    return [[XMWebViewJSDefaultAssembler alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.jsMethodName = XMWebViewJSDefaultAssemblerJSMethodName;
    }
    return self;
}

- (NSString *)createJSStringWithJSMethod:(NSString *)jsMethodName parameters:(id)parameters {
    
    NSString *sendString = @"";
    
    if (jsMethodName.length < 0) {
        NSAssert(0, @"jsMethod 不能为空");
    }
    
    if (!jsMethodName) {
        return sendString;
    }
    
    if (!parameters) {
        parameters = @"";
    }
    
    if ([parameters isKindOfClass:[NSString class]]) {
        // 如果是字符串的话，看可不可以转为 字典
        NSData *parameData = [parameters dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:parameData options:0 error:&error];
        if (!error) {
            parameters = dict;
        }
    }
    
    NSDictionary *sendDictionary = @{
        @"name": jsMethodName,
        @"params": parameters
    };
    if ([NSJSONSerialization isValidJSONObject:sendDictionary]) {
        NSError *jsonDataError;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:sendDictionary options:0 error:&jsonDataError];
        if (jsonDataError ||
            nil == jsonData) {
            
        }
        sendString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSString *callString = [NSString stringWithFormat:@"%@('%@')", self.jsMethodName, sendString];
    return callString;
}

@end
