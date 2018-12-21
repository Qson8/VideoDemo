//
//  QSPlayerSlider.h
//  VideoDemo
//
//  Created by Qson on 2018/12/14.
//  Copyright © 2018 Qson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSProgressView.h"

@interface QSPlayerPoint : NSObject
@property GLfloat where;
@property UIControl  *holder;
@property NSString *content;
@property NSInteger timeOffset;
@end

@protocol QSPlayerSliderDelegate <NSObject>
- (void)onPlayerPointSelected:(QSPlayerPoint *)point;
@end

@interface QSPlayerSlider : UISlider
@property NSMutableArray<QSPlayerPoint *> *pointArray;
@property(nonatomic) float progress;
@property(nonatomic) float sliderHeight;
@property QSProgressView *progressView;
@property (weak) id<QSPlayerSliderDelegate> delegate;
@property (nonatomic) BOOL hiddenPoints;

- (QSPlayerPoint *)addPoint:(GLfloat)where;

@end
