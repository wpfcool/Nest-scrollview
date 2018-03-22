//
//  ViewController.m
//  ScollViewDemo
//
//  Created by wenpeifang on 2018/2/6.
//  Copyright © 2018年 wenpeifang. All rights reserved.
//

#import "ViewController.h"
#import <Masonry/Masonry.h>
#import "MyScrollView.h"
#import "WebViewController.h"
#import "LJDynamicItem.h"
static CGFloat rubberBandDistance(CGFloat offset, CGFloat dimension) {
    
    const CGFloat constant = 0.55f;
    CGFloat result = (constant * fabs(offset) * dimension) / (dimension + constant * fabs(offset));
    return offset < 0.0f ? -result : result;
}

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong)WebViewController * webVC;
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)UITableView * tableView;


@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, weak) UIDynamicItemBehavior *decelerationBehavior;
@property (nonatomic, strong) LJDynamicItem *dynamicItem;
@property (nonatomic, weak) UIAttachmentBehavior *springBehavior;




@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.edgesForExtendedLayout =  UIRectEdgeNone;
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
    _scrollView.scrollEnabled = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [_scrollView addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView.mas_height);
        make.width.equalTo(self.view.mas_width);
    }];
    
    
     _webVC = [[WebViewController alloc]init];
    _webVC.currentScrollview.scrollEnabled = NO;
    [self addChildViewController:_webVC];
    
    UIView * contentView = [[UIView alloc]init];
    contentView = _webVC.view;
    [_scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView.mas_height);
        make.width.equalTo(self.view.mas_width);
        make.top.equalTo(self.tableView.mas_bottom);
        make.bottom.equalTo(self.scrollView.mas_bottom);
    }];
    
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizerAction:)];
   pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.dynamicItem = [[LJDynamicItem alloc] init];
    
    
}

- (void)controlScrollForVertical:(CGFloat)detal AndState:(UIGestureRecognizerState)state {
    
    if(self.scrollView.contentOffset.y <= 0){
        //最上面
        //设置tableview contentoffsety
        
        CGFloat tableviewOffsetY = self.tableView.contentOffset.y - detal;
        if(tableviewOffsetY < 0){
            tableviewOffsetY = self.tableView.contentOffset.y - rubberBandDistance(detal,self.view.frame.size.height);
        }
       else if(tableviewOffsetY > (self.tableView.contentSize.height - self.tableView.bounds.size.height)){
            
            tableviewOffsetY = self.tableView.contentSize.height - self.tableView.bounds.size.height;
            //
            self.scrollView.contentOffset = CGPointMake(0, self.scrollView.contentOffset.y - detal);
        }
        self.tableView.contentOffset = CGPointMake(0, tableviewOffsetY);
        
    }
    else if(self.scrollView.contentOffset.y >0 && self.scrollView.contentOffset.y < self.scrollView.bounds.size.height){
        // scroll 滚动
       // 设置 scrollView contentoffsety
        CGFloat scrollviewOffsetY = self.scrollView.contentOffset.y - detal;

        self.scrollView.contentOffset = CGPointMake(0, scrollviewOffsetY);
    }else{
        
        NSLog(@"=======");
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.bounds.size.height);

        CGFloat webOffsetY = self.webVC.currentScrollview.contentOffset.y - detal;

        if(webOffsetY < 0){
          webOffsetY = 0;
            
            self.scrollView.contentOffset = CGPointMake(0, self.scrollView.contentOffset.y - detal);
        }

        
        if(webOffsetY > (self.webVC.currentScrollview.contentSize.height - self.webVC.currentScrollview.bounds.size.height)){
            webOffsetY = self.webVC.currentScrollview.contentOffset.y - rubberBandDistance(detal, self.view.bounds.size.height);
        }
        
        self.webVC.currentScrollview.contentOffset = CGPointMake(0, webOffsetY);
        
    }
    //添加依附
        BOOL outsideFrame = (self.tableView.contentOffset.y < 0 || self.webVC.currentScrollview.contentOffset.y > (self.webVC.currentScrollview.contentSize.height - self.webVC.currentScrollview.frame.size.height)) &&!(self.scrollView.contentOffset.y > 0 && self.scrollView.contentOffset.y < self.scrollView.bounds.size.height);
    
    if(outsideFrame && self.decelerationBehavior && !self.springBehavior){
                CGPoint target = CGPointZero;
                BOOL isMian = NO;
                if (self.tableView.contentOffset.y < 0) {
                    self.dynamicItem.center = self.tableView.contentOffset;
                    target = CGPointZero;
                    isMian = YES;
                } else if (self.webVC.currentScrollview.contentOffset.y > (self.webVC.currentScrollview.contentSize.height - self.webVC.currentScrollview.frame.size.height)) {
                    self.dynamicItem.center = self.webVC.currentScrollview.contentOffset;
                    target = CGPointMake(self.webVC.currentScrollview.contentOffset.x, (self.webVC.currentScrollview.contentSize.height - self.webVC.currentScrollview.frame.size.height));
                    isMian = NO;
                }
                [self.animator removeBehavior:self.decelerationBehavior];
                __weak typeof(self) weakSelf = self;
                UIAttachmentBehavior *springBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.dynamicItem attachedToAnchor:target];
                springBehavior.length = 0;
                springBehavior.damping = 1;
                springBehavior.frequency = 2;
                springBehavior.action = ^{
                    if (isMian) {
                        weakSelf.tableView.contentOffset = weakSelf.dynamicItem.center;
                        if (weakSelf.scrollView.contentOffset.y == 0) {
                        }
                    } else {
                        weakSelf.webVC.currentScrollview.contentOffset = self.dynamicItem.center;
                    }
                };
                [self.animator addBehavior:springBehavior];
                self.springBehavior = springBehavior;
    }
    
    
    
}
- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{
            [self.animator removeAllBehaviors];
        }
            break;
        case UIGestureRecognizerStateChanged:{
                CGFloat currentY = [recognizer translationInView:self.view].y;
                [self controlScrollForVertical:currentY AndState:UIGestureRecognizerStateChanged];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
                self.dynamicItem.center = self.view.bounds.origin;
                //velocity是在手势结束的时候获取的竖直方向的手势速度
                CGPoint velocity = [recognizer velocityInView:self.view];
                UIDynamicItemBehavior *inertialBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.dynamicItem]];
                [inertialBehavior addLinearVelocity:CGPointMake(0, velocity.y) forItem:self.dynamicItem];
                // 通过尝试取2.0比较像系统的效果
                inertialBehavior.resistance = 2.0;
                __block CGPoint lastCenter = CGPointZero;
                __weak typeof(self) weakSelf = self;
                inertialBehavior.action = ^{
                    //得到每次移动的距离
                    CGFloat currentY = weakSelf.dynamicItem.center.y - lastCenter.y;
                    [weakSelf controlScrollForVertical:currentY AndState:UIGestureRecognizerStateEnded];
                    
                    lastCenter = weakSelf.dynamicItem.center;
                };
                [self.animator addBehavior:inertialBehavior];
                self.decelerationBehavior = inertialBehavior;
        }
            break;
            
        default:
            break;
    }
    [recognizer setTranslation:CGPointZero inView:self.view];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",@(indexPath.row)];;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"====%ld",(long)indexPath.row);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
