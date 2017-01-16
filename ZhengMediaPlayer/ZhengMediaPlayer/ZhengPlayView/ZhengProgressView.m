//
//  ZhengProgressView.m
//  ZhengMediaPlayer
//
//  Created by 李保征 on 2016/12/20.
//  Copyright © 2016年 李保征. All rights reserved.
//

#import "ZhengProgressView.h"
#import "UIView+ZhengExtension.h"

#define ProgressViewH 3

#define IndicatorButtonW 20

#define IndicatorButtonH IndicatorButtonW

#define ZhengProgressViewH 20

#define ProgressViewAllDistance (self.bounds.size.width)

#define IndicatorButtonAllDistance (self.bounds.size.width - IndicatorButtonW)

@interface ZhengProgressView ()

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UIButton *indicatorButton;

@property (nonatomic,strong) UIView *bgProgressView;

@property (nonatomic,strong) UIView *progressView;

@end

@implementation ZhengProgressView

#pragma mark - getter

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        
        _bgView.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewTapGesture:)];
        
        [_bgView addGestureRecognizer:tapGesture];
    }
    return _bgView;
}

- (UIButton *)indicatorButton{
    if (!_indicatorButton) {
        _indicatorButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, IndicatorButtonW, IndicatorButtonH)];
        _indicatorButton.backgroundColor = [UIColor whiteColor];
        _indicatorButton.clipsToBounds = YES;
        _indicatorButton.layer.cornerRadius = _indicatorButton.bounds.size.height * 0.5;
        _indicatorButton.adjustsImageWhenHighlighted = NO;
        
        [_indicatorButton setImage:[UIImage imageNamed:@"indicator_btn1"] forState:UIControlStateNormal];
        
        [_indicatorButton addTarget:self action:@selector(indicatorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(indicatorButtonPanGesture:)];
        
        [_indicatorButton addGestureRecognizer:panGesture];
    }
    return _indicatorButton;
}

- (UIView *)bgProgressView{
    if (!_bgProgressView) {
        CGFloat bgProgressViewH = ProgressViewH;
        CGFloat bgProgressViewW = self.bounds.size.width;
        CGFloat bgProgressViewY = (self.bounds.size.height -bgProgressViewH) * 0.5;
        
        _bgProgressView = [[UIView alloc] initWithFrame:CGRectMake(0, bgProgressViewY, bgProgressViewW, bgProgressViewH)];
        _bgProgressView.backgroundColor = [UIColor orangeColor];
        _bgProgressView.userInteractionEnabled = NO;
    }
    return _bgProgressView;
}

- (UIView *)progressView{
    if (!_progressView) {
        CGFloat progressViewH = ProgressViewH;
        CGFloat progressViewY = (self.bounds.size.height - progressViewH) * 0.5;
        
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, progressViewY, 0, progressViewH)];
        _progressView.backgroundColor = [UIColor cyanColor];
        _progressView.userInteractionEnabled = NO;
    }
    return _progressView;
}

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.height = ZhengProgressViewH;
        self.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor lightGrayColor];
//        self.clipsToBounds = YES;
        
        [self addSubview:self.bgView];//响应点击手势
        [self addSubview:self.bgProgressView];
        [self addSubview:self.progressView];
        [self addSubview:self.indicatorButton];//响应滑动手势
    }
    return self;
}

#pragma mark - setter

- (void)setValue:(float)value{
    _value = value;
    if (value >= 0 && value <= 1) {
        
        self.indicatorButton.x = value * IndicatorButtonAllDistance;
        
        self.progressView.width = self.indicatorButton.x + IndicatorButtonW * 0.5;
    }
}

#pragma mark - Action

- (void)bgViewTapGesture:(UITapGestureRecognizer *)tapGesture{
    
    CGPoint point = [tapGesture locationInView:tapGesture.view];
    CGFloat progressValue = point.x / ProgressViewAllDistance;
    
    self.value = progressValue;
    
    if ([_delegate respondsToSelector:@selector(zhengProgressView:bgViewTapGesture:progressValue:)]) {
        [_delegate zhengProgressView:self bgViewTapGesture:tapGesture progressValue:progressValue];
    }
}

- (void)indicatorButtonPanGesture:(UIPanGestureRecognizer *)panGesture{
    
    // 获得挪动的距离
    CGPoint t = [panGesture translationInView:panGesture.view];
    [panGesture setTranslation:CGPointZero inView:panGesture.view];
    
    // 控制滑块和进度条的frame
    CGFloat sliderMaxX = IndicatorButtonAllDistance;
    
    self.indicatorButton.x += t.x;
    
    if (self.indicatorButton.x < 0) {
        self.indicatorButton.x = 0;
    }else if (self.indicatorButton.x > sliderMaxX) {
        self.indicatorButton.x = sliderMaxX;
    }
    
    CGFloat progressValue = self.indicatorButton.x / IndicatorButtonAllDistance;
    self.value = progressValue;
    
    if ([_delegate respondsToSelector:@selector(zhengProgressView:indicatorButtonPanGesture:progressValue:)]) {
        [_delegate zhengProgressView:self indicatorButtonPanGesture:panGesture progressValue:progressValue];
    }
}

- (void)indicatorButtonClick:(UIButton *)button{
    
}

@end
