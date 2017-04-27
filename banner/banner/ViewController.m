//
//  ViewController.m
//  banner
//
//  Created by SunGuoYan on 2017/4/26.
//  Copyright © 2017年 SunGuoYan. All rights reserved.
//

#import "ViewController.h"

#define screenH [[UIScreen mainScreen] bounds].size.height
#define screenW [[UIScreen mainScreen] bounds].size.width

@interface ViewController ()<UIScrollViewDelegate>
{
    UIScrollView *scroll;
    UIPageControl *page;
}
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation ViewController

-(NSMutableArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray=[[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    NSArray *array=@[@"ad_01",@"ad_02",@"ad_03",@"ad_04",@"ad_05"];
    self.dataArray=[NSMutableArray arrayWithArray:array];
    
    [self creatScrollView];
}

-(void)creatScrollView{
    //关闭此属性，消除导航控制器对滚动视图的影响
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //1.scroll
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, screenW, 100)];
    scroll.delegate = self;
    scroll.backgroundColor = [UIColor yellowColor];
    scroll.showsVerticalScrollIndicator=NO;
    scroll.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:scroll];
    
    NSInteger total=self.dataArray.count;
    
    for (int i = 0; i<(total+2); i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*screenW, 0, screenW, 100)];
        
        if (i==0) {//5
            imageView.image = [UIImage imageNamed:[self.dataArray lastObject]];
        }else if (i==(total+1)){//1
            imageView.image = [UIImage imageNamed:[self.dataArray firstObject]];
        }else{
            imageView.image = [UIImage imageNamed:self.dataArray[i-1]];
        }
        
        [scroll addSubview:imageView];
    }
    
    //设置滚动范围
    scroll.contentSize = CGSizeMake((self.dataArray.count+2)*screenW, 0);
    scroll.pagingEnabled = YES;
    scroll.contentOffset = CGPointMake(screenW, 0);
    
    //2.page
    page = [[UIPageControl alloc] initWithFrame:CGRectMake(100, 100, 150, 30)];
    
    page.numberOfPages = self.dataArray.count;
    page.pageIndicatorTintColor = [UIColor greenColor];
    page.currentPageIndicatorTintColor = [UIColor redColor];
    
    page.currentPage = 0;
    page.tag = 100;
    [self.view addSubview:page];
    
    //3.NSTimer
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(autoMove) userInfo:nil repeats:YES];
}

-(void)autoMove
{
    [UIView animateWithDuration:0.5 animations:^{
        scroll.contentOffset=CGPointMake(scroll.contentOffset.x+screenW, 0);
    }];
    
    if (scroll.contentOffset.x==screenW*(self.dataArray.count+1)) {
        scroll.contentOffset=CGPointMake(screenW, 0);
    }
    if (scroll.contentOffset.x==0) {
        scroll.contentOffset=CGPointMake(screenW*self.dataArray.count, 0);
    }
    page.currentPage=scroll.contentOffset.x/screenW-1;
}

#pragma  mark --- UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger total=self.dataArray.count;
    
    if (scrollView.contentOffset.x==screenW*(total+1)) {
        scrollView.contentOffset=CGPointMake(screenW, 0);
    }
    
    if (scrollView.contentOffset.x==0) {
        scrollView.contentOffset=CGPointMake(screenW*total, 0);
    }
    
    page.currentPage=scrollView.contentOffset.x/screenW-1;
}
//不可以用下面这个代理方法，会有视觉上拖动的bug
/*
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger total=self.dataArray.count;
    
    if (scrollView.contentOffset.x==screenW*(total+1)) {
        scrollView.contentOffset=CGPointMake(screenW, 0);
    }
    
    if (scrollView.contentOffset.x==0) {
        scrollView.contentOffset=CGPointMake(screenW*total, 0);
    }
    
    page.currentPage=scrollView.contentOffset.x/screenW-1;
}
*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
