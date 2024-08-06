//
//  BannerView.swift
//  geekTime
//
//  Created by swan on 2024/8/5.
//

import Foundation
import UIKit
import SnapKit

// AnyObject : 协议只能用 类 支持
protocol BannerViewDataSource: AnyObject {
    // 表示我有几个 banner
    func numberOfBanners(_ bannerView: BannerView) -> Int
    
    // banner 渲染 view
    func viewOfBanners(_ bannerView: BannerView, index: Int, convertView: UIView?) -> UIView
    
}

protocol BannerViewDelegate: AnyObject {
    func didSelectBanner(_ banner: BannerView, index: Int)
}

class BannerView:UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
    // 滚动View
    var flowLayout: UICollectionViewFlowLayout!
    
    var pageControl: UIPageControl!
    
    weak var dataSource: BannerViewDataSource! {
        didSet {
            pageControl.numberOfPages = self.dataSource.numberOfBanners(self)
            collectionView.reloadData()
            if isInfinite {
                DispatchQueue.main.async {
                    self.collectionView.setContentOffset(CGPoint(x: self.collectionView.frame.width, y: 0), animated: false)
                }
            }
        }
    }
    weak var delegate: BannerViewDelegate?
    
    // 轮播时间片
    var autoScrollInterval: Float = 0 {
        didSet {
            if self.autoScrollInterval > 0 {
                self.startAutoScroll()
            } else {
                self.stopAutoScroll()
            }
        }
    }
    // 是否允许自动轮播
    var isInfinite: Bool = true
    // 计时器
    var timer: Timer?
    
    static var cellId = "bannerViewCellId"
    static var convertViewTag = 10086
    
    override init(frame: CGRect) {
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.headerReferenceSize = .zero
        flowLayout.footerReferenceSize = .zero
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        // 滚动方向 水平
        flowLayout.scrollDirection = .horizontal
        
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), collectionViewLayout: flowLayout)
        
        pageControl = UIPageControl()
        
        super.init(frame: frame)
        self.setUpViews()
    }
    
    // 设置 View
    func setUpViews(){
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true // 是否以分页形式呈现
        collectionView.showsHorizontalScrollIndicator = false // 不展示滚动条
        collectionView.contentInsetAdjustmentBehavior = .never
        // 注册一个 UICollectionViewCell
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: BannerView.cellId)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.addSubview(collectionView)
        self.addSubview(pageControl)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let pageNumber = dataSource.numberOfBanners(self)
        if isInfinite {
            // 如果是无限轮播
            if pageNumber == 1 {
                return 1
            } else {
                // 首尾 各 加一张
                return pageNumber + 2
            }
        } else {
            return pageNumber
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerView.cellId, for: indexPath)
        // banner 真实的 index
        var index = indexPath.row
        if isInfinite {
            let pageNumber = dataSource.numberOfBanners(self)
            if pageNumber > 1 {
                if indexPath.row == 0 {
                    // 如果当前是第一个，实际 index 为 最后一个
                    index = pageNumber - 1
                } else if indexPath.row == pageNumber + 1 {
                    index = 0
                } else {
                    index = indexPath.row - 1
                }
            }
        }
        
        if let view = cell.contentView.viewWithTag(BannerView.convertViewTag) {
            let _ = dataSource.viewOfBanners(self, index: index, convertView: view)
        } else {
            let newView = dataSource.viewOfBanners(self, index: index, convertView: nil)
            newView.tag = BannerView.convertViewTag
            cell.contentView.addSubview(newView)
            newView.snp.makeConstraints { make in
                // 充满父布局
                make.edges.equalToSuperview()
            }
        }
        
        return cell
    }
    
    // 停止自动轮播
    func stopAutoScroll(){
        if let t = timer {
            t.invalidate()
            timer = nil
        }
    }
        
    
    // 开始自动轮播
    func startAutoScroll(){
        guard autoScrollInterval > 0 && timer == nil else {
            return
        }
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(autoScrollInterval), target: self, selector: #selector(flipNext), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    // 滚动到下一页
    @objc func flipNext() {
        guard let _ = superview, let _ = window else {
            return
        }
        
        let totalPageNumber = dataSource.numberOfBanners(self)
        guard totalPageNumber > 1 else { return }
        
        // 轮播逻辑
        let currentPageNumber = Int(round(collectionView.contentOffset.x / collectionView.frame.width))
        if isInfinite {
            let nextPageNumber = currentPageNumber + 1
            // 设置滚动到那一页
            collectionView.setContentOffset(CGPoint(x: collectionView.frame.width * CGFloat(nextPageNumber), y: 0), animated: true)
            if nextPageNumber >= totalPageNumber + 1 {
                pageControl.currentPage = 0
            } else {
                pageControl.currentPage = nextPageNumber - 1
            }
        } else {
            var nextPageNumber = currentPageNumber + 1
            if nextPageNumber >= totalPageNumber {
                nextPageNumber = 0
            }
            collectionView.setContentOffset(CGPoint(x: collectionView.frame.width * CGFloat(nextPageNumber), y: 0), animated: true)
            pageControl.currentPage = nextPageNumber
        }
    }
    
    // 返回 cell 大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // 滚动到 最后一页
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let total = dataSource.numberOfBanners(self)
        let current = Int(round(collectionView.contentOffset.x / collectionView.frame.width))
        if current >= total + 1 {
            collectionView.setContentOffset(CGPoint(x: collectionView.frame.width, y: 0), animated: false)
            
        }
    }
}
