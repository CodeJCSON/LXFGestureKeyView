//
//  LXFGestureKeyView.m
//  LXFGestureKeyViewDemo
//
//  Created by LXF on 2016/12/6.
//  Copyright © 2016年 林洵锋. All rights reserved.
//

#import "LXFGestureKeyView.h"

@interface LXFGestureKeyView()

/** 存放当前被选中的按钮数组 */
@property(nonatomic, strong) NSMutableArray *selectBtnArray;

/** 当前手指所在的点 */
@property(nonatomic, assign) CGPoint curPoint;

@end

@implementation LXFGestureKeyView
#pragma mark - 懒加载
- (NSMutableArray *)selectBtnArray {
    if (_selectBtnArray == nil) {
        _selectBtnArray = [NSMutableArray array];
    }
    return _selectBtnArray;
}

#pragma mark - 创建View
/** 从代码创建的view */
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}
/** 从xib或storyboard创建的view */
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

#pragma mark - 初始化
- (void)setup {
    for (int i = 0; i<9; i++) {
        // 创建按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = NO;
        
        // 绑定tag
        btn.tag = i + 1;
        
        // 设置按钮图片
        [btn setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        // 设置选中状态下的图片
        [btn setImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        
        [self addSubview:btn];
        
        // 设置默认背景色
        if (!self.backgroundColor) { self.backgroundColor = [UIColor clearColor]; }
    }
}

#pragma mark - 触摸事件
#pragma mark 手指开始点击调用
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 当前的手指所在的点在不在按钮上，如果在，让按钮成为选中状态
    // 1.获取当前手指所在的点
    CGPoint curPoint = [self getCurrentPoint:touches];
    
    // 2.判断curPoint在不在按钮身上
    // 取出所有的按钮进行判断
    UIButton *btn = [self btnRectContainsPoint:curPoint];
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        // 保存当前选中的按钮
        [self.selectBtnArray addObject:btn];
    }
}
#pragma mark 手指移动时调用
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint curPoint = [self getCurrentPoint:touches];
    // 记录当前手指所在的点
    self.curPoint = curPoint;
    UIButton *btn = [self btnRectContainsPoint:curPoint];
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        [self.selectBtnArray addObject:btn];
    }
    // 重绘
    [self setNeedsDisplay];
}

#pragma mark 手指离开时调用
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSMutableString *str = [NSMutableString string];
    
    // 1.取消所有选中的按钮
    for (UIButton *btn in self.selectBtnArray) {
        btn.selected = NO;
        [str appendFormat:@"%ld", btn.tag];
    }
    
    // 2.清空路径
    [self.selectBtnArray removeAllObjects];
    [self setNeedsDisplay];
    
    // 3.查看当前选中按钮的顺序
    NSLog(@"%@", str);
    if (self.delegate && [self.delegate respondsToSelector:@selector(lxf_currentKey:key:)]) {
        [self.delegate lxf_currentKey:self key:str];
    }
}

#pragma mark 获取当前手指所在的点
- (CGPoint)getCurrentPoint:(NSSet *)touches {
    UITouch *touch = [touches anyObject];
    return [touch locationInView:self];
}

#pragma mark 给定一个点，判断给定的点在不在按钮身上
// 如果在按钮身上，返回当前所在的按钮，如果不在，则返回nil
- (UIButton *)btnRectContainsPoint:(CGPoint)point {
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, point)) {
            return btn;
        }
    }
    return nil;
}

#pragma mark 画线
- (void)drawRect:(CGRect)rect {
    if (self.selectBtnArray.count == 0) {
        // 程序一开始进来没有开始点，所以直接调用[path addLineToPoint:self.curPoint]会报错
        return;
    }
    
    // 1.创建路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 2.取出所有保存的被选中的按钮
    for (int i = 0; i < self.selectBtnArray.count; i++) {
        // 取出每一个按钮
        UIButton *btn = self.selectBtnArray[i];
        // 判断当前按钮是不是第一个按钮
        if (i == 0) {
            // 如果是，设置成路径的起点
            [path moveToPoint:btn.center];
        } else {
            // 添加一根线到按钮的中心
            [path addLineToPoint:btn.center];
        }
    }
    
    // 添加一根线到当前手指所在的点
    [path addLineToPoint:self.curPoint];
    
    // 设置路径的状态
    [path setLineWidth:10];
    [[UIColor redColor] set];
    [path setLineJoinStyle:kCGLineJoinRound];   // 设置连接点样式
    
    // 3.绘制路径
    [path stroke];
}

#pragma mark - 布局按钮
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 取出每一个按钮，设置按钮的frame
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat btnWH = 74;
    
    // 总共有多少列
    int column = 3;
    // 间距
    CGFloat margin = (self.bounds.size.width - (btnWH * column)) / (column + 1);
    // 当前所在列
    int curCol = 0;
    // 当前所在行
    int curRow = 0;
    
    for (int i = 0; i < self.subviews.count; i++) {
        // 求当前所在列
        curCol = i % column;
        // 求当前所在行
        curRow = i / column;
        
        x = margin + (btnWH + margin) * curCol;
        y = margin + (btnWH + margin) * curRow;
        // 取出每一个按钮
        UIButton *btn = self.subviews[i];
        // 设置按钮的frame
        btn.frame = CGRectMake(x, y, btnWH, btnWH);
    }
}

@end
