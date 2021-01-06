//
//  SeasonsViewController.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 1/6/21.
//  Copyright © 2021 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit




final class SeasonsViewController: UIViewController {
    
    // MARK: - Outlets
    
    fileprivate lazy var wallpaperImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "moviePlaceholder")
        return imageView
    }()
    
    fileprivate lazy var overlayView: UIView = {
        let overlayView = UIView ()
        overlayView.backgroundColor = .clear
        return overlayView
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SeasonCell.self, forCellWithReuseIdentifier: SeasonCell.uniqueID)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.decelerationRate = .fast
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    fileprivate lazy var submitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .darkColor
        button.layer.cornerRadius = 8
        button.setTitle("Select", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    // MARK: - Props
    
    fileprivate lazy var layout: CarouselLayout = {
        let _layout = CarouselLayout()
        _layout.itemSpacing = 20.0
        _layout.itemSize = itemSize
        _layout.sideItemVisibleWidth = 40.0
        
        return _layout
    }()
    
    fileprivate var itemSize: CGSize {
        let width = (self.view.frame.width - 2 * 20.0) - 40.0 * 2
        return CGSize(width: width, height: self.view.frame.height * 0.85 / 1.4)
    }
    
    fileprivate let gradientLayer = CAGradientLayer()
    
    fileprivate var currentPageIndex: Int = 0
    
    var seasons: [Season] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = true
        self.setUpViews()
        self.setUpGradient()
        
        self.updateWallpaperImage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.layout.itemSize = itemSize
        self.gradientLayer.frame = self.view.bounds
    }
    
    fileprivate func setUpViews () {
        self.view.addSubview(wallpaperImage)
        self.view.addSubview(overlayView)
        self.view.addSubview(collectionView)
        self.view.addSubview(submitButton)
        
        wallpaperImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        overlayView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalToSuperview().multipliedBy(0.85)
        }
        
        submitButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            make.width.equalToSuperview().offset(-2 * (layout.sideItemVisibleWidth + layout.itemSpacing + 15))
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
    fileprivate func setUpGradient () {
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0.3, 0.31, 0.6, 1.0]
        self.overlayView.layer.addSublayer(gradientLayer)
    }
    
    fileprivate func updateWallpaperImage (oldIndex: Int? = nil) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.2)
        
        let currentSeason = self.seasons[self.currentPageIndex]
        let transition = CATransition()
        transition.type = .reveal
        transition.subtype = oldIndex == nil || oldIndex! <  currentPageIndex ? CATransitionSubtype.fromLeft : CATransitionSubtype.fromRight
        wallpaperImage.layer.add(transition, forKey: kCATransition)
        self.wallpaperImage.sd_setImage(with: URL(string: currentSeason.imageURL ?? ""), placeholderImage: UIImage(named: "moviePlaceholder"))
        CATransaction.commit()
    }
}



// MARK: - UI Collection View

extension SeasonsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seasons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeasonCell.uniqueID, for: indexPath) as! SeasonCell
        let season = seasons[indexPath.row]
        cell.imageView.sd_setImage(with: URL(string: season.imageURL ?? ""), placeholderImage: UIImage(named: "moviePlaceholder"))
        cell.titleLbl.text = season.name
        cell.subtitleLbl.text = "\(season.episodeCount) seasons"
        cell.subtitleLbl2.text = season.date
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.3, animations: {
                let scaleX = self.view.frame.width / self.layout.itemSize.width
                let scaleY = self.view.frame.height / self.layout.itemSize.height
                let translateY = self.view.frame.height / 4
                
                cell.transform = CGAffineTransform(scaleX: scaleX, y: scaleY).translatedBy(x: 0, y: -translateY)
            })
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = itemSize.width + layout.itemSpacing
        let currentPage = round(targetContentOffset.pointee.x / pageWidth)
        let newX = currentPage * pageWidth
        
        targetContentOffset.pointee = CGPoint(
            x: newX,
            y: targetContentOffset.pointee.y
        )
        
        if (currentPageIndex != Int(currentPage)) {
            let oldIndex = self.currentPageIndex
            currentPageIndex = Int(currentPage)
            self.updateWallpaperImage(oldIndex: oldIndex)
        }
    }
}
