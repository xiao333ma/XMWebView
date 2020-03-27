//
//  XMWebViewJSInjector.h
//  XMWebView
//
//  Created by xiaoma on 2019/6/6.
//  Copyright © 2019 xiaoma. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XMWebView;

NS_ASSUME_NONNULL_BEGIN

/**
 JS 方法注射器，注射 Native 方法到 JS 中，供 JS 调用
 推荐调用一个公用的方法，由这个方法统一分发
 */
@interface XMWebViewJSInjector : NSObject

+ (instancetype)defaultInjectorWithWebView:(XMWebView *)webView;

/// 注入 JS 调用 Native 的方法 JS 将根据这个方法名来调用到 native，改方法将调用下边 -injectJSCallNativeMessageHandler: 方法来默认注入一个 messageHandler
/// @param methodName 方法名，
- (void)injectJSCallNativeMethodName:(NSString *)methodName;

/// 注入 JS 调用 Native 的 handler，js 可以通过 window.webkit.messageHandlers.messageHandlerName.postMessage() 来调用到 native
/// @param messageHandlerName handler 名称
- (void)injectJSCallNativeMessageHandler:(NSString *)messageHandlerName;

- (void)injectJavaScript:(NSString *)script;

- (void)remove;

@end

NS_ASSUME_NONNULL_END
