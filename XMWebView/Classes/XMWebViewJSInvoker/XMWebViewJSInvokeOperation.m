//
//  XMWebViewJSInvokeOperation.m
//  XMWebView
//
//  Created by xiaoma on 2019/6/6.
//  Copyright © 2019 xiaoma. All rights reserved.
//

#import "XMWebViewJSInvokeOperation.h"
#import "XMWebView.h"
#import "XMWebViewConst.h"

@interface XMWebViewJSInvokeOperation ()

@property (nonatomic, weak) XMWebView *webView;                        //!< webView
@property (nonatomic, copy) NSString *script;     //!< 要执行的 JS
@property (nonatomic, copy) XMWebViewJSCallHandlerBlock handler;       //!< 调用 JS 后，执行的回调

// 父类的状态机
@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@property (assign, nonatomic, getter = isFinished) BOOL finished;
@property (assign, nonatomic, getter = isAsynchronous) BOOL asynchronous;

@end

@implementation XMWebViewJSInvokeOperation

@synthesize executing = _executing;
@synthesize finished = _finished;
@synthesize asynchronous = _asynchronous;

- (instancetype)initWithWebVeiw:(XMWebView *)webView javaScript:(NSString *)script handler:(XMWebViewJSCallHandlerBlock _Nullable)handler {
    if (self = [super init]) {  
        self.webView = webView;
        self.script = script;
        self.handler = [handler copy];
        [self setup];
    }
    return self;
}

- (void)setup {
    self.asynchronous = NO;
    self.executing = NO;
    self.finished = NO;
}

- (void)start {

    @synchronized (self) {
        if (!self.script) {
            self.executing = NO;
            self.finished = YES;
        } else {
            if (self.isCancelled) {
                self.executing = NO;
                self.finished = YES;
                return;
            }
            self.executing = YES;
            self.finished = NO;
            __weak typeof(self)weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.webView.wkWebView evaluateJavaScript:self.script completionHandler:^(id _Nullable data, NSError * _Nullable error) {
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    if (strongSelf.webView.jsBridgeConfig.consoleLog) {
                        NSLog(@"\n============call js==============\ninvoke js   : %@\nreturn data : %@\nreturn error: %@\n=================================\n", strongSelf.script, data, error);
                    }
                    XMWEBVIEW_SAFE_BLOCK(strongSelf.handler, data, error);
                    
                    strongSelf.executing = NO;
                    strongSelf.finished = YES;
                }];
            });
        }
    }
}

#pragma mark - Accessor

- (void)cancel {
    [super cancel];
    self.executing = NO;
    self.finished = YES;
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setAsynchronous:(BOOL)asynchronous {
    [self willChangeValueForKey:@"asynchronous"];
    _asynchronous = asynchronous;
    [self didChangeValueForKey:@"asynchronous"];
}

- (BOOL)isConcurrent {
    return NO;
}

@end
