
//
//  SectionViewCell.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 1/20/21.
//  Copyright © 2021 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

final class SectionViewCell: UITableViewCell, UniqueIdHelper {
    static var uniqueID: String = "SectionViewCell"
    
    lazy var sectionView: SectionView = {
        let sectionView = SectionView()
        sectionView.setUp()
        return sectionView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUp () {
        self.contentView.addSubview(sectionView)
        
        sectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
