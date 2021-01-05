//
//  MainTableViewCell.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 12/25/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell, UniqueIdHelper {
    
    lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    lazy var sectionView: SectionView = {
        let sectionView = SectionView()
        sectionView.setUp()
        sectionView.contentView.addSubview(moviesCollectionView)
        return sectionView
    }()
    
    static var uniqueID: String = "mainCell"
    
    lazy var moviesCollectionView: MoviesList = {
        let collectionView = MoviesList()
        collectionView.setUp()
        return collectionView
    }()

    
    override func didMoveToSuperview() {
        if (superview != nil) {
            self.selectionStyle = .none
            self.contentView.addSubview(sectionView)
            self.contentView.addSubview(separatorView)
            
            separatorView.snp.makeConstraints { (make) in
                make.height.equalTo(20)
                 make.leading.bottom.trailing.equalToSuperview()
            }
            
            moviesCollectionView.snp.makeConstraints { (make) in
                make.leading.trailing.top.bottom.equalToSuperview()
                make.height.equalTo(300)
                make.width.height.equalToSuperview()
            }
            
            sectionView.snp.makeConstraints { (make) in
                make.leading.top.trailing.equalToSuperview()
                make.bottom.equalTo(separatorView.snp.top)
            }
        }
    }
}
