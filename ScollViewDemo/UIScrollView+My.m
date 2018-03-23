//
//  UIScrollView+My.m
//  ScollViewDemo
//
//  Created by wenpeifang on 2018/3/23.
//  Copyright © 2018年 wenpeifang. All rights reserved.
//

#import "UIScrollView+My.h"

@implementation UIScrollView (My)
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[self nextResponder] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self nextResponder] touchesEnded:touches withEvent:event];
}
@end
