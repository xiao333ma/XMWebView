//
//  XMWebViewConst.h
//  XMWebView
//
//  Created by xiaoma on 2019/6/6.
//  Copyright © 2019 xiaoma. All rights reserved.
//

#ifndef XMWebViewConst_h
#define XMWebViewConst_h

@class XMWebViewJSBridgeConfig;
@class WKWebViewConfiguration;

#define XMWEBVIEW_SAFE_BLOCK(BlockName, ...) ({ !BlockName ? nil : BlockName(__VA_ARGS__); })

typedef void(^XMWebViewJSCallHandlerBlock)(id _Nullable data, NSError *_Nullable err);

typedef void(^XMWebViewJSBridgeConfigBlock)(XMWebViewJSBridgeConfig * _Nonnull config);

typedef void(^XMWebViewConfigBlock)(WKWebViewConfiguration * _Nonnull config);

#endif /* XMWebViewConst_h */
