//
//  NoAlertChangeViewController.swift
//  ChangeIcon
//
//  Created by quanjunt on 2018/3/14.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

import UIKit

fileprivate let row = 4 //列
fileprivate let imageW = (UIScreen.main.bounds.width - (CGFloat(row) + 1) * 20) / CGFloat(row)
class NoAlertChangeViewController: UIViewController {

    fileprivate var imageArr = ["天天特价", "小房子", "小猫", "邮件信息"]
    fileprivate lazy var selectorlabel = { () -> UILabel in
        let label = UILabel()
        label.backgroundColor = UIColor.red
        label.text = "选中"
        label.textAlignment = .center
        label.textColor = UIColor.white
        view.addSubview(label)
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "点击下图更换icon图"
        runtimeReplaceAlert()
        setupViews()
    }
    
    //创建页面视图
    fileprivate func setupViews() {

        for i in 0..<imageArr.count {
            let imageX = 20 + (imageW + 20) * CGFloat(i)
            let imageV = UIImageView(frame: CGRect(x: imageX, y: 100, width: imageW, height: imageW))
            imageV.image = UIImage(named: imageArr[i])
            imageV.isUserInteractionEnabled = true
            imageV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeIconAction(_:))))
            imageV.tag = 1000 + i
            view.addSubview(imageV)
        }
        selectorlabel.frame = CGRect(x: 20, y: 120 + imageW, width: imageW, height: 25)
        selectorlabel.isHidden = true
    }
    
    //更换Icon图
    @objc fileprivate func changeIconAction(_ tap: UITapGestureRecognizer) {
        let tagNum = tap.view?.tag ?? 1000
        selectorlabel.isHidden = false
        selectorlabel.frame.origin.x = 20 + (imageW + 20) * CGFloat(tagNum - 1000)
        
        let imageStr = imageArr[tagNum - 1000]
        
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
    }
}

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
