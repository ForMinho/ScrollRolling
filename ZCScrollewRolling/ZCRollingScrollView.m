//
//  ZCRollingScrollView.m
//  ZCScrollewRolling
//
//  Created by For_Minho on 15-4-17.
//  Copyright (c) 2015年 For_Minho. All rights reserved.
//

#import "ZCRollingScrollView.h"
@interface ZCRollingScrollView ()<UIScrollViewDelegate>
{
    NSInteger timerDelay;
}
@property (nonatomic        ) CGRect scrollRect;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView  *scrollView;
@end

@implementation ZCRollingScrollView
- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = self.frame;
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.scrollRect = self.scrollView.frame;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.delegate = self;
        self.scrollView.bounces = YES;
//        [self addSubview:self.scrollView];
        rect.size.height = 20;
        rect.origin.y = CGRectGetHeight(self.frame) - rect.size.height;
        self.pageControl = [[UIPageControl alloc] initWithFrame:rect];
        self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        self.pageControl.currentPage = 0;
        [self addSubview:self.pageControl];
        timerDelay = 2.0f;
    }
    return self;
}
- (void)setImgArray:(NSArray *)imgArray
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:imgArray];
    if (imgArray.count > 1) {
        [array addObject:imgArray[0]];
        [array insertObject:imgArray[imgArray.count - 1] atIndex:0];
    }
    _imgArray = array;
    self.scrollView.contentSize = CGSizeMake(self.imgArray.count * CGRectGetWidth(self.scrollRect), 0);
    self.scrollView.pagingEnabled = YES;
    self.pageControl.numberOfPages = _imgArray.count > 1 ?_imgArray.count - 2:_imgArray.count;
    [self initWithUI];
}

- (void)initWithUI
{
    CGRect rect = self.frame;
    for (NSInteger i = 0; i < self.imgArray.count; i ++) {
        rect.origin.x = CGRectGetWidth(self.frame) * i;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
        UIImage *img = self.imgArray[i];
        [imgView setImage:img];
        [self.scrollView addSubview:imgView];
    }
    if (_imgArray.count > 1) {
        [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollRect), 0) animated:NO];
    }
    [self performSelector:@selector(timerScrollImgPages) withObject:self
               afterDelay:timerDelay];
}

- (void)timerScrollImgPages
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timerScrollImgPages) object:nil];
    
    if (_imgArray.count > 1) {
        CGFloat contentX = self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollRect);
        [self.scrollView setContentOffset:CGPointMake(contentX, 0) animated:YES];
        [self performSelector:@selector(timerScrollImgPages) withObject:self
                   afterDelay:timerDelay];

    }
    
}
#pragma mark --- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat consetX = scrollView.contentOffset.x;
    
    if (consetX < 0) {
        [scrollView setContentOffset:CGPointMake((_imgArray.count - 2)*CGRectGetWidth(self.scrollRect), 0) animated:NO];
    }
    if (consetX > CGRectGetWidth(self.scrollRect) * (_imgArray.count - 1)) {
        [scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollRect), 0) animated:NO];
    }
    
    int currentPage = consetX / CGRectGetWidth(self.scrollRect);
    if (_imgArray.count > 1)
    {
        currentPage --;
        if (currentPage < 0)
        {
            currentPage = self.pageControl.numberOfPages - 1;
        }
        if (currentPage > self.pageControl.numberOfPages - 1) {
            currentPage = 0;
        }
    }

    self.pageControl.currentPage = currentPage;
}

@end
