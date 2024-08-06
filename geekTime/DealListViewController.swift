//
//  DealListViewController.swift
//  geekTime
//
//  Created by swan on 2024/8/6.
//

import UIKit
import SnapKit

// 商品订单页
class DealListViewController: BaseViewController, CommonListDelegate {
    func didSelectItem<Item>(_ item: Item) {
        if let deal = item as? Deal{
            print("点击了\(deal.product.name)")
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // 列表
        let productList = CommonList<Deal, DealListCell>()
        productList.items = FakeData.createDeals()
        productList.delegate = self
        view.addSubview(productList)
        productList.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
