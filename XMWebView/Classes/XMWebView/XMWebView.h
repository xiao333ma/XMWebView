//
//  XMWebView.h
//  XMWebView
//
//  Created by xiaoma on 2019/6/5.
//  Copyright © 2019 xiaoma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "XMWebViewJSBridgeConfig.h"
#import "XMWebViewConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMWebView : UIView

@property (nonatomic, strong, readonly) NSURLRequest *request;                                        //!< 请求
@property (nonatomic, strong, readonly) WKWebView *wkWebView;                               //!< webView
@property (nonatomic, strong, readonly) XMWebViewJSBridgeConfig *jsBridgeConfig;           //!< bridge config
@property (nonatomic, weak) id delegate;                                                  //!< 代理


/// 初始化一个 webView
/// @param jsBridgeConfigBlock JSBridge 的配置
/// @param webViewConfigBlock  wkWebViewConfig 的配置
- (instancetype)initWithJSBridgeConfig:(XMWebViewJSBridgeConfigBlock)jsBridgeConfigBlock webViewConfig:(XMWebViewConfigBlock)webViewConfigBlock;

/// 初始化一个 webView
/// @param urlString 加载 webView 的 url
/// @param jsBridgeConfigBlock JSBridge 的配置
/// @param webViewConfigBlock  wkWebViewConfig 的配置
- (instancetype)initWithURL:(NSString *)urlString jsbridgeConfig:(XMWebViewJSBridgeConfigBlock)jsBridgeConfigBlock webViewConfig:(XMWebViewConfigBlock)webViewConfigBlock;

/// 初始化一个 webView
/// @param request 加载 webView 的 request
/// @param jsBridgeConfigBlock JSBridge 的配置
/// @param webViewConfigBlock  wkWebViewConfig 的配置
- (instancetype)initWithRequest:(NSURLRequest *)request jsbridgeConfig:(XMWebViewJSBridgeConfigBlock)jsBridgeConfigBlock webViewConfig:(XMWebViewConfigBlock)webViewConfigBlock;

/**
 加载一个 URL

 @param url 要加载的 URL
 */
- (void)loadURL:(NSString *)url;

/**
 加载一个 request

 @param request 要加载的 request
 */
- (void)loadRequest:(NSURLRequest *)request;

@end

NS_ASSUME_NONNULL_END
