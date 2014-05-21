//
//  LxUI.m
//  BjRollCar
//
//  Created by li xin on 12-4-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LxUI.h"

#import <QuartzCore/QuartzCore.h>
@implementation LxUI

+(void)makeViewRoundCornerAndShadow:(UIView*)view
{
    CALayer *layer = view.layer;
    layer.masksToBounds = YES;
    layer.anchorPoint = CGPointMake(0.5, 0.5);
    layer.cornerRadius = 5;
    CALayer *sublayer = [CALayer layer];
    sublayer.backgroundColor = [UIColor blackColor].CGColor;
    sublayer.shadowOffset = CGSizeMake(0, 3);
    sublayer.shadowRadius = 5.0;
    sublayer.shadowColor = [UIColor blackColor].CGColor;
    sublayer.shadowOpacity = 0.8;
    sublayer.frame = layer.frame;
    sublayer.cornerRadius = 5;
    sublayer.zPosition = 2;
    layer.zPosition =3;
    [layer addSublayer:sublayer];
}
+(CGSize)getTextSize:(NSString*)text font:(UIFont*)font{
    CGSize constrainedSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    NSDictionary *strAttrs = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGSize textSize = [text boundingRectWithSize:constrainedSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:strAttrs context:nil].size;
//    CGSize textSize = [text sizeWithFont:font
//                       constrainedToSize:constrainedSize
//                           lineBreakMode:UILineBreakModeWordWrap];
    return textSize;
}
+ (UIImage*)captureView:(UIView *)yourView {
    CGRect rect = [[UIScreen mainScreen] bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [yourView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (void)customNavigationItem:(UIViewController*)c title:(NSString *)title
{
//    [c setTitle:title];
    c.title = title;
    UILabel *titleView = (UILabel *)c.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont boldSystemFontOfSize:20.0];
//        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        titleView.textColor = UIColorFromRGB(0x663300); // Change to desired color
        
        c.navigationItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}

+ (void)setNavigationBarImage:(UINavigationBar*)bar
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0){
        UIImageView *imageView = (UIImageView *)[bar viewWithTag:888];
        if (imageView == nil)
        {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar_bg"]];
            [imageView setTag:888];
            [bar insertSubview:imageView atIndex:0];
            imageView = nil;
            [bar setTintColor:[UIColor colorWithRed:0.39 green:0.72 blue:0.62 alpha:1.0]];
        }
    }
}

+(void)makeNavigationBtnLight:(UIBarButtonItem*)buttonItem
{
    [buttonItem setTintColor:UIColorFromRGB(0xff6d0c)];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor clearColor];
    
    NSDictionary *btnItemTextColor = [NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0xffffff), NSForegroundColorAttributeName,
                                      shadow,NSShadowAttributeName,nil];
    NSDictionary *navHighLightColor = [NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0xffffff), NSForegroundColorAttributeName,
                                       shadow,NSShadowAttributeName,nil];
    
    [buttonItem setTitleTextAttributes:btnItemTextColor forState:UIControlStateNormal];
    [buttonItem setTitleTextAttributes:navHighLightColor forState:UIControlStateHighlighted];
}

+(void)makeBackBtn:(UINavigationItem *)navItem title:(NSString *)title
{
    if(title.length > 4){
        title = [title substringToIndex:4];
        navItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:nil action:nil];
    }
}

+(void)autoJustLabelFrame:(UILabel*)label
{
    if ((floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)){//>7.0
        NSDictionary *strAttrs = [NSDictionary dictionaryWithObject:label.font forKey:NSFontAttributeName];
        CGSize textSize = [label.text boundingRectWithSize:CGSizeMake(label.bounds.size.width, NSIntegerMax) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:strAttrs context:nil].size;
        label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.bounds.size.width, textSize.height);
        
    } else {
        CGSize textSize = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.bounds.size.width, NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
        label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.bounds.size.width, textSize.height);
    }
}

+(void)makeLinearLayoutAdjust:(UIScrollView*)scroll vpadding:(float)vpadding
{
    [LxUI makeLinearLayoutAdjust:scroll views:scroll.subviews vpadding:vpadding];
}

+(void)makeLinearLayoutAdjust:(UIScrollView*)scroll views:(NSArray*)views vpadding:(float)vpadding
{
    UIView *first = [views objectAtIndex:0];
    float startY = first.frame.origin.y;
    for (int i = 0; i < views.count; i ++) {
        UIView *v = [views objectAtIndex:i];
        if (v.hidden == NO){
            float fheight = CGRectGetHeight(v.frame);
            v.frame = CGRectMake(FrameX(v), startY, FrameWidth(v), FrameHeight(v));
            startY = startY + fheight + vpadding;
            NSLog(@"%d 高度:%f", i, FrameHeight(v));
        }
    }
    
    scroll.contentSize = CGSizeMake(FrameWidth(scroll), startY);
}

+(float)makeViewLinearAdjust:(UIView*)container views:(NSArray*)views vpadding:(float)vpadding
{
    if ([views count] == 0){
        return 0;
    }
    
    UIView *first = [views objectAtIndex:0];
    float startY = first.frame.origin.y;
    for (int i = 0; i < views.count; i ++) {
        UIView *v = [views objectAtIndex:i];
        if (v.hidden == NO){
            float fheight = CGRectGetHeight(v.frame);
            v.frame = CGRectMake(FrameX(v), startY, FrameWidth(v), FrameHeight(v));
            startY = startY + fheight + vpadding;
        }
    }
    
    CGRect frame = container.frame;
    frame.size.height = startY;
    container.frame = frame;
    return startY;
}

/**
 * 计算label的位置和container的frame
 label要保证width 和 height都是没问题的
 */
+(void)makeContainerFlowLayout:(UIView*)container hpadding:(float)hpadding vpadding:(float)vpadding;
{
    float cwidth = container.bounds.size.width;
    float item_padding_hor = hpadding;//horizontal padding
    float item_padding_ver = vpadding;//vertical padding
    
    int line = 0; //当前是第n行
    float lineMaxHeight=0;//当前行最大的item高
    float startY = 0;
    float curX = 0;
    for (UIView *v in container.subviews) {
        float fwidth = CGRectGetWidth(v.frame);
        float fheight = CGRectGetHeight(v.bounds);
        if (fwidth > cwidth){
            //超过frame了,do nothing, just return
            v.frame = CGRectMake(curX,startY,fwidth,fheight);
            startY += fheight + item_padding_ver;
            line ++;
        }
        else {
            if (fheight > lineMaxHeight){
                lineMaxHeight = fheight;
            }
            if (curX + fwidth> cwidth){//如果超过容器宽度
                //need return
                line ++;
                curX = 0;
                startY += lineMaxHeight + item_padding_ver;
                lineMaxHeight = fheight;
                v.frame = CGRectMake(curX, startY, fwidth, fheight);
            }
            else {
                v.frame = CGRectMake(curX, startY, fwidth, fheight);
                curX = curX + item_padding_hor + fwidth;
            }
        }
    };
    startY += lineMaxHeight;
    container.frame = CGRectMake(container.frame.origin.x, container.frame.origin.y,
                                 cwidth, startY);
}

+(void)removeSubviews:(UIView*)v
{
    for (UIView *child in v.subviews) {
        [child removeFromSuperview];
    }
}


+(void)poRect:(CGRect)frame
{
    NSLog(@"Frame:%f %f %f %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
}

+ (UIBarButtonItem*)navIndicatorView {
    UIActivityIndicatorView *av = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIView *cv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 46, 33)];
    [cv addSubview:av];
    av.center = cv.center;
    [av startAnimating];
    return [[UIBarButtonItem alloc] initWithCustomView:av];
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
