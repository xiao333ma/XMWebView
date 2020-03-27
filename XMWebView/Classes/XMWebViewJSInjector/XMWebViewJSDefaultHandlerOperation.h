//
//  XMWebViewJSDefaultHandlerOperation.h
//  XMWebView
//
//  Created by xiaoma on 2019/6/10.
//  Copyright © 2019 xiaoma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMWebView.h"
#import "XMWebViewJSBridgeConfig.h"
#import "XMWebViewJSDefaultCallBackAssembler.h"
#import "XMWebViewJSInvoker.h"

@protocol XMWebViewJSDefaultHandlerProtocol <NSObject>

- (instancetype _Nonnull )initWithWebView:(XMWebView *_Nonnull)webView methodName:(NSString *_Nonnull)methodName methodID:(NSString *_Nonnull)methodID parametes:(NSDictionary *_Nullable)parameters;

@property (nonatomic, copy  , readonly) NSString * _Nonnull methodName;          //!< JS 传过来的参数
@property (nonatomic, copy  , readonly) NSString * _Nonnull methodID;     //!< JS 传过来的参数
@property (nonatomic, strong, readonly) NSDictionary * _Nullable parameters;     //!< JS 传过来的参数
@property (nonatomic, weak  , readonly) XMWebView * webView;           //!< webView

@end

NS_ASSUME_NONNULL_BEGIN

/**
 JS 调用 Native 处理类，此类为 基类，只是保存一些变量，不做任何操作。
 处理业务，需要定义自己的业务处理类，然后实现 main 函数
 如果外部继承这个类，只需要实现 main 函数即可，main 函数在结束的时候，会自动吧 operation 的状态置为 结束，不管同步还是异步
 */
@interface XMWebViewJSDefaultHandlerOperation : NSOperation <XMWebViewJSDefaultHandlerProtocol>

@property (nonatomic, copy  , readonly) NSString * methodName;                  //!< JS 传过来的参数
@property (nonatomic, copy  , readonly) NSString * methodID;     //!< JS 传过来的参数
@property (nonatomic, strong, readonly) NSDictionary *parameters;               //!< JS 传过来的参数
@property (nonatomic, weak  , readonly) XMWebView *webView;                    //!< webView

/// 子类不需要重写该方法
- (void)start NS_UNAVAILABLE;

/// 子类不需要重写该方法
- (void)main NS_UNAVAILABLE;

/// 子类重写该方法来处理业务逻辑，不需要处理各种状态的变更
- (void)handleBusiness;

/// 子类调用此方法来回调 JS
- (void)callJSBackWithParams:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
