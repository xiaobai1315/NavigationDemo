//
//  ViewController.m
//  HJNavigationBarDemo
//
//  Created by Jermy on 2018/5/14.
//  Copyright © 2018年 Jermy. All rights reserved.
//

#import "ViewController.h"
#define screenW ([UIScreen mainScreen].bounds.size.width)
#define screenH ([UIScreen mainScreen].bounds.size.height)
#define imageH screenH * 0.4

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ViewController
{
    CGFloat tableViewOffsetY;
    UIView *alphaView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 100;
    _tableView.contentInset = UIEdgeInsetsMake(imageH - 64, 0, 0, 0);
    [self.view addSubview:_tableView];

    _imageView = [[UIImageView alloc] init];
    _imageView.frame = CGRectMake(0, -imageH, screenW, imageH);
    _imageView.image = [UIImage imageNamed:@"1.jpeg"];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [_tableView addSubview:_imageView];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"更多" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 80, 40);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //隐藏导航栏
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    //添加自定义状态栏
    CGRect frame = self.navigationController.navigationBar.frame;
    alphaView = [[UIView alloc] init];
    alphaView.frame = CGRectMake(0, -20, screenW, frame.size.height + 20);
    [self.navigationController.navigationBar insertSubview:alphaView atIndex:0];
    alphaView.backgroundColor = [UIColor blueColor];
    alphaView.alpha = 0;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    tableViewOffsetY = self.tableView.contentOffset.y;
    self.navigationController.navigationBar.tintColor = [UIColor greenColor];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= -80) {
        if (alphaView.alpha != 1) {
            NSLog(@"----change alpha");
            [UIView animateWithDuration:0.3 animations:^{
                alphaView.alpha = 1;
            }];
        }
    }else if (scrollView.contentOffset.y < -80) {
        if (alphaView.alpha != 0) {
            NSLog(@"+++++change alpha");
            [UIView animateWithDuration:0.3 animations:^{
                alphaView.alpha = 0;
            }];
        }
    }

    _imageView.frame = CGRectMake(0, scrollView.contentOffset.y, screenW, -scrollView.contentOffset.y);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"cell --- %d", indexPath.row];
    return cell;
}


@end
