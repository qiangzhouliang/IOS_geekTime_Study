//
//  ViewController.swift
//  geekTime
//
//  Created by swan on 2024/8/4.
//

import UIKit
import SnapKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        
        let homeVC = HomeViewController()
        homeVC.tabBarItem.image = R.image.home()
        // .withRenderingMode(.alwaysOriginal): 图片将以原图显示
        homeVC.tabBarItem.selectedImage = R.image.home_selected()?.withRenderingMode(.alwaysOriginal)
        homeVC.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.hexColor(0x333333)], for: .selected)
        homeVC.tabBarItem.title = "首页"
        let navigationHomeVC = UINavigationController(rootViewController: homeVC)
        self.addChild(navigationHomeVC)
        
        
        let mineVC = MineViewController()
        mineVC.tabBarItem.image = R.image.mine()
        mineVC.tabBarItem.selectedImage = R.image.mine_selected()?.withRenderingMode(.alwaysOriginal)
        mineVC.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.hexColor(0x333333)], for: .selected)
        mineVC.tabBarItem.title = "我的"
        let mineVCHomeVC = UINavigationController(rootViewController: mineVC)
        self.addChild(mineVCHomeVC)
        
    }
    
    


}

