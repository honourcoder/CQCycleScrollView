//
//  ViewController.m
//  testCycleScrollView
//
//  Created by CoderQi on 2018/4/23.
//  Copyright © 2018年 CoderQi. All rights reserved.
//

#import "ViewController.h"
#import "CQCycleScrollView.h"
#import "Masonry.h"

@interface ViewController ()
@property(nonatomic, strong)UIView *clickView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CQCycleScrollView *sc = [CQCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width/2) delegate:self placeholderImage:[UIImage imageNamed:@"占位图"]];
    sc.imageUrlStringGroup = @[@"http://img.kaku.henkuai.com/o_1cbba5fgl1q5q1cmls1b52f1318.jpg",
                               @"http://img.kaku.henkuai.com/o_1cbbjrepnh3695q3aa4dc7f8.jpg",
                               @"http://img.kaku.henkuai.com/o_1cbbnogpq2fcu2hpu61aokte78.jpg",
                               @"http://img.kaku.henkuai.com/o_1cbbrhf2k19iq1nd0g795cp1en18.jpg",
                               @"http://img.kaku.henkuai.com/o_1cbca83ve1php7ho13roalnaig8.jpg"];
    sc.titleGroup = @[@"杭州大力扶持区块链，区块链企业获千万融资称标配",
                      @"全球普惠区块链峰会 此次区块链大会 全方位呈现和记录“区块链”",
                      @"如出一辙？探究郁金香狂热起源与现代加密货币泡沫论",
                      @"一座区块链庄园也证明了区块链的市场",
                      @"澳门：虚拟货币不是法币而是虚拟商品，提醒市民注意风险"];
    [self.view addSubview:sc];
    
//
//    UIView *view = [[UIView alloc]init];
//    view.backgroundColor = [UIColor orangeColor];
//    [self.view addSubview:view];
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(@10);
//        make.left.mas_equalTo(@10);
//        make.width.mas_equalTo(@300);
//        make.height.mas_equalTo(@400);
//    }];
//    self.clickView = view;
//    
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
//    [self.view addSubview:button];
//    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(view.mas_bottom);
//        make.left.mas_equalTo(view.mas_left);
//        make.width.mas_equalTo(@100);
//        make.height.mas_equalTo(@50);
//    }];
//    [button setTitle:@"dianji" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view, typically from a nib.
}

//-(void)action{
//    [self.clickView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(@600);
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
