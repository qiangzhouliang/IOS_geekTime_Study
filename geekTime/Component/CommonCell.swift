//
//  CommonCell.swift
//  geekTime
//
//  Created by zhj on 2019/11/23.
//  Copyright © 2019 geekbang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class CommonCell: UIControl {
    
    var title: String? {
        // 属性观察器
        didSet {
            self.titleView.text = self.title
        }
    }
    var icon: UIImage? {
        didSet {
            self.iconView.image = self.icon
        }
    }
    
    var titleView: UILabel
    var iconView: UIImageView
    // 底部分割线
    var bottomLine: UIView
    // 右边箭头
    var arrowView: UIImageView
    // 高亮
    var hilightView: UIView
    
    override init(frame: CGRect) {
        titleView = UILabel()
        iconView = UIImageView()
        bottomLine = UIView()
        arrowView = UIImageView(image: R.image.icon_right_arrow())
        hilightView = UIView()
        super.init(frame: frame)
        self.backgroundColor = .white
        self.setupViews()
    }
    
    func setupViews() {
        self.addSubview(hilightView)
        hilightView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        hilightView.isHidden = true
        hilightView.alpha = 0
        hilightView.snp.makeConstraints { (make) in
            // 和整个父 View 一样大
            make.edges.equalToSuperview()
        }
        
        self.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            // 上下居中
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        self.addSubview(titleView)
        titleView.textColor = UIColor.hexColor(0x333333)
        titleView.font = UIFont.systemFont(ofSize: 15)
        titleView.snp.makeConstraints { (make) in
            // 距离 iconView 右边 10
            make.left.equalTo(iconView.snp_right).offset(10)
            // 垂直居中
            make.centerY.equalToSuperview()
        }
        
        // 箭头
        self.addSubview(arrowView)
        arrowView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(bottomLine)
        bottomLine.backgroundColor = UIColor(white: 0.95, alpha: 1)
        bottomLine.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(1 / UIScreen.main.scale)
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            super.isHighlighted = self.isHighlighted
            if self.isHighlighted {
                self.hilightView.alpha = 1
                self.hilightView.isHidden = false
            } else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.hilightView.alpha = 0
                }) { (finished) in
                    self.hilightView.isHidden = true
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
