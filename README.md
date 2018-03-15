
# 效果演示：
![image](https://github.com/LMMIsGood/LiuqsEmoticonkeyboard/blob/master/LiuqsEmoticonkeyboard/ExhibitionImages/%E6%BC%94%E7%A4%BA.gif)
![image](https://github.com/LMMIsGood/LiuqsEmoticonkeyboard/blob/master/LiuqsEmoticonkeyboard/ExhibitionImages/%E6%BC%94%E7%A4%BA2.gif)
![image](https://github.com/LMMIsGood/LiuqsEmoticonkeyboard/blob/master/LiuqsEmoticonkeyboard/ExhibitionImages/%E6%BC%94%E7%A4%BA3.PNG)

简单集成键盘方法：
```
self.keyboard = [LiuqsEmoticonKeyBoard showKeyBoardInView:self.view];
self.keyboard.delegate = self;  
```
想要集成到你的项目中需要做如下操作：

1.把YYTextClasses和LiuqsEmitionClasses两个文件夹下的文件拖拽到你的项目中！

2.修改工程pch文件地址，或者将LiuqsKeyBoardHeader.pch文件下的宏定义和头文件复制到自己工程的pch文件中；

3.因为使用了YYText,需要添加依赖库：`UIKit.framework，CoreFoundation.framework，CoreText.framework，QuartzCore.framework，Accelerate.framework，MobileCoreServices.framework，libz.tbd`

4.编译运行.

具体详细的介绍请看简书文章：[简书地址](http://www.jianshu.com/p/d30be01c858f)
