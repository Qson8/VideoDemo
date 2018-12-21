//
//  QSProgressView.h
//  VideoDemo
//
//  Created by Qson on 2018/12/14.
//  Copyright © 2018 Qson. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QSProgressViewStyle) {
    QSProgressViewStyleDefault,     // 默认
    QSProgressViewStyleTrackFillet ,  // 轨道圆角(默认半圆)
    QSProgressViewStyleAllFillet,  //进度与轨道都圆角
};

@interface QSProgressView : UIView
@property(nonatomic) float progress;           // 0.0 .. 1.0, 默认0 超出为1.
@property(nonatomic) float cacheProgress;      // 缓存进度 。0.0 .. 1.0
@property(nonatomic) QSProgressViewStyle progressViewStyle;
@property(nonatomic, strong, nullable) UIColor* progressTintColor;
@property(nonatomic, strong, nullable) UIColor* cacheTintColor;
@property(nonatomic, strong, nullable) UIColor* trackTintColor;
@property(nonatomic,assign) BOOL isTile;  //背景图片是平铺填充 默认NO拉伸填充 设置为YES时图片复制平铺填充
@property(nonatomic, strong, nullable) UIImage* progressImage;  //进度条背景图片,默认拉伸填充  优先级大于背景色
@property(nonatomic, strong, nullable) UIImage* trackImage;     //轨道填充图片

- (instancetype _Nonnull )initWithFrame:(CGRect)frame;
- (instancetype _Nonnull )initWithFrame:(CGRect)frame progressViewStyle:(QSProgressViewStyle)style;
@end
