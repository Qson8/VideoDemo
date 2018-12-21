//
//  ViewController.m
//  VideoDemo
//
//  Created by Qson on 2018/12/10.
//  Copyright © 2018 Qson. All rights reserved.
//

#import "ViewController.h"
#import <SuperPlayer/SuperPlayer.h>
#import "QSControlView.h"


@interface ViewController () <SuperPlayerDelegate>
@property (nonatomic, strong) SuperPlayerView *playerView;
@property (nonatomic, weak) UIView *holderView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self setupVideoView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)setupVideoView {
    
    QSControlView *crlView = [[QSControlView alloc] init];
    
    _playerView = [[SuperPlayerView alloc] init];
    _playerView.delegate = self;
    _playerView.fatherView = self.holderView;
    _playerView.autoPlay = YES;
    _playerView.autoPlayInDrag = NO;
    _playerView.designPinnerViewHeight = crlView.startBtn.w;
    
    if(_videoStyle == 1) {
        _playerView.controlView = [[SPDefaultControlView alloc] init];
    }
    else {
        //    _playerView.controlView.title = @"MH370在柬埔寨密林深处？一条4年前的";
        _playerView.controlView = crlView;
    }
    
    SuperPlayerModel *playerModel = [[SuperPlayerModel alloc] init];
    // 设置播放地址，直播，点播都可以
    playerModel.videoURL = @"https://video.pearvideo.com/mp4/adshort/20181204/cont-1486600-13323415_adpkg-ad_hd.mp4";
    playerModel.appId = 1257067784;
    [_playerView playWithModel:playerModel];
    
    //    SuperPlayerWindowShared.superPlayer = _playerView; // 设置小窗显示的播放器
    //    SuperPlayerWindowShared.backController = self; // 设置返回的view controller
    //    [SuperPlayerWindowShared show]; // 浮窗显示
}

/// 播放结束通知
- (void)superPlayerDidEnd:(SuperPlayerView *)player {
    player.coverImageView.alpha = 0;
}

#pragma mark - holderView
- (UIView *)holderView {
    if(_holderView == nil) {
        UIView *holderView = [[UIView alloc] init];
        holderView.frame = CGRectMake(0,(ScreenHeight - 500) * 0.5, ScreenWidth, 500);
        holderView.backgroundColor = [UIColor orangeColor];
        [self.view addSubview:holderView];
        _holderView = holderView;
    }
    return _holderView;
}


@end
