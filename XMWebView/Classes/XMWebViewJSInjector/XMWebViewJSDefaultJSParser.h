//
//  XMWebViewJSDefaultJSParser.h
//  XMWebView
//
//  Created by xiaoma on 2019/6/10.
//  Copyright © 2019 xiaoma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *const XMWebViewJSParserClassName; //!< JS 调用本地所反射的类名
UIKIT_EXTERN NSString *const XMWebViewJSParserMethodName; //!< JS 调用本地的方法名，通过这个方法名，反射出类名，在回调给 JS 的时候，该名称也是 JS 绑定到 window 下边一个对象上的方法
UIKIT_EXTERN NSString *const XMWebViewJSParserMethodParameters; //!< JS 调用本地所传的 参数
UIKIT_EXTERN NSString *const XMWebViewJSParserMethodID; //!< JS 调用本地传过来的方法 ID


@protocol XMWebViewJSParserProtocol <NSObject>

@required

/**
 类前缀，将会根据这个前缀进行拼接，构造一个 nativeHandlerClassPrefixMethodHandler
 */
@property (nonatomic, copy) NSString *nativeHandlerClassPrefix;

/**
 解析 JS 调用 Native 传过来的数据

 @param message JS 调用 Native 传过来的数据
 @return 一个字典，包含以下内容
 @{
     XMWebViewJSParserClassName: ClassName,
     XMWebViewJSParserMethodName: MethodName,
     XMWebViewJSParserMethodName: MethodParameters
 }
 */
- (NSDictionary *)parsingScriptMessage:(WKScriptMessage *)message;

@end

/**
 默认 JS 解析器，JS 调用 Native，Native 解析 JS
 
 该解析器解析如下数据结构
 message.body = @{
    name: foo
    params: @{
        foo1: bar1,
        foo2: bar2,
    }
 }
 
 之后将根据前缀，拼接成一个类，XMWebViewFooHandler。
 */
@interface XMWebViewJSDefaultJSParser : NSObject <XMWebViewJSParserProtocol>

/**
 默认为 XMWebView
 */
@property (nonatomic, copy) NSString *nativeHandlerClassPrefix;

+ (instancetype)defaultJSParser;

@end

NS_ASSUME_NONNULL_END
