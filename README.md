
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

######更新：
```
1.解决首次加载键盘卡顿的问题；
2.修改聊天布局方式，现在无需计算，更加顺畅。
```
######前言：
之前做过[【OC版本】](http://www.jianshu.com/p/19c3c8425e66)和[【swift版本】](http://www.jianshu.com/p/72c8c2ebd0ae)图文混排和表情键盘，说实在的很low，特别是键盘，整体只是实现了效果并没有封装，很难集成使用！而且之前是使用的附件做的并不支持gif表情，我尝试各种方法，想实现类似qq的丝滑gif表情体验，真的不容易；经过各种尝试和努力最终基于[【YYText】](https://github.com/ibireme/YYText)实现了类似qq的gif表情聊天方案，大量的表情也不会卡顿！而且这次的键盘做了比较全面的封装集成起来很方便！


####接下来介绍主要的几个类，包括类的用法、内部的具体实现以及一些细节：
1. `LiuqsEmoticonKeyBoard` 表情键盘的实体类 ：

```
键盘的代理：
@protocol LiuqsEmotionKeyBoardDelegate <NSObject>
/*
 * 发送按钮的代理事件
 * 参数PlainStr: 转码后的textView的普通字符串
 */
- (void)sendButtonEventsWithPlainString:(NSString *)PlainStr;

/*
 * 代理方法：键盘改变的代理事件
 * 用来更新父视图的UI，比如跟随键盘改变的列表高度
 */
- (void)keyBoardChanged;

@end
```
```
/*
 * 输入框，和topbar上的是同一个输入框
 */
@property(nonatomic, strong) UITextView *textView;
/*
 * 顶部输入条
 */
@property(nonatomic, strong) LiuqsTopBarView *topicBar;
/* 
 * 输入框字体，用来计算表情的大小
 */
@property(nonatomic, strong) UIFont *font;
/*
 * 键盘的代理
 */
@property(nonatomic, weak) id <LiuqsEmotionKeyBoardDelegate> delegate;
/*
 * 收起键盘的方法
 */
- (void)hideKeyBoard;
/*
 * 初始化方法
 * 参数view必须传入控制器的视图
 * 会返回一个键盘的对象
 * 默认是给17号字体
 */
+ (instancetype)showKeyBoardInView:(UIView *)view;
```
2.`LiuqsEmotionPageView`键盘的分页类用来放表情按钮，内部主要处理按所在行列位置的计算,需要给出当前是第几页，用来加载表情：

```
/*
 * 当前page的页数
 */
@property(nonatomic, assign) NSUInteger page;
/*
 * 表情按钮的回调事件
 * 参数button是当前点击按钮的对象
 */
@property(nonatomic, copy)void (^emotionButtonClick)(LiuqsButton *button);
/*
 * 键盘上删除按钮的回调事件
 * 参数button是当前点击的删除按钮
 */
@property(nonatomic, copy)void (^deleteButtonClick)(LiuqsButton *button);

```
3.`LiuqsKeyBoardHeader`全局宏定义的类。

4.`LiuqsTopBarView`键盘上输入框和一些切换按钮的实体类，这个可以根据需求自定义：
```
topBar的代理：
@protocol LiuqsTopBarViewDelegate <NSObject>
/*
 * 代理方法，点击表情按钮触发方法
 */
- (void)TopBarEmotionBtnDidClicked:(UIButton *)emotionBtn;
/*
 * 代理方法 ，点击数字键盘发送的事件
 */
- (void)sendAction;
/*
 * 键盘改变刷新父视图
 */
- (void)needUpdateSuperView;

@end
```
```
/*
 * 声明topbar代理
 */
@property(assign,nonatomic)id <LiuqsTopBarViewDelegate> delegate;
/*
 * topbar上面的输入框
 */
@property(strong,nonatomic)UITextView *textView;
/*
 * 表情按钮
 */
@property(nonatomic, strong) UIButton *topBarEmotionBtn;
/*
 * 当前键盘的高度， 区分是文字键盘还是表情键盘
 */
@property(nonatomic, assign) CGFloat CurrentKeyBoardH;
/*
 * 用于主动触发输入框改变的方法
 */
- (void)resetSubsives;
```
5.`LiuqsButton`键盘上的表情按钮，自定义是为了更好的和图片一一对应，更容易处理。

6.`NSAttributedString+LiuqsExtension`富文本的分类：

```
- (NSString *)getPlainString {
    
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    __block NSUInteger base = 0;
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(LiuqsTextAttachment *value, NSRange range, BOOL *stop) {
                      if (value) {
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:value.emojiTag];
                          base += value.emojiTag.length - 1;
                      }
                  }];
    return plainString;
}

```
`getPlainString`方法主要是通过遍历富文本中的附件（在这里是指表情图片）并使用普通的字符串（比如：[大笑]）替换，得到普通的字符串编码，拿字符串编码去通讯，比如调用接口发消息；
举个栗子：
转换过的字符串是这样滴：`好害羞[害羞]！`
用来展示的效果是这样滴：
![示例.png](http://upload-images.jianshu.io/upload_images/2546003-ecfb9e2406d3b203.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

7.`LiuqsTextAttachment`自定义附件类，继承于NSTextAttachment。

####上边这7个类主要是键盘部分的，或者说输入部分，就是用来拿数据和别的端交互；接下来是转码部分或者说是输出部分，就是负责拿到别人给的编码来转换成富文本展示给用户看！

***

8.`LiuqsDecoder`转码的核心类：


主要方法：
```
/*
 * 转码方法，把普通字符串转为富文本字符串（包含图片文字等）
 * 参数 font 是用来展示的字体大小
 * 参数 plainStr 是普通的字符串
 * 返回值：用来展示的富文本，直接复制给label展示
 */
+ (NSMutableAttributedString *)decodeWithPlainStr:(NSString *)plainStr font:(UIFont *)font;

```
详细说一下内部的实现：
首先是静态属性：
```
//表情的size
static CGSize                    _emotionSize;
//文本的字体
static UIFont                    *_font;
//文本的颜色
static UIColor                   *_textColor;
//正则匹对结果数组
static NSArray                   *_matches;
//需要转码的普通字符串
static NSString                  *_string;
//通过plist加载的对照表：[害羞] <-> 害羞图片
static NSDictionary              *_emojiImages;
//存放图片对应range的字典数组
static NSMutableArray            *_imageDataArray;
//全局的富文本
static NSMutableAttributedString *_attStr;
//最终要返回的结果，是一个富文本
static NSMutableAttributedString *_resultStr;
```
```
+ (NSMutableAttributedString *)decodeWithPlainStr:(NSString *)plainStr font:(UIFont *)font {

    if (!plainStr) {return [[NSMutableAttributedString alloc]initWithString:@""];}else {
        
        _font      = font;
        _string    = plainStr;
        _textColor = [UIColor blackColor];
        [self initProperty];
        [self executeMatch];
        [self setImageDataArray];
        [self setResultStrUseReplace];
        return _resultStr;
    }
}
```
```
在这个方法里主要初始化对照表，以及根据字体计算表情的尺寸
+ (void)initProperty {
    
    // 读取并加载对照表
    NSString *path = [[NSBundle mainBundle] pathForResource:@"LiuqsEmotions" ofType:@"plist"];
    _emojiImages = [NSDictionary dictionaryWithContentsOfFile:path];
    //设置文本的行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    [paragraphStyle setLineSpacing:4.0f];
    
    NSDictionary *dict = @{NSFontAttributeName:_font,NSParagraphStyleAttributeName:paragraphStyle};
    
    CGSize maxsize = CGSizeMake(1000, MAXFLOAT);
    //根据字体计算表情的高度
    _emotionSize = [@"/" boundingRectWithSize:maxsize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    _attStr = [[NSMutableAttributedString alloc]initWithString:_string attributes:dict];
}
```
```
在这个方法中根据定的正则规则匹对字符串中的富文本
+ (void)executeMatch {
    //正则规则
    NSString *regexString = checkStr;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSRange totalRange = NSMakeRange(0, [_string length]);
    //保存执行结果
    _matches = [regex matchesInString:_string options:0 range:totalRange];
}
```

```
这个方法是根据匹对结果将对应表情图片名字和相对的range保存到字典（比如：@{imagename:{0,4}}）并将这些字典存在数组中,随后会在`setResultStrUseReplace`中用来一个一个替换
+ (void)setImageDataArray {
    
    NSMutableArray *imageDataArray = [NSMutableArray array];
    //遍历结果
    for (int i = (int)_matches.count - 1; i >= 0; i --) {
        
        NSMutableDictionary *record = [NSMutableDictionary dictionary];
        
        LiuqsTextAttachment *attachMent = [[LiuqsTextAttachment alloc]init];
        
        attachMent.bounds = CGRectMake(0, -4, _emotionSize.height, _emotionSize.height);
        
        NSTextCheckingResult *match = [_matches objectAtIndex:i];
        
        NSRange matchRange = [match range];
        
        NSString *tagString = [_string substringWithRange:matchRange];
        
        NSString *imageName = [_emojiImages objectForKey:tagString];
        
        if (imageName == nil || imageName.length == 0) continue;
        
        [record setObject:[NSValue valueWithRange:matchRange] forKey:@"range"];
        
        [record setObject:imageName forKey:@"imageName"];
        
        [imageDataArray addObject:record];
    }
    _imageDataArray = imageDataArray;
}
```

```
这个方法就是最终的遍历替换过程，需要注意的是：
#要从后往前替换，否则会出问题。
原因：先替换了前边的，导致整个字符range改变，这样字典数组中存放的range就不正确了，可能会引发越界崩溃！
+ (void)setResultStrUseReplace{
    
    NSMutableAttributedString *result = _attStr;
    
    for (int i = 0; i < _imageDataArray.count ; i ++) {
        
        NSRange range = [_imageDataArray[i][@"range"] rangeValue];
        
        NSDictionary *imageDic = [_imageDataArray objectAtIndex:i];
        
        NSString *imageName = [imageDic objectForKey:@"imageName"];
        
        NSString *path = [[NSBundle mainBundle]pathForResource:imageName ofType:@"gif"];
        
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        YYImage *image = [YYImage imageWithData:data scale:2];
        
        image.preloadAllAnimatedImageFrames = YES;

        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
        
        NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.frame.size alignToFont:_font alignment:YYTextVerticalAlignmentCenter];
        
        [result replaceCharactersInRange:range withAttributedString:attachText];
    }
    _resultStr = result;
}
```
