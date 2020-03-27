//
//  XMWebViewJSInvokeOperation.h
//  XMWebView
//
//  Created by xiaoma on 2019/6/6.
//  Copyright © 2019 xiaoma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMWebViewConst.h"

@class XMWebView;

NS_ASSUME_NONNULL_BEGIN

@interface XMWebViewJSInvokeOperation : NSOperation

- (instancetype)initWithWebVeiw:(XMWebView *)webView
                     javaScript:(NSString *)script
                        handler:(XMWebViewJSCallHandlerBlock _Nullable)handler;;

@end

NS_ASSUME_NONNULL_END
