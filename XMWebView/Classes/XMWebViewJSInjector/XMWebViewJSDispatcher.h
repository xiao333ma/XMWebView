//
//  XMWebViewJSDispatcher.h
//  XMWebView
//
//  Created by xiaoma on 2019/6/10.
//  Copyright © 2019 xiaoma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@class XMWebView;

NS_ASSUME_NONNULL_BEGIN

/**
 JS 调用 Native，Native 进行分发处理
 */
@interface XMWebViewJSDispatcher : NSObject <WKScriptMessageHandler>

+ (instancetype)defaultJSDispatcherWithWebView:(XMWebView *)webView;

@end

NS_ASSUME_NONNULL_END
