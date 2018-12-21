//
//  QSControlView.h
//  VideoDemo
//
//  Created by Qson on 2018/12/10.
//  Copyright © 2018 Qson. All rights reserved.
//

#import "SuperPlayerControlView.h"
#import "QSPlayerSlider.h"

@interface QSControlView : SuperPlayerControlView
/** 开始播放按钮 */
@property (nonatomic, strong) UIButton                *startBtn;
/** 当前播放时长label */
@property (nonatomic, strong) UILabel                 *currentTimeLabel;
/** 视频总时长label */
@property (nonatomic, strong) UILabel                 *totalTimeLabel;
/** 全屏按钮 */
@property (nonatomic, strong) UIButton                *fullScreenBtn;
/** 滑杆 */
@property (nonatomic, strong) QSPlayerSlider            *videoSlider;

@property (nonatomic, strong) UIButton                *backBtn;

@property (nonatomic, strong) UIButton                *muteBtn;

@property (nonatomic, assign,getter=isFullScreen)BOOL fullScreen;

@property BOOL isLive;
@end
