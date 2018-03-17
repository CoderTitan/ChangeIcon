# iOS神技之动态更换APP的Icon图

- 在iOS10.3系统发布之前, 众所周知, 在App Store上架的APP如果要更换Icon图, 只能更新版本替换; 
- 这次苹果却在iOS10.3系统中加入了了更换应用图标的新功能，当应用安装后，开发者可以为应用提供多个应用图标选择。
- 用户可以自由的在这些图标之间切换，并及时生效。
- 这是因为 10.3 里引入了一个新的 API，它允许在 App 运行的时候，通过代码为 app 更换 icon
- 个人技术博客地址:  https://www.titanjun.top/

<!-- more -->

## 一. 项目配置

- 虽然提供了更换的功能，但更换的 icon 是有限制的
- 它只能更换项目中提前添加配置好的Icon图
- 具体可参考demo--[github项目地址](https://github.com/CoderTitan/ChangeIcon)

- 这里先看个效果


![更换icon.gif](https://upload-images.jianshu.io/upload_images/4122543-66b9c476748f1937.gif?imageMogr2/auto-orient/strip)


### 1. 备选Icon
- 首先你需要将备选的Icon图添加到项目中,
- 注意: 
  - 图片不要放到`Assets.xcassets`, 而应该直接放到工程中, 不然可能导致更换Icon时, 找不到图片, 更换失败
  - 在`info.plist` 的配置中，图片的文件名应该尽量不带 @2x/@3x 后缀扩展名，而让它自动选择
 
![Snip20180315_1.png](https://upload-images.jianshu.io/upload_images/4122543-49f0f45c2657a229.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

### 2. 配置`info.plist`文件
- 在`info.plist`文件中，添加对应的`CFBundleAlternateIcons`的信息
- 这里也可以查看[官方的相关介绍](https://developer.apple.com/library/content/documentation/General/Reference/InfoPlistKeyReference/Introduction/Introduction.html#//apple_ref/doc/uid/TP40009247)
 
![Snip20180315_2.png](https://upload-images.jianshu.io/upload_images/4122543-8886cf5e071a1c59.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)


> `Source Code`添加方式如下


```objc
        <key>CFBundleAlternateIcons</key>
		<dict>
			<key>天天特价</key>
			<dict>
				<key>CFBundleIconFiles</key>
				<array>
					<string>天天特价</string>
				</array>
				<key>UIPrerenderedIcon</key>
				<false/>
			</dict>
			<key>小房子</key>
			<dict>
				<key>CFBundleIconFiles</key>
				<array>
					<string>小房子</string>
				</array>
				<key>UIPrerenderedIcon</key>
				<false/>
			</dict>
			<key>小猫</key>
			<dict>
				<key>CFBundleIconFiles</key>
				<array>
					<string>小猫</string>
				</array>
				<key>UIPrerenderedIcon</key>
				<false/>
			</dict>
			<key>邮件信息</key>
			<dict>
				<key>CFBundleIconFiles</key>
				<array>
					<string>邮件信息</string>
				</array>
				<key>UIPrerenderedIcon</key>
				<false/>
			</dict>
		</dict>

```

- 注意事项:
  - 虽然文档中写着`「You must declare your app's primary and alternate icons using the CFBundleIcons key of your app's Info.plist file. 」`，但经测试，`CFBundlePrimaryIcon` 可以省略掉。在工程配置 `App Icons and Launch Image` - `App Icons Source` 中使用 `asset catalog`（默认配置），删除 `CFBundlePrimaryIcon` 的配置也是没有问题的。
  - 省略这个配置的好处是，避免处理 `App icon` 的尺寸。现在的工程中，大家一般都使用 `asset catalog` 进行 icon 的配置，而一个 icon 对应有很多尺寸的文件。省略 `CFBundlePrimaryIcon` 就可以沿用 `Asset` 中的配置。
  - 如果想设置回默认 icon，在 `setAlternateIconName` 中传入 nil 即可


## 二. API调用
下面我们看一下系统提供的三个API, 这里产看[官方文档](https://developer.apple.com/documentation/uikit/uiapplication/2806818-setalternateiconname)


```objc
var supportsAlternateIcons: Bool
//一个布尔值，指示是否允许应用程序更改其图标

var alternateIconName: String?
//可选图标的名称，在app的Info.plist文件中声明的CFBundleAlternateIcons中设置。
//如果要显示应用程序的主图标alternateIconName 传nil即可，主图标使用CFBundlePrimaryIcon声明，CFBundleAlternateIcons与CFBundlePrimaryIcon两个key都是CFBundleIcons的子条目

func setAlternateIconName(_ alternateIconName: String?, 
        completionHandler: ((Error?) -> Void)? = nil)
//更改应用程序的图标
//completionHandler: 当有结果的时候的回调
//成功改变图标的的时候，error为nil，如果发生错误，error描述发生什么了。并且alternateIconName的值保持不变
```

具体的实现代码:

```objc
if #available(iOS 10.3, *) {
    //判断是否支持替换图标, false: 不支持
    guard UIApplication.shared.supportsAlternateIcons else { return }
    
    //如果支持, 替换icon
    UIApplication.shared.setAlternateIconName(imageStr) { (error) in
        if error != nil {
            print(error ?? "更换icon发生错误")
        } else {
            print("更换成功")
        }
    }
}

```

## 三. 消除alert弹窗

![Snip20180315_3.png](https://upload-images.jianshu.io/upload_images/4122543-8ffa3280a84c46ed.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)


- 动态更换App图标会有弹框, 有时候这个弹框看上去可能会很别扭, 但是这个弹框是系统直接调用弹出的, 我们又如何消除呢
- 通过层级关系可以看到这个弹框就是一个`UIAlertController`, 并且是通过`presentViewController:animated:completion:`方法弹出的
- 所以可以考虑使用`runtime`, 拦截并替换该方法, 让更换icon的时候, 不弹
- 下面看一下具体代码:


```objc
extension NoAlertChangeViewController {
    fileprivate func runtimeReplaceAlert() {
        DispatchQueue.once(token: "UIAlertController") {
            let originalSelector = #selector(present(_:animated:completion:))
            let swizzledSelector = #selector(noAlert_present(_:animated:completion:))
            
            let originalMethod = class_getInstanceMethod(NoAlertChangeViewController.self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(NoAlertChangeViewController.self, swizzledSelector)
            
            //交换实现的方法
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
    }
    
    @objc fileprivate func noAlert_present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Swift.Void)? = nil) {
        //判断是否是alert弹窗
        if viewControllerToPresent.isKind(of: UIAlertController.self) {
            print("title: \(String(describing: (viewControllerToPresent as? UIAlertController)?.title))")
            print("message: \(String(describing: (viewControllerToPresent as? UIAlertController)?.message))")
            
            // 换图标时的提示框的title和message都是nil，由此可特殊处理
            let alertController = viewControllerToPresent as? UIAlertController
            if alertController?.title == nil && alertController?.message == nil {
                //是更换icon的提示
                return
            } else {
                //其他的弹框提示正常处理
                noAlert_present(viewControllerToPresent, animated: flag, completion: completion)
            }
        }
        noAlert_present(viewControllerToPresent, animated: flag, completion: completion)
    }
}

```

- 这里用到了`DispatchQueue.once`, 这个`once`是我对`DispatchQueue`加了一个扩展
- 在Swift4.0以后, `static dispatch_once_t onceToken;`这个已经不能用了
- 关于这方面的详细介绍, 大家可以看看我的这篇文章--[升级Swift4.0遇到的坑](https://www.titanjun.top/2017/08/25/%E5%8D%87%E7%BA%A7Swift4.0%E9%81%87%E5%88%B0%E7%9A%84%E5%9D%91/)
- 

## 四. 支持不同尺寸的Icon
- 一个标准的Icon图集, 需要十几种尺寸, 比如: 20, 29, 40, 60等
- 对于 `info.plist` 中的每个 `icon` 配置，`CFBundleIconFiles` 的值是一个数组，我们可以在其中填入这十几种规格的图片名称。经测试:
  - 文件的命名没有强制的规则，可以随意取，
  - 数组中的文件名也不关心先后顺序。
- 总之把对应的文件名填进去即可，它会自动选择合适分辨率的文件（比如在 setting 中显示 icon 时，它会找到提供的数组中分辨率为 29pt 的那个文件）。
- 具体相关官方文档可参考, [官方介绍](https://developer.apple.com/ios/human-interface-guidelines/overview/themes/#app-icon-sizes)
- 首先, 针对不同的尺寸, 我们要有不同的命名, 具体参考下图

![不同尺寸图片配置图](http://img.blog.csdn.net/20180316194726671?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvU2htaWx5Q29kZXI=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

- 文件扩展名，如@2x,@3x，要么统一不写，那么系统会自动寻找合适的尺寸。
- 要写就需要把每张icon的扩展名写上，和上图的格式一样
- 代码中调用图片名, 更不需要加上尺寸:

```objc
        if #available(iOS 10.3, *) {
            //判断是否支持替换图标, false: 不支持
            guard UIApplication.shared.supportsAlternateIcons else { return }
            
            //如果支持, 替换icon
            UIApplication.shared.setAlternateIconName("Sunday") { (error) in
                //点击弹框的确认按钮后的回调
                if error != nil {
                    print(error ?? "更换icon发生错误")
                } else {
                    print("更换成功")
                }
            }
        }

```

- 具体可参考demo--[github项目地址](https://github.com/CoderTitan/ChangeIcon)



