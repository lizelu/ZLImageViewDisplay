# ZLImageViewDisplay
iOS图片轮播
　　经常有园友会问"博主，有没有图片无限滚动的Demo呀？"， 正儿八经的图片滚动的Demo我这儿还真没有，今天呢就封装一个可以在项目中直接使用的图片轮播。没看过其他iOS图片无限轮播的代码，也不了解他们的原理，我今天封装这个图片无限轮播是借鉴Web前端中的做法，因为之前写Web前端的时候，实现幻灯片就是这么做的，今天就在iPhone上搞搞。下面的东西是自己写的了，关于轮播的东西这个开源项目也是相当不错的https://github.com/nicklockwood/iCarousel ,感兴趣的可以看一下。那是相当的强大，虽然没必要重复造轮子但是原理还是有必要理解的。今天的博客就介绍图片轮播的一种解决方案，下篇博客中在介绍另一种图片轮播的解决方案。

　　一、Demo运行效果、原理及调用方式

　　　　1.运行效果

　　　　下面的GIF呢就是Demo的运行效果，一定间隔后，图片会自动切换，当然也支持手指滑动。切换到相应图片时，点击图片，会通过Block回调的方式给出该图片的Index, 在Demo中使用提示框给出Index, 当然在项目中拿到Index你可以做很多事情的，Index就是图片的Tag值，也就是标记着你点击的是那张图片。下图中是三张图片进行轮播。



　　2.原理

　　下面是实现图片无限轮播的原理图（借鉴Web前端幻灯片的写法，欢迎大家提出好的解决方案），原理用一句话概括：如果显示3张图片的话，就往ScrollView上贴4张图顺序是3-1-2-3。首次显示1的位置，然后滑动，等滑动到最后一个3时，无动画切换到第一个3的位置，然后在滚动。原理图如下，就可以按着下面的原理图来布局和实例化控件了。



　　3.组件调用方式

　　　　下面这段代码是组件的初始化和属性的设置，分为如下几部：

　　　　　　（1）：确定组件的位置

　　　　　　（2）：生成图片名字数组

　　　　　　（3）：通过便利构造器初始化控件，并传入imageName数组

　　　　　　（4）：设置属性（可选）， scrollInterval-图片切换间隔，animationInterVale-图片运动时间

　　　　　　（5）：addTapEventForImageWithBlock：图片点击后的回调

 1 -(void) addZLImageViewDisPlayView{
 2     
 3     //获取要显示的位置
 4     CGRect screenFrame = [[UIScreen mainScreen] bounds];
 5     
 6     CGRect frame = CGRectMake(10, 60, screenFrame.size.width - 20, 200);
 7     
 8     NSArray *imageArray = @[@"01.jpg", @"02.jpg", @"03.jpg"];
 9     
10     //初始化控件
11     ZLImageViewDisplayView *imageViewDisplay = [ZLImageViewDisplayView zlImageViewDisplayViewWithFrame:frame WithImages:imageArray];
12     
13     //设定轮播时间
14     imageViewDisplay.scrollInterval = 2;
15     
16     //图片滚动的时间
17     imageViewDisplay.animationInterVale = 0.6;
18     
19     //把该视图添加到相应的父视图上
20     [self.view addSubview:imageViewDisplay];
21     
22     [imageViewDisplay addTapEventForImageWithBlock:^(NSInteger imageIndex) {
23         NSString *str = [NSString stringWithFormat:@"我是第%ld张图片", imageIndex];
24         UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
25         [alter show];
26     }];
27     
28 }
 

　　二、核心代码介绍

　　　　1.组件的便利初始化方法如下，传入的参数是组件的frame, 和要显示的图片名字数组。在便利初始化方法中初始化一些属性和调用相关初始化方法。初始化内容如下：

 1 #pragma -- mark 遍历初始化方法
 2 - (instancetype)initWithFrame: (CGRect)frame
 3                WithImages: (NSArray *) images
 4 {
 5     self = [super initWithFrame:frame];
 6     if (self) {
 7         //获取滚动视图的宽度
 8         _widthOfView = frame.size.width;
 9         
10         //获取滚动视图的高度
11         _heightView = frame.size.height;
12         
13         _scrollInterval = 3;
14         
15         _animationInterVale = 0.7;
16         
17         //当前显示页面
18         _currentPage = 1;
19         
20         _imageViewcontentModel = UIViewContentModeScaleAspectFill;
21         
22         self.clipsToBounds = YES;
23         
24         //初始化滚动视图
25         [self initMainScrollView];
26         
27         //添加ImageView
28         [self addImageviewsForMainScrollWithImages:images];
29         
30         //添加timer
31         [self addTimerLoop];
32         
33         [self addPageControl];
34         
35     }
36     return self;
37 }
 

　　　　2.便利构造器

　　　　为我们的组件添加上便利构造器，便利构造器当然是类方法了，传的参数和便利初始化方法一样，该方法主要就是类的初始化，然后调用便利初始化方法， 并返回类的对象。代码如下：

#pragma -- 便利构造器
+ (instancetype) zlImageViewDisplayViewWithFrame: (CGRect) frame
                                      WithImages: (NSArray *) images{
    ZLImageViewDisplayView *instance = [[ZLImageViewDisplayView alloc] initWithFrame:frame WithImages:images];
    return instance;
}
 

　　　　3.初始化ScrollView

　　　　往我们自定义组件视图上添加ScrollView, ScrollView的的大小和我们自定义组件的大小一样，并且设置相关属性，设置代理方法，代码如下：

 1 #pragma -- mark 初始化ScrollView
 2 - (void) initMainScrollView{
 3     
 4     _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _widthOfView, _heightView)];
 5     
 6     _mainScrollView.contentSize = CGSizeMake(_widthOfView, _heightView);
 7     
 8     _mainScrollView.pagingEnabled = YES;
 9     
10     _mainScrollView.showsHorizontalScrollIndicator = NO;
11     
12     _mainScrollView.showsVerticalScrollIndicator = NO;
13     
14     _mainScrollView.delegate = self;
15     
16     [self addSubview:_mainScrollView];
17 }
 

　　　　4.添加PageControl

　　　　　　初始化PageControl, 配置相关属性，并添加到我们的自定义组件上，代码如下：

 1 #pragma 添加PageControl
 2 - (void) addPageControl{
 3     _imageViewPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _heightView - 20, _widthOfView, 20)];
 4     
 5     _imageViewPageControl.numberOfPages = _imageViewArray.count;
 6     
 7     _imageViewPageControl.currentPage = _currentPage - 1;
 8     
 9     _imageViewPageControl.tintColor = [UIColor blackColor];
10     
11     [self addSubview:_imageViewPageControl];
12 }
 

　　　　5.添加ImageView和Image

　　　　往ScrollView上添加ImageView和Image, 下面这个方法也是核心代码，我们根据是第几张图片来计算图片的Frame进行布局，每张图片的大小就是我们组件的大小，根据上面原理的介绍，ScrollView上的第一张图片和最后一张图片一样，你想显示的第一张图片放到ScrollView上的第二张，并改变Scollview的Contentoffset显示ScrollView上的第二张图片，代码如下：

 1 #pragma -- mark 给ScrollView添加ImageView
 2 -(void) addImageviewsForMainScrollWithImages: (NSArray *) images{
 3     //设置ContentSize
 4     _mainScrollView.contentSize = CGSizeMake(_widthOfView * (images.count+1), _heightView);
 5     
 6     _imageViewArray = images;
 7     
 8     for ( int i = 0; i < _imageViewArray.count + 1; i ++) {
 9         
10         CGRect currentFrame = CGRectMake(_widthOfView * i, 0, _widthOfView, _heightView);
11         
12         UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:currentFrame];
13         
14         tempImageView.contentMode = _imageViewcontentModel;
15         
16         tempImageView.clipsToBounds = YES;
17         
18         NSString *imageName;
19         
20         if (i == 0) {
21             imageName = [_imageViewArray lastObject];
22         } else {
23             imageName = _imageViewArray[i - 1];
24         }
25         
26         UIImage *imageTemp = [UIImage imageNamed:imageName];
27         [tempImageView setImage:imageTemp];
28         
29         [_mainScrollView addSubview:tempImageView];
30     }
31     
32     _mainScrollView.contentOffset = CGPointMake(_widthOfView, 0);
33     
34 }
　　　　

　　　　6.添加定时器

　　　　想让图片自己动起来，是少不了定时器的，为我们的组件添加定时器，下面的方法就是初始化定时器方法：

1 - (void) addTimerLoop{
2     
3     if (_timer == nil) {
4         _timer = [NSTimer scheduledTimerWithTimeInterval:_scrollInterval target:self selector:@selector(changeOffset) userInfo:nil repeats:YES];
5     }
6 }
　　　　

　　　　7.定时器执行的方法

　　　　下面的方法就是定时器执行的方法，当时间到时，自动改变ScrollView的ContentOffset.x的值，有动画的切换到下一张图片。如果目前是最后一张图片则无动画的切换到ScrollView的第一张图片，因为第一张图片和最后一张图片是一样的，所以用户看不到这个无动画的切换，切换后，图片有开始从第一个开始滚动，所以就可以无限循环的滚动了，下面也是核心代码：

 1 -(void) changeOffset{
 2     
 3     _currentPage ++;
 4     
 5     if (_currentPage == _imageViewArray.count + 1) {
 6         _currentPage = 1;
 7     }
 8     
 9     [UIView animateWithDuration:_animationInterVale animations:^{
10         _mainScrollView.contentOffset = CGPointMake(_widthOfView * _currentPage, 0);
11     } completion:^(BOOL finished) {
12         if (_currentPage == _imageViewArray.count) {
13             _mainScrollView.contentOffset = CGPointMake(0, 0);
14         }
15     }];
16     
17      _imageViewPageControl.currentPage = _currentPage - 1;
18     
19 }
 

　　　　8.手动切换

　　　　上面介绍的是使用NSTimer来实现自动切换，那么如何让组件支持手动切换呢？ 要支持手动切换就得在我们ScrollView的回调中进行处理了。在用户手动滑动后的方法中去做我们要做的事情，也就是判断是不是最后一张图片，然后在暂停一下定时器即可，对应的回调方法如下：

 1 - (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
 2     NSInteger currentPage = scrollView.contentOffset.x / _widthOfView;
 3     
 4     if(currentPage == 0){
 5         _mainScrollView.contentOffset = CGPointMake(_widthOfView * _imageViewArray.count, 0);
 6         _imageViewPageControl.currentPage = _imageViewArray.count;
 7         _currentPage = _imageViewArray.count;
 8     }
 9     
10     if (_currentPage + 1 == currentPage || currentPage == 1) {
11         _currentPage = currentPage;
12         
13         if (_currentPage == _imageViewArray.count + 1) {
14             _currentPage = 1;
15         }
16         
17         if (_currentPage == _imageViewArray.count) {
18             _mainScrollView.contentOffset = CGPointMake(0, 0);
19         }
20         
21         _imageViewPageControl.currentPage = _currentPage - 1;
22         [self resumeTimer];
23         return;
24     }
25     
26     
27 }
 

　　　　9.暂停定时器

　　　　手动滑动后要暂停定时器一段时间，因为不暂停的话，你手动切换完，有时会立刻切换到下一张图片，下面是暂停定时器的方法，然后在过一段时间后自动激活定时器。方法如下

 1 #pragma 暂停定时器
 2 -(void)resumeTimer{
 3     
 4     if (![_timer isValid]) {
 5         return ;
 6     }
 7     
 8     [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_scrollInterval-_animationInterVale]];
 9     
10 }
 

　　　　经过上面的这些代码组件就可以被调用了，你的图片就可以使用了，最后在给出该组件留出的对外接口：

 1 //
 2 //  ZLImageViewDisplayView.h
 3 //  ZLImageViewDisplay
 4 //
 5 //  Created by Mr.LuDashi on 15/8/14.
 6 //  Copyright (c) 2015年 ludashi. All rights reserved.
 7 //
 8 
 9 #import <UIKit/UIKit.h>
10 
11 //点击图片的Block回调，参数当前图片的索引，也就是当前页数
12 typedef void(^TapImageViewButtonBlock)(NSInteger imageIndex);
13 
14 @interface ZLImageViewDisplayView : UIView
15 
16 
17 //切换图片的时间间隔，可选，默认为3s
18 @property (nonatomic, assign) CGFloat scrollInterval;
19 
20 //切换图片时，运动时间间隔,可选，默认为0.7s
21 @property (nonatomic, assign) CGFloat animationInterVale;
22 
23 /**********************************
24  *功能：便利构造器
25  *参数：滚动视图的Frame, 要显示图片的数组
26  *返回值：该类的对象
27  **********************************/
28 + (instancetype) zlImageViewDisplayViewWithFrame: (CGRect) frame
29                                       WithImages: (NSArray *) images;
30 
31 /**********************************
32  *功能：便利初始化函数
33  *参数：滚动视图的Frame, 要显示图片的数组
34  *返回值：该类的对象
35  **********************************/
36 - (instancetype)initWithFrame: (CGRect)frame
37                    WithImages: (NSArray *) images;
38 
39 
40 
41 /**********************************
42  *功能：为每个图片添加点击时间
43  *参数：点击按钮要执行的Block
44  *返回值：无
45  **********************************/
46 - (void) addTapEventForImageWithBlock: (TapImageViewButtonBlock) block;
47 
48 @end
 

　　

　　三.组件和Demo分享

　　　　下面给出了Demo和组件在GitHub上的分享地址：

　　　　https://github.com/lizelu/ZLImageViewDisplay 

 

　　上面的Demo是图片轮播的解决方案之一，下篇博客会使用两个ImageView复用的形式来实现图片的无限轮播的解决方案。Demo写的比较着急，难免会有纰漏的地方，望大家批评指正。
