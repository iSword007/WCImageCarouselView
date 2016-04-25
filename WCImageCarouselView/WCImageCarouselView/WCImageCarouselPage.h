//
//  ImageCarousePage.h
//  WCImageCarouselView
//
//  Created by Wilson Chan on 15/6/5.
//  Copyright (c) 2015年 WCImageCarouselView. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCImageCarouselPage : UIView

@property (nonatomic, weak) UILabel *pageTitle;

- (void)setPageImage:(UIImage *)image;

@end
