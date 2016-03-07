//
//  MacroDef.h
//  BaseUtinity
//
//  Created by xxcao on 14-4-28.
//  Copyright (c) 2014年 xxcao. All rights reserved.
//

#ifndef MacroDef
#define MacroDef
/*==================================宏定义==================================*/

//View相关
#define Point(Xpos, Ypos)                  CGPointMake(Xpos, Ypos)
#define Size(Width, Height)                CGSizeMake(Width, Height)
#define Frame(Xpos, Ypos, Width, Height)   CGRectMake(Xpos, Ypos, Width, Height)
#define Xpos                               origin.x
#define Ypos                               origin.y
#define Width                              size.width
#define Height                             size.height

//frame相关
#define SetFrameByXPos(frame,xpos)        {CGRect rect = frame; rect.origin.x = xpos; frame = rect;}
#define SetFrameByYPos(frame,ypos)        {CGRect rect = frame; rect.origin.y = ypos; frame = rect;}
#define SetFrameByWidth(frame,kWidth)     {CGRect rect = frame; rect.size.width = kWidth; frame = rect;}
#define SetFrameByHeight(frame,kHeight)   {CGRect rect = frame; rect.size.height = kHeight; frame = rect;}

//Window相关
#define Screen_Width                 [UIScreen mainScreen].bounds.size.width
#define Screen_Height                [UIScreen mainScreen].bounds.size.height

//弧度与角度的转换
#define DegreeToRadian(X)            ((X) * M_PI / 180.0)
#define RadianToDegree(Radian)       ((Radian) * 180.0 / M_PI)

//设置View圆角
#define setViewCorner(view,radius)   {view.layer.cornerRadius = radius; view.layer.masksToBounds = YES;}

//设置View圆角加边框
#define setViewCornerAndBorder(view,radius)   {view.layer.cornerRadius = radius; view.layer.masksToBounds = YES; view.layer.borderWidth = 0.5; view.layer.borderColor = ColorRGB(190, 190, 190).CGColor;}

//设置View边框
#define setViewBorder(view, width) {view.layer.borderWidth = width; view.layer.borderColor = ColorRGB(190, 190, 190).CGColor;}

//设置颜色
#define ColorRGBA(R,G,B,A)           [UIColor colorWithRed:R / 255.0 green:G / 255.0  blue:B / 255.0  alpha:A]
#define ColorRGB(R,G,B)              [UIColor colorWithRed:R / 255.0 green:G / 255.0  blue:B / 255.0  alpha:1.0]

//透明色
#define ClearColor                   [UIColor clearColor]

//Application单例
#define SingletonApplication         [UIApplication sharedApplication]
#define SingletonApplicationDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]

//检测是否retina屏
#define isRetina   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

//检测iPad是否retina屏
#define isRetina_iPad  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1536, 2048), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(2048, 1536), [[UIScreen mainScreen] currentMode].size)) : NO)

//检测是否iPhone5
#define isIPhone5    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//检测是否iPhone4
#define isIPhone4    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
//检测是否4寸屏
#define is4inch    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//最小线宽
#define minLineWidth  ((isIPad && !isRetina_iPad) ? 1.0 : 0.5)

//检测是否iOS7
#define isIOS7       (CurrentSystemVersion_Double >= 7.0)

//检测是否iOS8
#define isIOS8       (CurrentSystemVersion_Double >= 8.0)

//检测是否iPad
#define isIPad      (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//检测是否iPod或者iPhone
#define isIPhone    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

//当前iOS系统版本
#define CurrentSystemVersion_String        [[UIDevice currentDevice] systemVersion]
#define CurrentSystemVersion_Double        [[[UIDevice currentDevice] systemVersion] doubleValue]

//读取图片
#define IOImage(FileName,TypeName)         [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:FileName ofType:TypeName]]
#define Image(FileName)                    [UIImage imageNamed:FileName]

//字体
#define Font(FontSize)                     [UIFont systemFontOfSize:FontSize]
#define BoldFont(FontSize)                 [UIFont boldSystemFontOfSize:FontSize]

//UIAlert提示
#define Default_OKSTR                       @"确定"
#define Default_CancelSTR                   @"取消"
#define Default_TipSTR                      @"提示"

//原生alert
#define Alert(Message) \
{UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Default_TipSTR \
message:Message \
delegate:nil \
cancelButtonTitle:Default_OKSTR \
otherButtonTitles:nil]; \
[alert show];}

#define AlertWithOneButton(Title,Message,Delegate) \
{UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Title \
message:Message \
delegate:Delegate \
cancelButtonTitle:Default_OKSTR \
otherButtonTitles:nil]; \
[alert show]; \
[alert release];}

#define AlertWithTwoButton(Title,Message,Delegate) \
{UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Title \
message:Message \
delegate:Delegate \
cancelButtonTitle:Default_CancelSTR \
otherButtonTitles:Default_OKSTR, nil]; \
[alert show];}

//数据存储
#define UserDefaultsGet(Key)           [[NSUserDefaults standardUserDefaults] objectForKey:Key]
#define UserDefaultsSave(Value,Key)    {[[NSUserDefaults standardUserDefaults] setObject:Value forKey:Key]; [[NSUserDefaults standardUserDefaults] synchronize];}
#define UserDefaultsRemove(Key)        {[[NSUserDefaults standardUserDefaults] removeObjectForKey:Key]; [[NSUserDefaults standardUserDefaults] synchronize];}

//通知
#define AddNoticeObserver(NoticeKey)             [NSNotificationCenter defaultCenter] addObserverForName:NoticeKey object:nil queue:nil usingBlock:^(NSNotification *note)
#define PostNoticeObserver(NoticeKey,Object)     [[NSNotificationCenter defaultCenter] postNotificationName:NoticeKey object:Object]
#define PostNoticeObserverWithInfo(NoticeKey,Object,UserInfo)     [[NSNotificationCenter defaultCenter] postNotificationName:NoticeKey object:Object userInfo:UserInfo]
#define RemoveNoticeObserver(NoticeKey,Delegate) [[NSNotificationCenter defaultCenter] removeObserver:Delegate name:NoticeKey object:nil]

//从相机选择图片
#define ImagePicker_Camera(editable) \
{BOOL isSourceTypePhotoLibrary = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]; \
if (isSourceTypePhotoLibrary) { \
UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init]; \
imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera; \
imagePickerController.delegate = wself; \
imagePickerController.allowsEditing = editable; \
[wself presentViewController:imagePickerController animated:YES completion:nil]; \
}}

//从相册选择图片
#define ImagePicker_Album(editable) \
{BOOL isSourceTypePhotoLibrary = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]; \
if (isSourceTypePhotoLibrary) { \
UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init]; \
imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; \
imagePickerController.delegate = wself; \
imagePickerController.allowsEditing = editable; \
[wself presentViewController:imagePickerController animated:YES completion:nil]; \
}}

//区分是真机、模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

//Release版本去除NSLog
#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif


//把Dictionary导入Bean(NSString)
#define ImportStringIntoBean(varName)  {if(dict[@#varName] && !(dict[@#varName] == [NSNull null])){\
self.varName = [NSString stringWithFormat:@"%@", dict[@#varName]];\
} else {\
self.varName = @"";\
}}

//把Dictionary导入Bean(NSString),两个参数
#define ImportStringIntoBean2(dict,varName)  {if(dict[@#varName] && !(dict[@#varName] == [NSNull null])){\
self.varName = [NSString stringWithFormat:@"%@", dict[@#varName]];\
} else {\
self.varName = @"";\
}}


//把Dictionary导入Bean(NSArray)
#define ImportArrayIntoBean(varName)  {if(dict[@#varName] && !(dict[@#varName] == [NSNull null])){\
self.varName = [NSArrary arrayWithArray: dict[@#varName]];\
} else {\
self.varName = @[];\
}}

//把Dictionary导入Bean(NSArray),两个参数
#define ImportArrayIntoBean2(dict,varName)  {if(dict[@#varName] && !(dict[@#varName] == [NSNull null])){\
self.varName = [NSArrary arrayWithArray: dict[@#varName]];\
} else {\
self.varName = @[];\
}}

//把Dictionary导入Bean(NSDictionary)
#define ImportDictionaryIntoBean(varName)  {if(dict[@#varName] && !(dict[@#varName] == [NSNull null])){\
self.varName = [NSDictionary dictionaryWithDictionary: dict[@#varName]];\
} else {\
self.varName = nil;\
}}

//把Dictionary导入Bean(NSDictionary),两个参数
#define ImportDictionaryIntoBean2(dict,varName)  {if(dict[@#varName] && !(dict[@#varName] == [NSNull null])){\
self.varName = [NSDictionary dictionaryWithDictionary: dict[@#varName]];\
} else {\
self.varName = nil;\
}}


//变量属性
#define Strong          @property(nonatomic, strong)
#define Weak            @property(nonatomic, weak)
#define Retain          @property(nonatomic, retain)
#define Copy            @property(nonatomic, copy)
#define Assign          @property(nonatomic, assign)

#define StrongWithIB    @property(nonatomic, strong) IBOutlet
#define WeakWithIB      @property(nonatomic, weak) IBOutlet
#define RetainWithIB    @property(nonatomic, retain) IBOutlet

//block self
#define WeakSelf        __weak __typeof(self) wself = self;


//泛型转换成NSString
#define StringFromId(idType)  [NSString stringWithFormat:@"%@",idType]

//NSNull 的处理
#define VerifyValue(value) \
({id tmp; \
if ([value isKindOfClass:[NSNull class]]) { \
tmp = nil; \
} else { \
tmp = value; \
} \
tmp; \
})

//iOS7 滑动返回手势
#define iOS7PopGestureRecognizer     {if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) { \
self.navigationController.interactivePopGestureRecognizer.delegate = nil;}}

//空字符串
#define NullString            @""

//从nib中加载cell
#define LoadFromNib(nibName)  [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] lastObject]

//用uiNib实例来加载
#define LoadFromNib2(uiNib)   [[uiNib instantiateWithOwner:nil options:nil] firstObject]


//从类中加载cell
#define LoadFromClass(cellId) [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId]

//delegate的判断
#define isDelegate(delegate,sender)    delegate && [delegate respondsToSelector:@selector(sender)]

//arc警告宏
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

//国际化
#define MutableLanguages(locString)    (NSLocalizedString(locString, @""))

#define MutableLanguages2(locString)     ([[InternationalManager bundle] localizedStringForKey:locString value:nil table:@"Localizable"])

//格式化字符串
#define kFomartString  @"                             -----------------------------                             "
#endif