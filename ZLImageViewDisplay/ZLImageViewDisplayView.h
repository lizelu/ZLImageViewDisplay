//
//  ZLImageViewDisplayView.h
//  ZLImageViewDisplay
//
//  Created by Mr.LuDashi on 15/8/14.
//  Copyright (c) 2015年 ludashi. All rights reserved.
//

#import <UIKit/UIKit.h>

//点击图片的Block回调，参数当前图片的索引，也就是当前页数
typedef void(^TapImageViewButtonBlock)(NSInteger imageIndex);

@interface ZLImageViewDisplayView : UIView
@property (nonatomic, assign) CGFloat scrollInterval;               //切换图片的时间间隔，可选，默认为3s
@property (nonatomic, assign) CGFloat animationInterVale;           //运动时间间隔,可选，默认为0.7s
@property (nonatomic, strong) NSArray *imageViewArray;              //图片数组

/**********************************
 *功能：便利构造器
 *参数：滚动视图的Frame
 *返回值：该类的对象
 **********************************/
+ (instancetype) zlImageViewDisplayViewWithFrame: (CGRect) frame;

/**********************************
 *功能：便利初始化函数
 *参数：滚动视图的Frame
 *返回值：该类的对象
 **********************************/
- (instancetype)initWithFrame: (CGRect)frame;

/**********************************
 *功能：为每个图片添加点击时间
 *参数：点击按钮要执行的Block
 *返回值：无
 **********************************/
- (void) addTapEventForImageWithBlock: (TapImageViewButtonBlock) block;

@end
