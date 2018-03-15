//
//  ViewController.swift
//  ChangeIcon
//
//  Created by quanjunt on 2018/3/14.
//  Copyright © 2018年 quanjunt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    fileprivate var titleArr = ["弹框提示更换icon", "无弹框提示更换icon", "网络下载APP图标更换"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "列表"
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.selectionStyle = .none
        cell?.textLabel?.text = titleArr[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vcs = [AlertChangeViewController(), NoAlertChangeViewController(), DownloadViewController()]
        let vc = vcs[indexPath.row]
        vc.title = titleArr[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
