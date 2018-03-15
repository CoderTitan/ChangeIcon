//
//  AlertChangeViewController.swift
//  ChangeIcon
//
//  Created by quanjunt on 2018/3/14.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

import UIKit

class AlertChangeViewController: UIViewController {

    fileprivate var imageArr = ["天天特价", "小房子", "小猫", "邮件信息"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    //更换Icon图
    @IBAction func changeIconAction(_ sender: Any) {
        let imageStr = imageArr[Int(arc4random_uniform(UInt32(imageArr.count)))]

        //判断是否支持替换图标, false: 不支持
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
