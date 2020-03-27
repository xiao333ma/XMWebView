//
//  XMWebViewJSBridgeConfig.h
//  XMWebView
//
//  Created by xiaoma on 2019/6/6.
//  Copyright © 2019 xiaoma. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XMWebViewJSInvoker;
@class XMWebViewJSDefaultAssembler;
@class XMWebViewJSInjector;
@class XMWebViewJSDefaultJSParser, XMWebViewJSDefaultJSParserProtocol;
@class XMWebView;

@protocol XMWebViewJSAssemblerProtocol;
@protocol XMWebViewJSParserProtocol;
@protocol XMWebViewJSCallBackAssemblerProtocol;


NS_ASSUME_NONNULL_BEGIN

@interface XMWebViewJSBridgeConfig : NSObject

+ (instancetype)defaultConfigWithWebView:(XMWebView *)webView;

@property (nonatomic, weak  , readonly) XMWebView *webView;                                        //!< webView

// Native 调用 JS
@property (nonatomic, strong, readonly) XMWebViewJSInvoker *jsInvoker;                             //!< 调用 JS 提供的方法
@property (nonatomic, strong) id <XMWebViewJSAssemblerProtocol>jsAssembler;                        //!< 调用 JS 组装器

// JS 调用 Native
@property (nonatomic, strong, readonly) XMWebViewJSInjector *jsInjector;                           //!< 注射 💉 到 JS 中的 Native 方法，供 JS 调用
@property (nonatomic, strong) id <XMWebViewJSParserProtocol> jsParser;                             //!< JS 解析器，把 JS 调用 Native 的数据进行解析
@property (nonatomic, strong) id <XMWebViewJSCallBackAssemblerProtocol> jsCallBackAssembler;       //!< JS 调用 Native 后，Native 处理一些任务，然后回调给 JS 的组装器

@property (nonatomic, assign) BOOL consoleLog;     //!< 是否显示 JS 和 native 调用的 log 信息， 默认为 NO

@end

NS_ASSUME_NONNULL_END
