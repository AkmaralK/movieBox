//
//  MainTableViewCell.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 12/25/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell, UniqueIdHelper {
    
    @IBOutlet weak var sectionView: SectionView!
    
    static var uniqueID: String = "mainCell"
    
    lazy var moviesCollectionView: MoviesList = {
        let collectionView = MoviesList()
        collectionView.setUp()
        return collectionView
    }()
    
    override func didMoveToSuperview() {
        if (superview != nil) {
            sectionView.setUp()
            sectionView.contentView.addSubview(moviesCollectionView)
            moviesCollectionView.snp.makeConstraints { (make) in
                make.leading.trailing.top.bottom.equalToSuperview()
                make.height.equalTo(300)
                make.width.height.equalToSuperview()
            }
        }
    }
}
