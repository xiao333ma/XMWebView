//
//  XMViewController.m
//  XMWebView
//
//  Created by xiao3333ma@gmail.com on 03/27/2020.
//  Copyright (c) 2020 xiao3333ma@gmail.com. All rights reserved.
//

#import "XMViewController.h"
#import <Masonry/Masonry.h>
#import "XMTest1ViewController.h"

@interface XMViewController ()

@property (nonatomic, strong) UIButton *btn;     //!<

@end

@implementation XMViewController

- (void)viewDidLoad {
    self.title = @"首页";
    [super viewDidLoad];
    [self.view addSubview:self.btn];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@200);
        make.height.equalTo(@100);
    }];
}

- (void)click {
    [self.navigationController pushViewController:XMTest1ViewController.new animated:YES];
}

- (UIButton *)btn{
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        [_btn setTitle:@"下一个页面" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    return _btn;
}

@end
