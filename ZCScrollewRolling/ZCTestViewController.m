//
//  ZCTestViewController.m
//  ZCScrollewRolling
//
//  Created by For_Minho on 15/4/18.
//  Copyright (c) 2015年 For_Minho. All rights reserved.
//

#import "ZCTestViewController.h"

@interface ZCTestViewController ()
@property (nonatomic, strong) UISegmentedControl *segment;
@end

@implementation ZCTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _segment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"push",@"pre", nil]];
    _segment.selectedSegmentIndex = 0;
    [_segment addTarget:self action:@selector(segmentClicked:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_segment];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)pushToScrollViewCon:(NSInteger)count
{
    NSMutableArray *imgArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 5; i <= count + 5; i ++) {
        NSString *imgName = [NSString stringWithFormat:@"IMG_338%lu",(long)i];
        UIImage *img = [UIImage imageNamed:imgName];
        [imgArr addObject:img];
    }

    ZCRollingScrollView *roolView = [[ZCRollingScrollView alloc] init];
    roolView.imgArray = imgArr;
    if (_segment.selectedSegmentIndex == 1) {
        UINavigationController *con  = [[UINavigationController alloc] initWithRootViewController:roolView];
        [self presentViewController:con animated:YES completion:nil];
        return;
    }
    [self.navigationController pushViewController:roolView animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (_segment.selectedSegmentIndex == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"index_%lu",(long)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushToScrollViewCon:indexPath.row];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)segmentClicked:(UISegmentedControl *)segment
{
    [self.tableView reloadData];
    NSLog(@"%d",segment.selectedSegmentIndex);
}
@end
