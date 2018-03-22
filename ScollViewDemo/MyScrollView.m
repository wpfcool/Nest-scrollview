//
//  MyScrollView.m
//  ScollViewDemo
//
//  Created by wenpeifang on 2018/2/6.
//  Copyright © 2018年 wenpeifang. All rights reserved.
//

#import "MyScrollView.h"

@implementation MyScrollView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
