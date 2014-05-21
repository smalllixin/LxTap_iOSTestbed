//
//  LxUI.h
//  BjRollCar
//
//  Created by li xin on 12-4-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define IS_IPHONE_5 ( [ [ UIScreen mainScreen ] bounds ].size.height == 568 )

#define FrameX(v) (v.frame.origin.x)
#define FrameY(v) (v.frame.origin.y)
#define FrameWidth(v) (v.frame.size.width)
#define FrameHeight(v) (v.frame.size.height)


#define RectUseWidthHeight(v) CGRectMake(0,0,v.frame.size.width,v.frame.size.height)

@interface LxUI : NSObject

+(void)makeViewRoundCornerAndShadow:(UIView*)view;
+(CGSize)getTextSize:(NSString*)text font:(UIFont*)font;
+ (UIImage*)captureView:(UIView *)yourView;
+ (void)customNavigationItem:(UIViewController*)c title:(NSString *)title;
+ (void)setNavigationBarImage:(UINavigationBar*)bar;


+(void)makeNavigationBtnLight:(UIBarButtonItem*)buttonItem;

+(void)makeBackBtn:(UINavigationItem *)navItem title:(NSString *)title;

+(void)autoJustLabelFrame:(UILabel*)label;

+(void)makeLinearLayoutAdjust:(UIScrollView*)scroll vpadding:(float)vpadding;

+(void)makeLinearLayoutAdjust:(UIScrollView*)scroll views:(NSArray*)views vpadding:(float)vpadding;

+(float)makeViewLinearAdjust:(UIView*)container views:(NSArray*)views vpadding:(float)vpadding;

+(void)makeContainerFlowLayout:(UIView*)container hpadding:(float)hpadding vpadding:(float)vpadding;

+(void)removeSubviews:(UIView*)v;

+(void)poRect:(CGRect)frame;

+ (UIBarButtonItem*)navIndicatorView;

+ (UIImage *)imageWithColor:(UIColor *)color;
@end
