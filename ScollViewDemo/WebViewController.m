//
//  WebViewController.m
//  ScollViewDemo
//
//  Created by wenpeifang on 2018/2/6.
//  Copyright © 2018年 wenpeifang. All rights reserved.
//

#import "WebViewController.h"
#import <Masonry/Masonry.h>
#import <WebKit/WebKit.h>
@interface WebViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)UIWebView * webView;
@property (nonatomic,assign)CGFloat webviewoffsety;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"kehuadong" object:nil];
//

    
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    _webView = [[UIWebView alloc]init];
    _webView.scrollView.scrollEnabled = NO;
    [self.view addSubview:_webView];

    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSData * ss = [NSData dataWithContentsOfFile:path options:0 error:nil];
    
    NSString * html = [[NSString alloc]initWithData:ss encoding:NSUTF8StringEncoding];
    
    _currentScrollview = _webView.scrollView;
//    NSURLRequest * request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
//    [_webView loadRequest:request];
    
    [_webView loadHTMLString:html baseURL:[NSURL URLWithString:@"about:blank"]];
    
    
    
//    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    button.backgroundColor = [UIColor redColor];
//    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//
//    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(100);
//        make.top.equalTo(self.view.mas_top).offset(100);
//        make.width.height.mas_equalTo(@100);
//
//    }];
}
-(void)click:(id)sender{
    NSLog(@"fff");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
