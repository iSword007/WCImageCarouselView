//
//  CWImageCarouselView.m
//  WCCWImageCarouselView
//
//  Created by Wilson Chan on 15/6/3.
//  Copyright (c) 2015年 WCCWImageCarouselView. All rights reserved.
//

#import "WCImageCarouselView.h"

//#define kDefaultImageWidth [UIScreen mainScreen].bounds.size.width
#define kDefaultImageWidth self.scrollView.bounds.size.width
#define KDefaultImageHeight self.scrollView.bounds.size.height

typedef NS_ENUM(NSUInteger, WCViewToScroll) {
    ImageCarouselToScrollNone, //default, 表示切换图片
    ImageCarouselToScrollNext, //下一张
    ImageCarouselToScrollPrevious, //上一张
};

@interface WCImageCarouselView () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, assign) int index;
@property (nonatomic, assign) CGFloat bignDragging;

    @property (nonatomic, weak) WCImageCarouselPage *leftPage;
@property (nonatomic, weak) WCImageCarouselPage *centerPage;
@property (nonatomic, weak) WCImageCarouselPage *rightPage;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation WCImageCarouselView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupInitial];
    }
    return self;
}

- (void)awakeFromNib {
    [self setupInitial];
}

+ (instancetype)imageCarouseViewWithFrame:(CGRect)frame pageControlShowStyle:(ImageCarouselPageControlShowStyle)pageControlShowStyle {
    WCImageCarouselView *CWImageCarouselView = [[self alloc] initWithFrame:frame];
    CWImageCarouselView.pageControlShowStyle = pageControlShowStyle;
    return CWImageCarouselView;
}

+ (instancetype)imageCarouseViewWithPageControlShowStyle:(ImageCarouselPageControlShowStyle)pageControlShowStyle {
    WCImageCarouselView *imageCarouselView = [[self alloc] init];
    imageCarouselView.pageControlShowStyle = pageControlShowStyle;
    return imageCarouselView;
}

- (void)setupInitial {
    self.index = 0;
    [self setupScrollView];
    [self setupPageControl];
    [self setupConstraints];
    [self setupPages];
    [self setupNextPageTimer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.leftPage.frame = CGRectMake(0, 0, kDefaultImageWidth, KDefaultImageHeight);
    self.centerPage.frame = CGRectMake(kDefaultImageWidth, 0, kDefaultImageWidth, KDefaultImageHeight);
    self.rightPage.frame = CGRectMake(kDefaultImageWidth * 2, 0, kDefaultImageWidth, KDefaultImageHeight);
    self.scrollView.contentSize = CGSizeMake(kDefaultImageWidth * 3, KDefaultImageHeight);
    [self.scrollView setContentOffset:CGPointMake(kDefaultImageWidth, 0) animated:NO];
    [self layoutIfNeeded];
}

- (void)setCarousels:(NSArray *)carousels {
    self.pageControl.numberOfPages = carousels.count;
    _carousels = carousels;
    int previousIndex = self.index - 1 < 0 ? (int)self.carousels.count - 1 : self.index - 1;
    int nextIndex = self.index + 1 >= self.carousels.count ? 0 : self.index + 1;
    [self.leftPage setPageImage:[UIImage imageNamed:carousels[previousIndex % carousels.count]]];
    [self.centerPage setPageImage:[UIImage imageNamed:carousels[self.index % carousels.count]]];
    [self.rightPage setPageImage:[UIImage imageNamed:carousels[nextIndex % carousels.count]]];
    
}

- (void)setIndex:(int)index {
    if (index < 0) {
        index = (int)self.carousels.count - 1;
    } else if (index >= self.carousels.count) {
        index = 0;
    }
    _index = index;;
}


- (void)setupScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.scrollsToTop = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.alwaysBounceHorizontal = NO;
    scrollView.alwaysBounceVertical = NO;
//    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor orangeColor];
    
    
    [self addSubview:scrollView];
    _scrollView = scrollView;
}

- (void)setupPageControl {
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    
    [self insertSubview:pageControl aboveSubview:self.scrollView];
    _pageControl = pageControl;
}

- (void)setupPages {
    WCImageCarouselPage *leftPage = [[WCImageCarouselPage alloc] initWithFrame:CGRectMake(0, 0, kDefaultImageWidth, KDefaultImageHeight)];
    WCImageCarouselPage *centerPage = [[WCImageCarouselPage alloc] initWithFrame:CGRectMake(kDefaultImageWidth, 0, kDefaultImageWidth, KDefaultImageHeight)];
    WCImageCarouselPage *rightPage = [[WCImageCarouselPage alloc] initWithFrame:CGRectMake(kDefaultImageWidth*2, 0, kDefaultImageWidth, KDefaultImageHeight)];
    
    [self.scrollView addSubview:leftPage];
    [self.scrollView addSubview:centerPage];
    [self.scrollView addSubview:rightPage];
    
    _leftPage = leftPage;
    _centerPage = centerPage;
    _rightPage = rightPage;
}

- (void)setPageControlShowStyle:(ImageCarouselPageControlShowStyle)pageControlShowStyle {
    _pageControlShowStyle = pageControlShowStyle;
}

- (void)setupConstraints {
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"scrollView" : self.scrollView, @"pageControl" : self.pageControl};
    
    NSArray *scrollViewContraintsH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[scrollView]-margin-|" options:0 metrics:@{@"margin" : @0.0f} views:views];
    NSArray *scrollViewContraintsV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[scrollView]-margin-|" options:0 metrics:@{@"margin" : @0.0f} views:views];
    [self addConstraints:scrollViewContraintsH];
    [self addConstraints:scrollViewContraintsV];
    
    NSArray *pageControlConstraintsV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[pageControl]-margin-|" options:0 metrics:@{@"margin" : @0.0f} views:views];
    NSLayoutConstraint *pageControlConstraintHCenter = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.pageControl attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    [self addConstraints:pageControlConstraintsV];
    [self addConstraint:pageControlConstraintHCenter];
}

- (void)setupNextPageTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(toNextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateNextPageTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)toNextPage {
    CGFloat offsetX = kDefaultImageWidth * 2;
    CGPoint offset = CGPointMake(offsetX, 0);
    [self.scrollView setContentOffset:offset animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x < kDefaultImageWidth / 2) {
        [self carouselPageToScroll:ImageCarouselToScrollPrevious scrollOffsetX:scrollView.contentOffset.x];
    } else if (scrollView.contentOffset.x > (kDefaultImageWidth * 3 / 2)) {
        [self carouselPageToScroll:ImageCarouselToScrollNext scrollOffsetX:scrollView.contentOffset.x];
    }
}

- (void)carouselPageToScroll:(WCViewToScroll)toScroll scrollOffsetX:(CGFloat)offsetX {
    if (toScroll == ImageCarouselToScrollNext) {
        self.index ++;
        offsetX -= kDefaultImageWidth;
    } else if (toScroll == ImageCarouselToScrollPrevious) {
        self.index --;
        offsetX += kDefaultImageWidth;
    } else {
        return;
    }
    self.scrollView.contentOffset = CGPointMake(offsetX, 0);
    int previousIndex = self.index - 1 < 0 ? (int)self.carousels.count - 1 : self.index - 1;
    int nextIndex = self.index + 1 >= self.carousels.count ? 0 : self.index + 1;
    [self.leftPage setPageImage:[UIImage imageNamed:self.carousels[previousIndex % self.carousels.count]]];
    [self.centerPage setPageImage:[UIImage imageNamed:self.carousels[self.index % self.carousels.count]]];
    [self.rightPage setPageImage:[UIImage imageNamed:self.carousels[nextIndex % self.carousels.count]]];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self updatePageControl];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updatePageControl];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self invalidateNextPageTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self setupNextPageTimer];
}

- (void)updatePageControl {
    self.pageControl.currentPage = self.index % self.carousels.count;
}

@end
