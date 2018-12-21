//
//  QSControlView.m
//  VideoDemo
//
//  Created by Qson on 2018/12/10.
//  Copyright © 2018 Qson. All rights reserved.
//

#import "QSControlView.h"
#import <Masonry/Masonry.h>
#import "DataReport.h"
#import "UIView+Fade.h"
#import "StrUtils.h"
#import <SuperPlayer/SuperPlayer.h>

#define RGBA(r,g,b,a)                       [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define SuperPlayerImage(file)              [UIImage imageNamed:file]

@interface QSControlView ()
{
    // 拖动时视频是否在播放
    BOOL _palayingBeforeDrag;
}
@end

@implementation QSControlView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.startBtn];
        [self addSubview:self.currentTimeLabel];
        [self addSubview:self.totalTimeLabel];
        [self addSubview:self.videoSlider];
        [self addSubview:self.fullScreenBtn];
        [self addSubview:self.muteBtn];
        [self addSubview:self.backBtn];
        
        // 添加子控件的约束
        [self setupFrame];
        [self resetControlView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setupFrame];
}

- (void)setupFrame {
    
    CGFloat margin = 0;
    if(_fullScreen) {

    }
    else {

    }
    
    self.backBtn.w = kIPadSuitFloat(20) + 2 * kIPadSuitFloat(10);
    self.backBtn.h = kIPadSuitFloat(20) + 2 * kIPadSuitFloat(10);
    self.backBtn.x = kIPadSuitFloat(5);
    self.backBtn.y = kIPadSuitFloat(14);
    
    [self.currentTimeLabel sizeToFit];
    self.currentTimeLabel.w = self.currentTimeLabel.w + 2 * kIPadSuitFloat(7);
    self.currentTimeLabel.x = kIPadSuitFloat(10);
    self.currentTimeLabel.y = self.h - kIPadSuitFloat(33) - self.self.currentTimeLabel.h;
    
    self.fullScreenBtn.w = kIPadSuitFloat(18) + 2 * kIPadSuitFloat(10);
    self.fullScreenBtn.h = kIPadSuitFloat(18) + 2 * kIPadSuitFloat(5);
    self.fullScreenBtn.center_y = self.currentTimeLabel.center_y;
    self.fullScreenBtn.x = self.w - self.fullScreenBtn.w - kIPadSuitFloat(8);
    
    self.muteBtn.w = kIPadSuitFloat(22) + 2 * kIPadSuitFloat(10);
    self.muteBtn.h = kIPadSuitFloat(22) + 2 * kIPadSuitFloat(5);
    self.muteBtn.x = CGRectGetMinX(self.fullScreenBtn.frame) - self.muteBtn.w;
    self.muteBtn.center_y = self.currentTimeLabel.center_y;
    
    [self.totalTimeLabel sizeToFit];
    self.totalTimeLabel.w = self.totalTimeLabel.w + 2 * kIPadSuitFloat(7);
    self.totalTimeLabel.x = CGRectGetMinX(self.muteBtn.frame)  - self.totalTimeLabel.w;
    self.totalTimeLabel.center_y = self.currentTimeLabel.center_y;
    
    self.videoSlider.x = CGRectGetMaxX(self.currentTimeLabel.frame);
    self.videoSlider.w = self.totalTimeLabel.x - CGRectGetMaxX(self.currentTimeLabel.frame);
    self.videoSlider.h = kIPadSuitFloat(30);
    self.videoSlider.center_y = self.currentTimeLabel.center_y;
    
    [self.startBtn sizeToFit];
    self.startBtn.center = self.center;
}

#pragma mark - 事件
- (void)playBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.delegate controlViewPlay:self];
    } else {
        [self.delegate controlViewPause:self];
    }
    [self cancelFadeOut];
}

- (void)fullScreenBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.delegate controlViewChangeScreen:self withFullScreen:sender.selected];
}

#pragma mark - 内部实现
- (void)progressSliderTouchBegan:(UISlider *)sender {
    self.isDragging = YES;
    self.startBtn.hidden = YES; // 播放按钮挡住了fastView
    [self cancelFadeOut];
    
    // 先记录拖动时的播放状态，然后停止播放,拖动结束时恢复状态
    _palayingBeforeDrag = self.startBtn.selected;
    if(self.startBtn.selected) {
        [self.delegate controlViewPause:self];
    }
}

- (void)progressSliderValueChanged:(UISlider *)sender {
    self.videoSlider.progress           = sender.value;
    [self.delegate controlViewPreview:self where:sender.value];
}

- (void)progressSliderTouchEnded:(UISlider *)sender {
    [self.delegate controlViewSeek:self where:sender.value];
    self.isDragging = NO;
    self.startBtn.hidden = NO;
    [self cancelFadeOut];
    
    // 继续播放
    if(_palayingBeforeDrag) {
        [self.delegate controlViewPlay:self];
    }
}

- (void)setProgressTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime
          progressValue:(CGFloat)progress playableValue:(CGFloat)playable;
{
    if (!self.isDragging) {
        // 更新slider
        self.videoSlider.value           = progress;
        self.videoSlider.progress        = progress;
        // 更新当前播放时间
        self.currentTimeLabel.text = [StrUtils timeFormat:currentTime];
    }
    else {
        // 更新当前播放时间
        self.currentTimeLabel.text = [StrUtils timeFormat:currentTime];
    }
    // 更新总时间
    self.totalTimeLabel.text = [StrUtils timeFormat:totalTime];
    self.videoSlider.progressView.cacheProgress = playable;

//    [self.videoSlider.progressView setProgress:playable animated:NO];
    
//    NSLog(@"%ld -- %f -- %f -- %ld",currentTime,progress,playable,totalTime);
}

- (void)muteBtnClick:(UIButton *)sender
{
    sender.selected = self.playerConfig.mute = !self.playerConfig.mute;
    [self.delegate controlViewConfigUpdate:self];
    [self fadeOut:3];
}


/** 重置ControlView */
- (void)resetControlView {
    self.videoSlider.value           = 0;
    self.videoSlider.progressView.progress = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    
    for (UIView *view in self.subviews) {
        if(view == self.backBtn && !self.isFullScreen) {
            view.hidden = YES;
        }
        else {
            view.hidden = hidden;
        }
    }
    self.isShowSecondView = NO;
}

/** 播放按钮状态 */
- (void)setPlayState:(BOOL)isPlay {
    self.startBtn.selected = isPlay;
}

- (void)moreBtnClick:(UIButton *)sender {
    for (UIView *view in self.subviews) {
        view.hidden = YES;
    }

    [self cancelFadeOut];
    self.isShowSecondView = YES;
}

- (void)playerBegin:(SuperPlayerModel *)model
             isLive:(BOOL)isLive
     isTimeShifting:(BOOL)isTimeShifting
         isAutoPlay:(BOOL)isAutoPlay
{
    [self setPlayState:isAutoPlay];
    

    if (model.playingDefinition != nil) {

    }
    
    
    if (self.isLive != isLive) {
        self.isLive = isLive;
        [self setNeedsLayout];
    }
 
}

// 重载父类方法 横屏下
- (void)setOrientationLandscapeConstraint {
    self.fullScreen             = YES;
    self.fullScreenBtn.selected = YES;

    self.backBtn.hidden = NO;
    self.muteBtn.hidden = NO;

    
    self.videoSlider.hiddenPoints = NO;
}

// 重载父类方法 竖屏下
- (void)setOrientationPortraitConstraint {
    self.fullScreen             = NO;
    self.fullScreenBtn.selected = NO;

    self.backBtn.hidden = YES;
    self.muteBtn.hidden = NO;

    self.videoSlider.hiddenPoints = YES;
}

- (void)setPointArray:(NSArray *)pointArray
{
    [super setPointArray:pointArray];
    
    for (PlayerPoint *holder in self.videoSlider.pointArray) {
        [holder.holder removeFromSuperview];
    }
    [self.videoSlider.pointArray removeAllObjects];
    
    for (SuperPlayerVideoPoint *p in pointArray) {
        QSPlayerPoint *point = [self.videoSlider addPoint:p.where];
        point.content = p.text;
        point.timeOffset = p.time;
    }
}


#pragma mark - 懒加载

- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBtn setImage:SuperPlayerImage(@"sv_pauseStatus") forState:UIControlStateNormal];
        [_startBtn setImage:SuperPlayerImage(@"sv_palyStatus") forState:UIControlStateSelected];
        [_startBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel               = [[UILabel alloc] init];
        _currentTimeLabel.textColor     = [UIColor whiteColor];
        _currentTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}

- (QSPlayerSlider *)videoSlider {
    if (!_videoSlider) {
        _videoSlider                       = [[QSPlayerSlider alloc] init];
        _videoSlider.sliderHeight = kIPadSuitFloat(5);
        _videoSlider.maximumValue = 1;
        [_videoSlider setThumbImage:SuperPlayerImage(@"sv_dot") forState:UIControlStateNormal];
        [_videoSlider setThumbImage:SuperPlayerImage(@"sv_dot") forState:UIControlStateHighlighted];

        _videoSlider.minimumTrackTintColor = [UIColor clearColor];
        _videoSlider.maximumTrackTintColor = [UIColor clearColor];
        
        // slider开始滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        // slider滑动中事件
        [_videoSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // slider结束滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside|UIControlEventTouchCancel];
        _videoSlider.delegate = (id<QSPlayerSliderDelegate>)self;
    }
    return _videoSlider;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel               = [[UILabel alloc] init];
        _totalTimeLabel.textColor     = [UIColor whiteColor];
        _totalTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}

- (UIButton *)fullScreenBtn {
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:SuperPlayerImage(@"sv_fullScreen") forState:UIControlStateNormal];
        [_fullScreenBtn setImage:SuperPlayerImage(@"sv_unFullScreen") forState:UIControlStateSelected];
        [_fullScreenBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenBtn;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:SuperPlayerImage(@"sv_barBack") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)muteBtn {
    if (!_muteBtn) {
        _muteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_muteBtn setImage:SuperPlayerImage(@"sv_voice") forState:UIControlStateNormal];
        [_muteBtn setImage:SuperPlayerImage(@"sv_unVoice") forState:UIControlStateSelected];
        [_muteBtn addTarget:self action:@selector(muteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _muteBtn;
}

@end
