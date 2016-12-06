//
//  ViewController.m
//  LXFGestureKeyViewDemo
//
//  Created by LXF on 2016/12/6.
//  Copyright © 2016年 林洵锋. All rights reserved.
//

#import "ViewController.h"
#import "LXFGestureKeyView.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width

@interface ViewController () <LXFGestureKeyViewDelegate>
@property (weak, nonatomic) IBOutlet LXFGestureKeyView *keyView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 代码创建
//    CGFloat wh = 300;
//    CGFloat x = (ScreenW - wh) * 0.5;
//    CGFloat y = 100;
//    
//    LXFGestureKeyView *keyView = [[LXFGestureKeyView alloc] initWithFrame:CGRectMake(x, y, wh, wh)];
//    keyView.delegate = self;
//    [self.view addSubview:keyView];
    
    // xib
    self.keyView.delegate = self;
}

- (void)lxf_currentKey:(LXFGestureKeyView *)keyView key:(NSString *)key {
    NSLog(@"%s -- %@", __func__, key);
}


@end
