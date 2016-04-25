//
//  ImageCarouselView.h
//  WCImageCarouselView
//
//  Created by Wilson Chan on 15/6/3.
//  Copyright (c) 2015年 WCImageCarouselView. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCImageCarouselPage.h"

/**
 *  @author Wilson, 15-06-03 22:06:09
 *
 *  图片轮播器
 */
typedef NS_ENUM(NSUInteger, ImageCarouselPageControlShowStyle) {
    ImageCarouselPageControlShowStyleNone, //default
    ImageCarouselPageControlShowStyleLeft, //左显示
    ImageCarouselPageControlShowStyleCenter,
    ImageCarouselPageControlShowStyleRight,
};

@interface WCImageCarouselView : UIView

@property (nonatomic, assign) ImageCarouselPageControlShowStyle pageControlShowStyle;
@property (nonatomic, strong) NSArray *carousels;

+ (instancetype)imageCarouseViewWithFrame:(CGRect)frame pageControlShowStyle:(ImageCarouselPageControlShowStyle)pageControlShowStyle;
+ (instancetype)imageCarouseViewWithPageControlShowStyle:(ImageCarouselPageControlShowStyle)pageControlShowStyle;

@end
