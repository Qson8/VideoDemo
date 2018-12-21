
//
//  QSProgressView.m
//  VideoDemo
//
//  Created by Qson on 2018/12/14.
//  Copyright © 2018 Qson. All rights reserved.
//

#import "QSProgressView.h"

@interface QSProgressView ()
{
    UIView *_cacheView;
    UIView *_progressView;
    float _progress;
}
@end

@implementation QSProgressView

-(instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame progressViewStyle:QSProgressViewStyleDefault];
}

- (instancetype)initWithFrame:(CGRect)frame progressViewStyle:(QSProgressViewStyle)style
{
    if (self=[super initWithFrame:frame]) {
        self.progressViewStyle = style;
        _cacheProgress = 0;
        _progress = 0;
        
        _cacheView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
        [self addSubview:_cacheView];
        
        _progressView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
        [self addSubview:_progressView];
    }
    return self;
}

-(void)setProgressViewStyle:(QSProgressViewStyle)progressViewStyle
{
    _progressViewStyle = progressViewStyle;
    if (progressViewStyle == QSProgressViewStyleTrackFillet) {
        self.layer.masksToBounds=YES;
        self.layer.cornerRadius=self.bounds.size.height/2;
    }
    else if (progressViewStyle == QSProgressViewStyleAllFillet)
    {
        self.layer.masksToBounds=YES;
        self.layer.cornerRadius=self.bounds.size.height/2;
        _progressView.layer.cornerRadius=self.bounds.size.height/2;
    }
}

-(void)setTrackTintColor:(UIColor *)trackTintColor
{
    _trackTintColor=trackTintColor;
    if (self.trackImage) {
        
    }
    else
    {
        self.backgroundColor=trackTintColor;
    }
}
-(void)setProgress:(float)progress
{
    _progress=MIN(progress, 1);
    _progressView.frame=CGRectMake(0, 0, self.bounds.size.width*_progress, self.bounds.size.height);
}

- (void)setCacheProgress:(float)cacheProgress {
    _cacheProgress = MIN(cacheProgress, 1);
    _cacheView.frame = CGRectMake(0, 0, self.bounds.size.width*_cacheProgress, self.bounds.size.height);
}

-(float)progress
{
    return _progress;
}

-(void)setProgressTintColor:(UIColor *)progressTintColor
{
    _progressTintColor=progressTintColor;
    _progressView.backgroundColor=progressTintColor;
}

- (void)setCacheTintColor:(UIColor *)cacheTintColor {
    _cacheTintColor = cacheTintColor;
    _cacheView.backgroundColor = cacheTintColor;
}

-(void)setTrackImage:(UIImage *)trackImage
{
    _trackImage=trackImage;
    if(self.isTile)
    {
        self.backgroundColor=[UIColor colorWithPatternImage:trackImage];
    }
    else
    {
        self.backgroundColor=[UIColor colorWithPatternImage:[self stretchableWithImage:trackImage]];
    }
}
-(void)setIsTile:(BOOL)isTile
{
    _isTile = isTile;
    if (self.progressImage) {
        [self setProgressImage:self.progressImage];
    }
    if (self.trackImage) {
        [self setTrackImage:self.trackImage];
    }
}
-(void)setProgressImage:(UIImage *)progressImage
{
    _progressImage = progressImage;
    if(self.isTile)
    {
        _progressView.backgroundColor=[UIColor colorWithPatternImage:progressImage];
    }
    else
    {
        _progressView.backgroundColor=[UIColor colorWithPatternImage:[self stretchableWithImage:progressImage]];
    }
}
- (UIImage *)stretchableWithImage:(UIImage *)image{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.f);
    [image drawInRect:self.bounds];
    UIImage *lastImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return lastImage;
}
@end
