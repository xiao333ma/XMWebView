//
//  XMWebViewTest1Handler.m
//  XMWebView_Example
//
//  Created by 马贞赛 on 3/27/20.
//  Copyright © 2020 xiao3333ma@gmail.com. All rights reserved.
//

#import "XMWebViewTest1Handler.h"

@implementation XMWebViewTest1Handler

- (void)handleBusiness {
    NSLog(@"param: %@", self.parameters);
    [self callJSBackWithParams:@{@"arg1": @"foo", @"arg2": @"bar"}];
}

@end
