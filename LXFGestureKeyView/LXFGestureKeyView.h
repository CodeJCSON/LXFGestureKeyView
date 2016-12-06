//
//  LXFGestureKeyView.h
//  LXFGestureKeyViewDemo
//
//  Created by LXF on 2016/12/6.
//  Copyright © 2016年 林洵锋. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LXFGestureKeyView;

@protocol LXFGestureKeyViewDelegate <NSObject>

/** 获取当前key */
- (void)lxf_currentKey:(LXFGestureKeyView *)keyView key:(NSString *)key;

@end

@interface LXFGestureKeyView : UIView

/** 代理 */
@property(nonatomic, assign) id<LXFGestureKeyViewDelegate> delegate;

@end
