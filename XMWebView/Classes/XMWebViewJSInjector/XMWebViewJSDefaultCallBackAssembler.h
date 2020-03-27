//
//  XMWebViewJSCallBackAssembler.h
//  XMWebView
//
//  Created by xiaoma on 2019/6/10.
//  Copyright © 2019 xiaoma. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XMWebViewJSCallBackAssemblerProtocol <NSObject>

@required

/**
 js 回调 方法前缀
 */
@property (nonatomic, copy) NSString * _Nonnull jsCallBackMethodName;

- (NSString *_Nonnull)createCallBackJSStringWithJSMethod:(NSString *_Nonnull)jsMethodName parameters:(id _Nullable )parameters;

@end

NS_ASSUME_NONNULL_BEGIN

/**
 默认回调给 JS 的组装器
 */
@interface XMWebViewJSDefaultCallBackAssembler : NSObject <XMWebViewJSCallBackAssemblerProtocol>

@property (nonatomic, copy) NSString *jsCallBackMethodName;

+ (instancetype)defaultCallBackAssembler;

@end

NS_ASSUME_NONNULL_END
