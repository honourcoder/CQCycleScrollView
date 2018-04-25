//
//  CQCycleScrollView.h
//  testCycleScrollView
//
//  Created by CoderQi on 2018/4/23.
//  Copyright © 2018年 CoderQi. All rights reserved.
//


#import "UIView+CQExtension.h"

@implementation UIView (CQExtension)

- (CGFloat)cq_height
{
    return self.frame.size.height;
}

- (void)setCq_height:(CGFloat)cq_height
{
    CGRect temp = self.frame;
    temp.size.height = cq_height;
    self.frame = temp;
}

- (CGFloat)cq_width
{
    return self.frame.size.width;
}

- (void)setCq_width:(CGFloat)cq_width
{
    CGRect temp = self.frame;
    temp.size.width = cq_width;
    self.frame = temp;
}


- (CGFloat)cq_y
{
    return self.frame.origin.y;
}

- (void)setCq_y:(CGFloat)cq_y
{
    CGRect temp = self.frame;
    temp.origin.y = cq_y;
    self.frame = temp;
}

- (CGFloat)cq_x
{
    return self.frame.origin.x;
}

- (void)setCq_x:(CGFloat)cq_x
{
    CGRect temp = self.frame;
    temp.origin.x = cq_x;
    self.frame = temp;
}



@end
