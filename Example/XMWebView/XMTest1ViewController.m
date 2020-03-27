//
//  XMTest1ViewController.m
//  XMWebView_Example
//
//  Created by 马贞赛 on 3/27/20.
//  Copyright © 2020 xiao3333ma@gmail.com. All rights reserved.
//

#import "XMTest1ViewController.h"
#import "XMWebView.h"
#import "XMWebViewJSInjector.h"
#import "XMWebViewJSInvoker.h"
#import "XMWebViewJSDefaultCallBackAssembler.h"
#import "XMWebViewJSDefaultAssembler.h"
#import <Masonry/Masonry.h>

@interface XMTest1ViewController ()

@property (nonatomic, strong) XMWebView *webView;
@property (nonatomic, strong) UIButton *btn;     //!<

@end

@implementation XMTest1ViewController

- (void)dealloc {
    NSLog(@"ViewController dealloc");
}

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.btn];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-200);
    }];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.webView.mas_bottom).offset(30);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
    }];
    
    [self.webView loadURL:@"http://127.0.0.1/~mazhensai/www/h5_test/wkwebview_test.html"];
}

- (void)callJS {
    
    NSDictionary *dict = @{
        @"arg1": @"value1",
        @"arg2": @"value2",
        @"jsonString": @{
                @"foo": @"bar"
        }
    };
    
    [self.webView.jsBridgeConfig.jsInvoker invokeJSMethodWithMethodName:@"xiaoma1" parameters:dict handler:^(id  _Nullable data, NSError * _Nonnull error) {
        NSLog(@"%@", data);
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.webView.jsBridgeConfig.jsInjector remove];
}

- (XMWebView *)webView {
    if (!_webView) {
        _webView = [[XMWebView alloc] initWithJSBridgeConfig:^(XMWebViewJSBridgeConfig * _Nonnull config) {
            config.consoleLog = YES;
        } webViewConfig:^(WKWebViewConfiguration * _Nonnull config) {
            
        }];
        [_webView.jsBridgeConfig.jsInjector injectJSCallNativeMethodName:@"XM_JS2Native"];
    }
    return _webView;
}

- (UIButton *)btn{
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn addTarget:self action:@selector(callJS) forControlEvents:UIControlEventTouchUpInside];
        [_btn setTitle:@"调用 JS" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    return _btn;
}

@end
