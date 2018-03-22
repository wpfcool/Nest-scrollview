//
//  WebViewController.h
//  ScollViewDemo
//
//  Created by wenpeifang on 2018/2/6.
//  Copyright © 2018年 wenpeifang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property (nonatomic,assign)BOOL webviewCanScroll;

@property (nonatomic,strong)UIScrollView * currentScrollview;
@end
