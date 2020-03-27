//
//  XMWebViewJSDefaultJSParser.m
//  XMWebView
//
//  Created by xiaoma on 2019/6/10.
//  Copyright © 2019 xiaoma. All rights reserved.
//

#import "XMWebViewJSDefaultJSParser.h"

NSString *const XMWebViewJSParserClassName = @"XMWebViewJSParserClassName";
NSString *const XMWebViewJSParserMethodName = @"XMWebViewJSParserMethodName";
NSString *const XMWebViewJSParserMethodParameters = @"XMWebViewJSParserMethodParameters";
NSString *const XMWebViewJSParserMethodID = @"XMWebViewJSParserMethodID";

NSString *const XMWebViewJSParserDefaultNativeHandlerClassPrefix = @"XMWebView";

@implementation XMWebViewJSDefaultJSParser

+ (instancetype)defaultJSParser {
    return [[XMWebViewJSDefaultJSParser alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.nativeHandlerClassPrefix = XMWebViewJSParserDefaultNativeHandlerClassPrefix;
    }
    return self;
}

- (NSDictionary *)parsingScriptMessage:(WKScriptMessage *)message {
    if (message.body) {
        NSString *methodName = [message.body objectForKey:@"name"];
        if (!methodName) {
            return nil;
        }
        NSDictionary *methodParameters = [message.body objectForKey:@"params"];
        NSString *firstStr = [methodName substringToIndex:1];
        firstStr = [firstStr uppercaseString];
        NSString *firstUpperMethodName = [methodName stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstStr];
        NSString *className = [NSString stringWithFormat:@"%@%@Handler", self.nativeHandlerClassPrefix, firstUpperMethodName];
        NSString *methodID = [message.body objectForKey:@"id"];
        
        return @{
            XMWebViewJSParserClassName: className,
            XMWebViewJSParserMethodName: methodName,
            XMWebViewJSParserMethodParameters: methodParameters ? : @{},
            XMWebViewJSParserMethodID: methodID ? : @""
        };
    } else {
        return nil;
    }
}

@end
