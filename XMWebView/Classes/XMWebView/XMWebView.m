//
//  XMWebView.m
//  XMWebView
//
//  Created by xiaoma on 2019/6/5.
//  Copyright © 2019 xiaoma. All rights reserved.
//

#import "XMWebView.h"
#import <Masonry/Masonry.h>
#import "XMWebViewJSInvoker.h"
#import "XMWebViewJSInjector.h"

@interface XMWebView () <WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong, readwrite) WKWebView *wkWebView;                                //!< webView
@property (nonatomic, strong, readwrite) WKWebViewConfiguration *webViewConfiguration;        //!< config
@property (nonatomic, strong, readwrite) XMWebViewJSBridgeConfig *jsBridgeConfig;            //!< bridgeConfig
@property (nonatomic, strong, readwrite) NSURLRequest *request;                                        //!< 请求

@end

@implementation XMWebView

- (instancetype)initWithJSBridgeConfig:(XMWebViewJSBridgeConfigBlock)jsBridgeConfigBlock webViewConfig:(XMWebViewConfigBlock)webViewConfigBlock {
    return [self initWithURL:@"" jsbridgeConfig:jsBridgeConfigBlock webViewConfig:webViewConfigBlock];
}

- (instancetype)initWithURL:(NSString *)urlString jsbridgeConfig:(nonnull XMWebViewJSBridgeConfigBlock)jsBridgeConfigBlock webViewConfig:(XMWebViewConfigBlock)webViewConfigBlock {
    return [self initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self fixURL:urlString]]] jsbridgeConfig:jsBridgeConfigBlock webViewConfig:webViewConfigBlock];
}

- (instancetype)initWithRequest:(NSURLRequest *)request jsbridgeConfig:(nonnull XMWebViewJSBridgeConfigBlock)jsBridgeConfigBlock webViewConfig:(XMWebViewConfigBlock)webViewConfigBlock {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        XMWEBVIEW_SAFE_BLOCK(webViewConfigBlock, self.webViewConfiguration);
        XMWEBVIEW_SAFE_BLOCK(jsBridgeConfigBlock, self.jsBridgeConfig);
        [self addSubViewAndLayout];
        [self loadRequest:request];
    }
    return self;
}

#pragma mark - Layout

- (void)addSubViewAndLayout {
    [self addSubview:self.wkWebView];
    [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - Helper

- (void)loadURL:(NSString *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self fixURL:url]]];
    [self loadRequest:request];
}
                             
- (void)loadRequest:(NSURLRequest *)request {
    if (!request || request.URL.absoluteString.length <= 0) {
        // 如果没有请求，或者 地址为 空，就不加载该请求
        return;
    }
    self.request = request;
    [self.wkWebView loadRequest:request];
}

- (NSString *)fixURL:(NSString *)url {
    // 去除多余的空格
    NSString *fixedURL = [url stringByReplacingOccurrencesOfString:@" " withString:@""];
    // 编码
    return [fixedURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

#pragma mark - Delegate

#pragma mark - Delegate

#pragma mark - Accessor

- (void)setDelegate:(id)delegate {
    _delegate = delegate;
    self.wkWebView.navigationDelegate = delegate;
    self.wkWebView.UIDelegate = delegate;
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:self.webViewConfiguration];
        _wkWebView.scrollView.bounces = NO;
        if (@available(iOS 11.0, *)) {
            _wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _wkWebView;
}

- (WKWebViewConfiguration *)webViewConfiguration {
    if (!_webViewConfiguration) {
        _webViewConfiguration = [[WKWebViewConfiguration alloc] init];
    }
    return _webViewConfiguration;
}

- (XMWebViewJSBridgeConfig *)jsBridgeConfig {
    if (!_jsBridgeConfig) {
        _jsBridgeConfig = [XMWebViewJSBridgeConfig defaultConfigWithWebView:self];
    }
    return _jsBridgeConfig;
}

@end
