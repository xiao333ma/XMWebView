//
//  XMWebViewJSBridgeConfig.m
//  XMWebView
//
//  Created by xiaoma on 2019/6/6.
//  Copyright © 2019 xiaoma. All rights reserved.
//

#import "XMWebViewJSBridgeConfig.h"
#import "XMWebViewJSInvoker.h"
#import "XMWebViewJSDefaultAssembler.h"
#import "XMWebViewJSInjector.h"
#import "XMWebViewJSDefaultJSParser.h"
#import "XMWebViewJSDefaultCallBackAssembler.h"

@interface XMWebViewJSBridgeConfig ()

@property (nonatomic, weak  , readwrite) XMWebView *webView;                                          //!< webView
@property (nonatomic, strong, readwrite) XMWebViewJSInvoker *jsInvoker;                     //!< 调用 JS 提供的方法
@property (nonatomic, strong, readwrite) XMWebViewJSInjector *jsInjector;                   //!< 注射 💉 到 JS 中的 Native 方法，供 JS 调用

@end

@implementation XMWebViewJSBridgeConfig

+ (instancetype)defaultConfigWithWebView:(XMWebView *)webView {
    return [[XMWebViewJSBridgeConfig alloc] initWithWebView:webView];
}

- (instancetype)initWithWebView:(XMWebView *)webView {
    if (self = [super init]) {
        self.webView = webView;
        self.consoleLog = NO;
        _jsInvoker = [XMWebViewJSInvoker defaultInvokerWithWebView:self.webView];
    }
    return self;
}

- (id <XMWebViewJSAssemblerProtocol>)jsAssembler {
    if (!_jsAssembler) {
        _jsAssembler = [XMWebViewJSDefaultAssembler defaultAssembler];
    }
    return _jsAssembler;
}

- (XMWebViewJSInjector *)jsInjector {
    if (!_jsInjector) {
        _jsInjector = [XMWebViewJSInjector defaultInjectorWithWebView:self.webView];
    }
    return _jsInjector;
}

- (id <XMWebViewJSParserProtocol>)jsParser {
    if (!_jsParser) {
        _jsParser = [XMWebViewJSDefaultJSParser defaultJSParser];
    }
    return _jsParser;
}

- (id <XMWebViewJSCallBackAssemblerProtocol>)jsCallBackAssembler {
    if (!_jsCallBackAssembler) {
        _jsCallBackAssembler = [XMWebViewJSDefaultCallBackAssembler defaultCallBackAssembler];
    }
    return _jsCallBackAssembler;
}
@end
