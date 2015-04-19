//
//  ZCRollingScrollView.h
//  ZCScrollewRolling
//
//  Created by For_Minho on 15-4-17.
//  Copyright (c) 2015年 For_Minho. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZCRollingScrollView;
@protocol ZCRollingScrollViewDelegate <NSObject>
- (NSString *)ZCRollingScrollView:(UIScrollView *)scrollView AtIndex:(NSString *)index;
@end
@interface ZCRollingScrollView : UIViewController
@property (nonatomic, strong) NSArray *imgArray;
@end
