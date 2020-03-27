//
//  XMWebViewJSDispatcher.m
//  XMWebView
//
//  Created by xiaoma on 2019/6/10.
//  Copyright © 2019 xiaoma. All rights reserved.
//

#import "XMWebViewJSDispatcher.h"
#import "XMWebViewJSDefaultJSParser.h"
#import "XMWebView.h"
#import "XMWebViewJSDefaultHandlerOperation.h"

@interface XMWebViewJSDispatcher ()

@property (nonatomic, weak  ) XMWebView *webView;              //!< webView
@property (nonatomic, strong) NSOperationQueue *handleJSQueue;  //!< 处理 JS 调用的队列
@property (nonatomic, strong) NSMutableArray *operations;       //!<

@end

@implementation XMWebViewJSDispatcher

+ (instancetype)defaultJSDispatcherWithWebView:(XMWebView *)webView {
    return [[XMWebViewJSDispatcher alloc] initWithWebView:webView];
}

- (instancetype)initWithWebView:(XMWebView *)webView {
    if (self = [super init]) {
        _webView = webView;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSDictionary *operationDict = [self.webView.jsBridgeConfig.jsParser parsingScriptMessage:message];
    if (operationDict) {
        NSString *className = [operationDict objectForKey:XMWebViewJSParserClassName];
        NSString *methodName = [operationDict objectForKey:XMWebViewJSParserMethodName];
        NSString *methodID = [operationDict objectForKey:XMWebViewJSParserMethodID];
        NSDictionary *parameters = [operationDict objectForKey:XMWebViewJSParserMethodParameters];
        
        Class cls = NSClassFromString(className);
        id operation = [[cls alloc] initWithWebView:self.webView methodName:methodName methodID:methodID parametes:parameters];
        if (operation) {
            if (self.webView.jsBridgeConfig.consoleLog) {
                NSLog(@"\n============call Native==============\nclassName:%@\nmethodName:%@\nmethodID:%@\nparameters:%@\n=====================================\n",className, methodName, methodID, parameters);
            }
            [self.operations addObject:operation];
            [self.handleJSQueue addOperation:operation];
        } else {
            if (self.webView.jsBridgeConfig.consoleLog) {
                NSLog(@"\n============call Native==============\nclassName:%@ 不存在\n=====================================\n",className);
                NSString *errorString = [NSString stringWithFormat:@"⚠️⚠️这个类: %@ 不存在", className];
                NSAssert(0, errorString);
            }
        }
    }
}

- (NSOperationQueue *)handleJSQueue {
    if (!_handleJSQueue) {
        _handleJSQueue = [NSOperationQueue mainQueue];
        _handleJSQueue.name = @"com.XMWebView.handleJSQueue";
        _handleJSQueue.maxConcurrentOperationCount = 1; // 串行执行
    }
    return _handleJSQueue;
}

- (void)dealloc {
    [_operations enumerateObjectsUsingBlock:^(NSOperation *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj cancel];
    }];
    [_operations removeAllObjects];
}

- (NSMutableArray *)operations {
    if (!_operations) {
        _operations = [[NSMutableArray alloc] init];
    }
    return _operations;
}

@end
