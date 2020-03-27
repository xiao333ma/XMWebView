//
//  XMWebViewJSInvoker.m
//  XMWebView
//
//  Created by xiaoma on 2019/6/5.
//  Copyright © 2019 xiaoma. All rights reserved.
//

#import "XMWebViewJSInvoker.h"
#import "XMWebViewJSInvokeOperation.h"
#import "XMWebViewJSBridgeConfig.h"
#import "XMWebViewJSDefaultAssembler.h"
#import "XMWebView.h"


@interface XMWebViewJSInvoker ()

@property (nonatomic, unsafe_unretained) XMWebView *webView;                   //!< webView
@property (nonatomic, strong) NSOperationQueue *invokJSQueueWithLoadingState;   //!< 执行 JS 的 queue，只有当网页加载完成的时候，该队列中的 operation 才会被执行
@property (nonatomic, strong) NSOperationQueue *invokJSQueueIgnoreLoadingState;                   //!< 执行 JS 的 queue，不管网页有没有加载完成，放入直接执行

@end

@implementation XMWebViewJSInvoker

+ (instancetype)defaultInvokerWithWebView:(XMWebView *)webView {
    return [[XMWebViewJSInvoker alloc] initWithWebView:webView];
}

- (instancetype)initWithWebView:(XMWebView *)webView {
    if (self = [super init]) {
        self.webView = webView;
        [self setup];
    }
    return self;
}

- (void)setup {
    [self.webView.wkWebView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    BOOL old = [[change objectForKey:NSKeyValueChangeOldKey] boolValue];
    BOOL new = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
    
    /*
     当第一次打开一个页面的时候 loading 变化如下
     old  new
     0    1
     1    0
     只有 loading 从 1 -> 0 才是从 加载中 -> 加载完成，所以，要跳过第一次的 kvo
     
     后续在打开页面 loading 变化如下
     old  new
     0    1
     1    0
     */
    
    if (old && !new) {
        // old 的 loding 是 YES，new 的 loading 是 NO，就是从 加载中 -> 加载完成
        self.invokJSQueueWithLoadingState.suspended = NO;
    } else if (!old && new) {
        // old 的 loding 是 NO，new 的 loading 是 YES，就是从 加载完成 -> 加载中 (又打开了新的页面)
        self.invokJSQueueWithLoadingState.suspended = YES;
    }
}

- (void)invokeJSMethodWithMethodName:(NSString *)methodName parameters:(id)parameters {
    [self invokeJSMethodWithMethodName:methodName parameters:parameters ignoreWebViewLoadingState:NO];
}

- (void)invokeJSMethodWithMethodName:(NSString *)methodName parameters:(id)parameters ignoreWebViewLoadingState:(BOOL)ignore {
    [self invokeJSMethodWithMethodName:methodName parameters:parameters ignoreWebViewLoadingState:ignore handler:nil];
}

- (void)invokeJSMethodWithMethodName:(NSString *)methodName
                          parameters:(id)parameters
                             handler:(XMWebViewJSCallHandlerBlock _Nullable)handler {
    
    [self invokeJSMethodWithMethodName:methodName parameters:parameters ignoreWebViewLoadingState:NO handler:handler];
}

- (void)invokeJSMethodWithMethodName:(NSString *)methodName
                          parameters:(id)parameters
           ignoreWebViewLoadingState:(BOOL)ignore
                             handler:(XMWebViewJSCallHandlerBlock _Nullable)handler {
    NSString *script = [self.webView.jsBridgeConfig.jsAssembler createJSStringWithJSMethod:methodName parameters:parameters];
    [self invokeJavaScript:script ignoreWebViewLoadingState:ignore handler:handler];
}

- (void)invokeJavaScript:(NSString *)script {
    [self invokeJavaScript:script ignoreWebViewLoadingState:NO];
}

- (void)invokeJavaScript:(NSString *)script ignoreWebViewLoadingState:(BOOL)ignore {
    [self invokeJavaScript:script ignoreWebViewLoadingState:ignore handler:nil];
}

- (void)invokeJavaScript:(NSString *)script handler:(XMWebViewJSCallHandlerBlock)handler {
    [self invokeJavaScript:script ignoreWebViewLoadingState:NO handler:handler];
}

- (void)invokeJavaScript:(NSString *)script ignoreWebViewLoadingState:(BOOL)ignore handler:(XMWebViewJSCallHandlerBlock _Nullable)handler {
    XMWebViewJSInvokeOperation *operation = [[XMWebViewJSInvokeOperation alloc] initWithWebVeiw:self.webView javaScript:script handler:handler];
    if (ignore) { // 忽略加载状态
        [self.invokJSQueueIgnoreLoadingState addOperation:operation];
    } else {
        [self.invokJSQueueWithLoadingState addOperation:operation];
    }
}

- (NSOperationQueue *)invokJSQueueWithLoadingState {
    if (!_invokJSQueueWithLoadingState) {
        _invokJSQueueWithLoadingState = [[NSOperationQueue alloc] init];
        _invokJSQueueWithLoadingState.name = @"com.XMWebView.invokJSQueueWithLoadingState";
        _invokJSQueueWithLoadingState.maxConcurrentOperationCount = 1; // 串行执行 JS
        _invokJSQueueWithLoadingState.suspended = YES;
    }
    return _invokJSQueueWithLoadingState;
}

- (NSOperationQueue *)invokJSQueueIgnoreLoadingState{
    if (!_invokJSQueueIgnoreLoadingState) {
        _invokJSQueueIgnoreLoadingState = [[NSOperationQueue alloc] init];
        _invokJSQueueIgnoreLoadingState.name = @"com.XMWebView.invokJSQueueIgnoreLoadingState";
        _invokJSQueueIgnoreLoadingState.maxConcurrentOperationCount = 1; // 串行执行 JS
    }
    return _invokJSQueueIgnoreLoadingState;
}



- (void)dealloc
{
    [self.webView.wkWebView removeObserver:self forKeyPath:@"loading"];
    [self.invokJSQueueWithLoadingState cancelAllOperations];
    [self.invokJSQueueIgnoreLoadingState cancelAllOperations];

}


@end
