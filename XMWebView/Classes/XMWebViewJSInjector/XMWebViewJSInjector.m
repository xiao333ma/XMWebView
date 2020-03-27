//
//  XMWebViewJSInjector.m
//  XMWebView
//
//  Created by xiaoma on 2019/6/6.
//  Copyright © 2019 xiaoma. All rights reserved.
//

#import "XMWebViewJSInjector.h"
#import "XMWebViewJSDispatcher.h"
#import "XMWebView.h"
#import "XMWebViewJSInvoker.h"
#import "XMWebViewJSDefaultCallBackAssembler.h"

@interface XMWebViewJSInjector ()

@property (nonatomic, weak  ) XMWebView *webView;     //!< webView
@property (nonatomic, strong) XMWebViewJSDispatcher *dispatcher;     //!< 分发器，分发到对应的方法
@property (nonatomic, strong) NSMutableArray *methodNameArray;     //!< 方法名称

@end

@implementation XMWebViewJSInjector

+ (instancetype)defaultInjectorWithWebView:(XMWebView *)webView {
    return [[XMWebViewJSInjector alloc] initWithWebView:webView];
}

- (instancetype)initWithWebView:(XMWebView *)webView {
    if (self = [super init]) {
        _webView = webView;
    }
    return self;
}

- (void)injectJSCallNativeMethodName:(NSString *)methodName {
    
    NSArray *array = [methodName componentsSeparatedByString:@"_"];
    if (array.count <= 1) {
        NSAssert(0, @"注册的方法名必须以 _ 分割");
        return;
    }
    NSBundle *boundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[XMWebViewJSInjector class]] pathForResource:@"XMWebView" ofType:@"bundle"]];
    NSString *path = [boundle pathForResource:@"inject" ofType:@"js"];
    NSString *jsString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    jsString = [jsString stringByReplacingOccurrencesOfString:@"__message_queue_prefix__" withString:[methodName componentsSeparatedByString:@"_"][0]];
    jsString = [jsString stringByReplacingOccurrencesOfString:@"__inject_func_name__" withString:methodName];
    jsString = [jsString stringByReplacingOccurrencesOfString:@"__native_callback_name__" withString:self.webView.jsBridgeConfig.jsCallBackAssembler.jsCallBackMethodName];
    [self injectJavaScript:jsString];
    [self injectJSCallNativeMessageHandler:methodName];
}

- (void)injectJSCallNativeMessageHandler:(NSString *)messageHandlerName {
    [self.methodNameArray addObject:messageHandlerName];
    [self.webView.wkWebView.configuration.userContentController addScriptMessageHandler:self.dispatcher name:messageHandlerName];
}

- (void)injectJavaScript:(NSString *)script {
    WKUserScript *us = [[WKUserScript alloc] initWithSource:script injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [self.webView.wkWebView.configuration.userContentController addUserScript:us];
}

- (void)remove {
    for (NSString *name in self.methodNameArray) {
        [self.webView.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:name];
    }
}

- (XMWebViewJSDispatcher *)dispatcher {
    if (!_dispatcher) {
        _dispatcher = [XMWebViewJSDispatcher defaultJSDispatcherWithWebView:self.webView];
    }
    return _dispatcher;
}

- (NSMutableArray *)methodNameArray {
    if (!_methodNameArray) {
        _methodNameArray = [[NSMutableArray alloc] init];
    }
    return _methodNameArray;
}

@end
