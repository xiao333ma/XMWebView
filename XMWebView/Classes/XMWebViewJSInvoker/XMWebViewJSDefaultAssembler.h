//
//  XMWebViewJSDefaultAssembler.h
//  XMWebView
//
//  Created by xiaoma on 2019/6/6.
//  Copyright © 2019 xiaoma. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 组装器协议， JSInvoker 会调用这个协议来组装对应的 JS 字符串
 */
@protocol XMWebViewJSAssemblerProtocol <NSObject>

/**
 方法名前缀。
 统一调用挂载在 window 下的 JS 方法名称
 */
@property (nonatomic, copy  ) NSString *jsMethodName;

/**
 根据 方法名 和 参数，组装成一个特定的 JS 字符串

 @param jsMethodName 方法名
 @param parameters 参数
 @return 一个组装好的字符串，供 JS 调用
 */
- (NSString *_Nonnull)createJSStringWithJSMethod:(NSString *_Nonnull)jsMethodName parameters:(id _Nullable )parameters;

@end

/**
 默认的组装器，
 将 JS 组装成一个字符串，字符串结构，
 XM_Native2Js({name: methodName, params:{key1: value1}})，
 该组装器把所有的 JS 调用，组装成一个统一的方法，由 JS 进行分发。
 其他类只需要实现 组装器协议 就可以实现自己的组装器。
 */
@interface XMWebViewJSDefaultAssembler : NSObject <XMWebViewJSAssemblerProtocol>
// 默认前缀为 XM_Native2JS
@property (nonatomic, copy  ) NSString *jsMethodName;     

+ (instancetype)defaultAssembler;

@end

NS_ASSUME_NONNULL_END
