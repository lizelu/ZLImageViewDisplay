//
//  ViewController.m
//  ZLImageViewDisplay
//
//  Created by Mr.LuDashi on 15/8/14.
//  Copyright (c) 2015年 ludashi. All rights reserved.
//

#import "ViewController.h"

#import "ZLImageViewDisplayView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addZLImageViewDisPlayView];
}

-(void) addZLImageViewDisPlayView{
    
    //获取要显示的位置
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    
    CGRect frame = CGRectMake(10, 60, screenFrame.size.width - 20, 200);
    
    NSArray *imageArray = @[@"01.jpg", @"02.jpg", @"03.jpg"];
    
    //初始化控件
    ZLImageViewDisplayView *imageViewDisplay = [ZLImageViewDisplayView zlImageViewDisplayViewWithFrame:frame WithImages:imageArray];
    
    //设定轮播时间
    imageViewDisplay.scrollInterval = 2;
    
    //图片滚动的时间
    imageViewDisplay.animationInterVale = 0.6;
    
    //把该视图添加到相应的父视图上
    [self.view addSubview:imageViewDisplay];
    
    [imageViewDisplay addTapEventForImageWithBlock:^(NSInteger imageIndex) {
        NSString *str = [NSString stringWithFormat:@"我是第%ld张图片", imageIndex];
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alter show];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
