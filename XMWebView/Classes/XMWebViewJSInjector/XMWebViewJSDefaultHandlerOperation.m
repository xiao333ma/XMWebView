//
//  XMWebViewJSDefaultHandlerOperation.m
//  XMWebView
//
//  Created by xiaoma on 2019/6/10.
//  Copyright © 2019 xiaoma. All rights reserved.
//

#import "XMWebViewJSDefaultHandlerOperation.h"

@interface XMWebViewJSDefaultHandlerOperation ()
{
    BOOL        executing;
    BOOL        finished;
    BOOL        cancelled;
}
@property (nonatomic, copy  , readwrite) NSString * methodName;                 //!< JS 传过来的参数
@property (nonatomic, strong, readwrite) NSDictionary *parameters;              //!< JS 传过来的参数
@property (nonatomic, copy, readwrite) NSString * methodID;                   //!< JS 传过来的参数
@property (nonatomic, weak  , readwrite) XMWebView *webView;                   //!< webView

@end

@implementation XMWebViewJSDefaultHandlerOperation

- (instancetype)initWithWebView:(XMWebView *)webView methodName:(NSString *)methodName methodID:(NSString * _Nonnull)methodID parametes:(NSDictionary * _Nullable)parameters {
    if (self = [super init]) {
        _methodName = methodName;
        _methodID = methodID;
        _parameters = parameters;
        _webView = webView;
    }
    return self;
}

- (void)start {
    if (!self.cancelled) {
        [self setOperationToExecutingState];
        [self handleBusiness];
    }
    [self setOperationToFinishState];
}

- (void)cancel {
    if (self.isFinished) {
        return;
    }
    [super cancel];
    [self setOperationToCancelState];
}

- (void)handleBusiness {
    
}

- (void)callJSBackWithParams:(NSDictionary *)params {
    if (!params) {
        return;
    }
    NSDictionary *dict = @{
        @"params": params,
        @"id": self.methodID,
    };
    NSString *str = [self.webView.jsBridgeConfig.jsCallBackAssembler createCallBackJSStringWithJSMethod:self.methodName parameters:dict];
    [self.webView.jsBridgeConfig.jsInvoker invokeJavaScript:str];
}

- (void)setOperationToExecutingState {
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    executing = YES;
    finished = NO;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setOperationToFinishState {
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    executing = NO;
    finished = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setOperationToCancelState {
    [self willChangeValueForKey:@"isCancelled"];
    cancelled = YES;
    [self didChangeValueForKey:@"isCancelled"];
}

- (BOOL)isExecuting {
    return executing;
}
 
- (BOOL)isFinished {
    return finished;
}

- (BOOL)isCancelled {
    return cancelled;
}

@end
