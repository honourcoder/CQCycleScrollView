//
//  CQCycleScrollView.h
//  testCycleScrollView
//
//  Created by CoderQi on 2018/4/23.
//  Copyright © 2018年 CoderQi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CQColorCreater(r, g, b, a) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a]


@interface UIView (CQExtension)

@property (nonatomic, assign) CGFloat cq_height;
@property (nonatomic, assign) CGFloat cq_width;

@property (nonatomic, assign) CGFloat cq_y;
@property (nonatomic, assign) CGFloat cq_x;

@end
