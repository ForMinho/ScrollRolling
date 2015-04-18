//
//  ZCRollingScrollView.m
//  ZCScrollewRolling
//
//  Created by For_Minho on 15-4-17.
//  Copyright (c) 2015年 For_Minho. All rights reserved.
//

#import "ZCRollingScrollView.h"
#define ContentY     (self.scrollView.center.y - (self.scrollView.frame.size.height / 2))
@interface ZCRollingScrollView ()<UIScrollViewDelegate>
{
    NSInteger timerDelay;
}
@property (nonatomic        ) CGRect scrollRect;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView  *scrollView;
@end

@implementation ZCRollingScrollView
- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initWithScroll];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initWithScroll];
    }
    return self;
}
- (void)initWithScroll
{
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect rect = self.view.frame;
    self.scrollView = [[UIScrollView alloc] initWithFrame:rect];
    self.scrollView.backgroundColor = [UIColor redColor];
    self.scrollRect = self.scrollView.frame;
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.alwaysBounceHorizontal = NO;
    self.scrollView.alwaysBounceVertical   = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    rect.size.height = 20;
    rect.origin.y = CGRectGetHeight(self.view.frame) - rect.size.height;
    self.pageControl = [[UIPageControl alloc] initWithFrame:rect];
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    self.pageControl.currentPage = 0;
    [self.view addSubview:self.pageControl];
    timerDelay = 2.0f;
   
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
    CGRect rect = self.scrollRect;
    float proportion = CGRectGetWidth(self.scrollRect) / CGRectGetHeight(self.scrollRect);
    for (NSInteger i = 0; i < self.imgArray.count; i ++)
    {
        rect.origin.x = CGRectGetWidth(self.scrollRect) * i;
        UIImage *img = self.imgArray[i];
        CGSize size = img.size;
        rect.size.width = self.scrollRect.size.width;
        rect.size.height = self.scrollRect.size.height;
        if (size.width / size.height > proportion) {
//            说明图片的宽度大
            rect.size.height = size.height * rect.size.width / size.width;
        }else
        {
//            说明图片高度大
            rect.size.width = size.width * rect.size.height / size.height;
        }
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
        CGPoint center  = imgView.center;
        center.y = self.scrollView.center.y;
        imgView.center = center;

        [imgView setImage:img];
        [self.scrollView addSubview:imgView];
    }
    if (_imgArray.count > 1) {
        [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollRect), ContentY) animated:NO];
        [self performSelector:@selector(timerScrollImgPages) withObject:self
                   afterDelay:timerDelay];
    }
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
    
    if (consetX < CGRectGetWidth(self.scrollRect)) {
        [self.scrollView setContentOffset:CGPointMake((_imgArray.count - 2)*CGRectGetWidth(self.scrollRect), ContentY) animated:NO];
    }
    if (consetX > CGRectGetWidth(self.scrollRect) * (_imgArray.count - 1)) {
        [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollRect), ContentY) animated:NO];
    }
    
    NSInteger currentPage = consetX / CGRectGetWidth(self.scrollRect);
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
- (void)dealloc
{
    NSLog(@"%@-%@",NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

@end
