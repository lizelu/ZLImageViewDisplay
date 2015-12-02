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
    
    NSArray *imageArray = @[@"001.jpg", @"002.jpg", @"003.jpg", @"004.jpg", @"005.jpg", @"http://pic1.nipic.com/2008-12-25/2008122510134038_2.jpg"];
    
    //初始化控件
    ZLImageViewDisplayView *imageViewDisplay = [ZLImageViewDisplayView zlImageViewDisplayViewWithFrame:frame];
    imageViewDisplay.imageViewArray = imageArray;
    imageViewDisplay.scrollInterval = 3;
    imageViewDisplay.animationInterVale = 0.6;
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
