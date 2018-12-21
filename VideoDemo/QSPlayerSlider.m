//
//  QSPlayerSlider.m
//  VideoDemo
//
//  Created by Qson on 2018/12/14.
//  Copyright © 2018 Qson. All rights reserved.
//

#import "QSPlayerSlider.h"


@implementation QSPlayerPoint
- (instancetype)init {
    self = [super init];
    
    self.holder = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];

    UIView *inter = [[UIView alloc] initWithFrame:CGRectMake(14, 14, 2, 2)];
    inter.backgroundColor = [UIColor whiteColor];
    [self.holder addSubview:inter];
    self.holder.userInteractionEnabled = YES;
    
    return self;
}
@end

@interface QSPlayerSlider ()

@property (nonatomic) UIImageView *tracker;
@end

@implementation QSPlayerSlider

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self initUI];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self initUI];
    return self;
}

- (void)initUI {
    _progressView                   = [[QSProgressView alloc] initWithFrame:CGRectZero progressViewStyle:(QSProgressViewStyleTrackFillet)];
    _progressView.progressTintColor = [UIColor whiteColor];
    _progressView.trackTintColor    = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    _progressView.cacheTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    _progressView.userInteractionEnabled = NO;
    [self addSubview:_progressView];
    
    self.pointArray = [NSMutableArray new];
    _sliderHeight = kIPadSuitFloat(5);

    [self sendSubviewToBack:self.progressView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    self.tracker = self.subviews.lastObject;

//    [self bringSubviewToFront:self.tracker];
    
//    _progressView.x = self.tracker.w * 0.5;
    _progressView.x = 0;
    _progressView.w = self.w - _progressView.x;
    _progressView.h = _sliderHeight;
    _progressView.y = (self.h - _progressView.h) *0.5;
    self.tracker.center_y = self.progressView.center_y;
}

#pragma mark - 外部方法
//- (void)setValue:(float)value {
//    _value = value;
//
//    _progressView.progress = value;
//    self.tracker.x = _progressView.w * MIN(value, 1);
//}

- (void)setProgress:(float)progress {
    _progress = progress;
    
    _progressView.progress = progress;
    self.tracker.x = _progressView.w * MIN(progress, 1);
}

- (QSPlayerPoint *)addPoint:(GLfloat)where
{
    for (QSPlayerPoint *pp in self.pointArray) {
        if (fabsf(pp.where - where) < 0.0001)
            return pp;
    }
    QSPlayerPoint *point = [QSPlayerPoint new];
    point.where = where;
    point.holder.center = [self holderCenter:where];
    point.holder.hidden = _hiddenPoints;
    [self.pointArray addObject:point];
    [point.holder addTarget:self action:@selector(onClickHolder:) forControlEvents:UIControlEventTouchUpInside];
    [self setNeedsLayout];
    return point;
}

- (void)setSliderHeight:(float)sliderHeight {
    _sliderHeight = sliderHeight;
    
    self.progressView.layer.cornerRadius = sliderHeight * 0.5;
}

#pragma mark - 内部实现
- (CGPoint)holderCenter:(GLfloat)where {
    return CGPointMake((self.frame.size.width - _progressView.x) * where, self.progressView.center_y);
}

- (void)onClickHolder:(UIControl *)sender {
    NSLog(@"clokc");
    for (QSPlayerPoint *point in self.pointArray) {
        if (point.holder == sender) {
            if ([self.delegate respondsToSelector:@selector(onPlayerPointSelected:)])
                [self.delegate onPlayerPointSelected:point];
        }
    }
}

- (void)setHiddenPoints:(BOOL)hiddenPoints {
    for (QSPlayerPoint *point in self.pointArray) {
        point.holder.hidden = hiddenPoints;
    }
    _hiddenPoints = hiddenPoints;
}

#pragma mark - 懒加载
////!< 可以改变高度
//- (CGRect)trackRectForBounds:(CGRect)bounds
//{
//    return CGRectMake(0, (CGRectGetHeight(self.frame) - _sliderHeight) * 0.5, CGRectGetWidth(self.frame), _sliderHeight);
//}

@end
