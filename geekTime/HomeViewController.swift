//
//  HomeViewController.swift
//  geekTime
//
//  Created by swan on 2024/8/5.
//

import UIKit
import Kingfisher

class HomeViewController: BaseViewController, BannerViewDataSource, CommonListDelegate {
    func didSelectItem<Item>(_ item: Item) {
        if let product = item as? Product {
            let detailVC = DetailViewController()
            detailVC.product = product
            // 隐藏底部导航栏
            detailVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(detailVC, animated: true)
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 显示首页的时候，在显示出来
        hidesBottomBarWhenPushed = false
    }
    
    func numberOfBanners(_ bannerView: BannerView) -> Int {
        return FakeData.createBanners().count
    }
    
    func viewOfBanners(_ bannerView: BannerView, index: Int, convertView: UIView?) -> UIView {
        if let view = convertView as? UIImageView {
            view.kf.setImage(with: URL(string: FakeData.createBanners()[index]))
            return view
        } else {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.kf.setImage(with: URL(string: FakeData.createBanners()[index]))
            return imageView
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let bannerView = BannerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 176))
        bannerView.autoScrollInterval = 2
        bannerView.isInfinite = true
        bannerView.dataSource = self
        view.addSubview(bannerView)
        
        // 列表
        let productList = CommonList<Product, ProductCell>()
        productList.items = FakeData.createProducts()
        productList.delegate = self
        view.addSubview(productList)
        productList.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(bannerView.snp_bottom).offset(5)
        }
    }


}
