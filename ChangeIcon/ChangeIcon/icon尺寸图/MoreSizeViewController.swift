//
//  MoreSizeViewController.swift
//  ChangeIcon
//
//  Created by quanjunt on 2018/3/16.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

import UIKit

class MoreSizeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func moreSizeChangeAction(_ sender: Any) {
        //判断是否支持替换图标, false: 不支持
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
    }
}
