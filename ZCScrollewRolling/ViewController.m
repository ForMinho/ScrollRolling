//
//  ViewController.m
//  ZCScrollewRolling
//
//  Created by For_Minho on 15-4-17.
//  Copyright (c) 2015年 For_Minho. All rights reserved.
//

#import "ViewController.h"
#import "ZCRollingScrollView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    NSMutableArray *imgArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 5; i < 10; i ++) {
        NSString *imgName = [NSString stringWithFormat:@"IMG_338%lu",(long)i];
        UIImage *img = [UIImage imageNamed:imgName];
        [imgArr addObject:img];
    }
    ZCRollingScrollView *scrollView = [[ZCRollingScrollView alloc] initWithFrame:self.view.frame];
    [scrollView setImgArray:imgArr];
    [self.view addSubview:scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
