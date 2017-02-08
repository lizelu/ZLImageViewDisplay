# ZLImageViewDisplay
#iOS图片轮播
　　
　　经常有园友会问"博主，有没有图片无限滚动的Demo呀？"， 正儿八经的图片滚动的Demo我这儿还真没有，今天呢就封装一个可以在项目中直接使用的图片轮播。没看过其他iOS图片无限轮播的代码，也不了解他们的原理，我今天封装这个图片无限轮播是借鉴Web前端中的做法，因为之前写Web前端的时候，实现幻灯片就是这么做的，今天就在iPhone上搞搞。下面的东西是自己写的了，关于轮播的东西这个开源项目也是相当不错的https://github.com/nicklockwood/iCarousel ,感兴趣的可以看一下。那是相当的强大，虽然没必要重复造轮子但是原理还是有必要理解的。今天的博客就介绍图片轮播的一种解决方案，下篇博客中在介绍另一种图片轮播的解决方案。

　　一、Demo运行效果、原理及调用方式

　　　　1.运行效果
    ![](http://images0.cnblogs.com/blog2015/545446/201508/191042195356334.gif)

　　　　下面的GIF呢就是Demo的运行效果，一定间隔后，图片会自动切换，当然也支持手指滑动。切换到相应图片时，点击图片，会通过Block回调的方式给出该图片的Index, 在Demo中使用提示框给出Index, 当然在项目中拿到Index你可以做很多事情的，Index就是图片的Tag值，也就是标记着你点击的是那张图片。下图中是三张图片进行轮播。



　　2.原理
  ![](http://images0.cnblogs.com/blog2015/545446/201508/191105005504432.png)

　　下面是实现图片无限轮播的原理图（借鉴Web前端幻灯片的写法，欢迎大家提出好的解决方案），原理用一句话概括：如果显示3张图片的话，就往ScrollView上贴4张图顺序是3-1-2-3。首次显示1的位置，然后滑动，等滑动到最后一个3时，无动画切换到第一个3的位置，然后在滚动。原理图如下，就可以按着下面的原理图来布局和实例化控件了。


　　上面的Demo是图片轮播的解决方案之一，下篇博客会使用两个ImageView复用的形式来实现图片的无限轮播的解决方案。Demo写的比较着急，难免会有纰漏的地方，望大家批评指正。
