//
//  XMWebViewJSInvoker.h
//  XMWebView
//
//  Created by xiaoma on 2019/6/5.
//  Copyright © 2019 xiaoma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMWebViewConst.h"

@class XMWebView;

NS_ASSUME_NONNULL_BEGIN

/**
 JS 方法调用器，用来调用 JS 提供给 Native 的方法
 */
@interface XMWebViewJSInvoker : NSObject

/**
 返回一个默认的 JS 方法调用器

 @param webView webView
 @return 默认的方法调用器
 */
+ (instancetype)defaultInvokerWithWebView:(XMWebView *)webView;

/**
 执行 JS，当 网页加载 完成的时候

 @param script 要执行的 JS
 */
- (void)invokeJavaScript:(NSString *)script;

/**
 执行 JS 当 网页加载 完成的时候

 @param script 要执行的 JS
 
 @param handler JS 执行完的返回值
 */
- (void)invokeJavaScript:(NSString *)script handler:(_Nullable XMWebViewJSCallHandlerBlock)handler;

/**
 根据方法名，和参数，用 组装器 组装为一个 JS 语句，最终调用 JS， 当 网页加载 完成的时候

 @param methodName JS 方法名
 @param parameters JS 方法参数
 */
- (void)invokeJSMethodWithMethodName:(NSString *)methodName
                          parameters:(id)parameters;

/**
 根据方法名，和参数，用 组装器 组装为一个 JS 语句，最终调用 JS， 当 网页加载 完成的时候

 @param methodName JS 方法名
 @param parameters JS 方法参数
 @param handler JS 执行完的返回值
 */
- (void)invokeJSMethodWithMethodName:(NSString *)methodName
                          parameters:(id)parameters
                             handler:(_Nullable XMWebViewJSCallHandlerBlock)handler;

/**
 执行 JS

 @param script 要执行的 JS
 @param ignore 是否忽略网页加载状态，YES 当网页未加载完成也可以执行 JS，NO 只能在网页加载完才能执行 JS
 */
- (void)invokeJavaScript:(NSString *)script ignoreWebViewLoadingState:(BOOL)ignore;

/**
 执行 JS 当 网页加载 完成的时候

 @param script 要执行的 JS
 @param ignore 是否忽略网页加载状态，YES 当网页未加载完成也可以执行 JS，NO 只能在网页加载完才能执行 JS
 @param handler JS 执行完的返回值
 */
- (void)invokeJavaScript:(NSString *)script ignoreWebViewLoadingState:(BOOL)ignore handler:(_Nullable XMWebViewJSCallHandlerBlock)handler;

/**
 根据方法名，和参数，用 组装器 组装为一个 JS 语句，最终调用 JS， 当 网页加载 完成的时候

 @param methodName JS 方法名
 @param parameters JS 方法参数
 @param ignore 是否忽略网页加载状态，YES 当网页未加载完成也可以执行 JS，NO 只能在网页加载完才能执行 JS
 */
- (void)invokeJSMethodWithMethodName:(NSString *)methodName
                          parameters:(id)parameters
           ignoreWebViewLoadingState:(BOOL)ignore;

/**
 根据方法名，和参数，用 组装器 组装为一个 JS 语句，最终调用 JS， 当 网页加载 完成的时候

 @param methodName JS 方法名
 @param parameters JS 方法参数
 @param ignore 是否忽略网页加载状态，YES 当网页未加载完成也可以执行 JS，NO 只能在网页加载完才能执行 JS
 @param handler JS 执行完的返回值
 */
- (void)invokeJSMethodWithMethodName:(NSString *)methodName
                          parameters:(id)parameters
           ignoreWebViewLoadingState:(BOOL)ignore
                             handler:(_Nullable XMWebViewJSCallHandlerBlock)handler;

@end

NS_ASSUME_NONNULL_END
