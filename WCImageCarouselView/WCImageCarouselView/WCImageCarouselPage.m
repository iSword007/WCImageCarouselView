//
//  ImageCarousePage.m
//  WCImageCarouselView
//
//  Created by Wilson Chan on 15/6/5.
//  Copyright (c) 2015年 WCImageCarouselView. All rights reserved.
//

#import "WCImageCarouselPage.h"

@interface WCImageCarouselPage ()

@property (nonatomic, weak) UIImageView *page;

@end

@implementation WCImageCarouselPage

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupInitial];
    }
    return self;
}

- (void)setupInitial {
    self.clipsToBounds = YES;
    [self setupPageImage];
    [self setupConstraints];
}

- (void)setupPageImage {
    UIImageView *pageImage = [[UIImageView alloc] init];
    pageImage.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:pageImage];
    _page = pageImage;
}

- (void)setupConstraints {
    self.page.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"pageImage" : self.page};
    
    NSArray *pageImageConstraintsH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[pageImage]-margin-|" options:0 metrics:@{@"margin" : @0.0f} views:views];
    NSArray *pageImageConstraintsV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[pageImage]-margin-|" options:0 metrics:@{@"margin" : @0.0f} views:views];
    
    [self addConstraints:pageImageConstraintsH];
    [self addConstraints:pageImageConstraintsV];
}

- (void)setPageImage:(UIImage *)image {
    if (image) {
        self.page.image = image;
    }
}

@end
