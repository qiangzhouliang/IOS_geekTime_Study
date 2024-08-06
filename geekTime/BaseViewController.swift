//
//  BaseViewController.swift
//  geekTime
//
//  Created by swan on 2024/8/5.
//

import UIKit

// 公共基础 ViewController
class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 设置背景色
        view.backgroundColor = UIColor.hexColor(0xf2f4f7)
        // 设置导航栏背景颜色
        navigationController?.navigationBar.backgroundColor = .lightGray
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.hexColor(0x333333)]
        edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
