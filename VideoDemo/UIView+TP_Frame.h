/*
 快速访问控件的x、y、width、height
 view.frame.size.x -->  view.x
 */

#import <UIKit/UIKit.h>

@interface UIView (TP_Frame)
// 首先分类是不能添加属性的，但可以@property
// @property 不会给我们生产下划线的成员属性，而且必须实现set、get方法

/** x */
@property (nonatomic, assign) CGFloat x;
/** y */
@property (nonatomic, assign) CGFloat y;
/** width */
@property (nonatomic, assign) CGFloat w;
/** height */
@property (nonatomic, assign) CGFloat h;
/** cneter x*/
@property (nonatomic, assign) CGFloat center_x;
/** cneter y*/
@property (nonatomic, assign) CGFloat center_y;
@end
