//
//  SectionView.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 12/25/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit
import SnapKit

class SectionView: UIView {
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = .systemFont(ofSize: 20, weight: .bold)
        return lbl
    }()
    
    lazy var subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.alpha = 0.6
        lbl.font = .systemFont(ofSize: 14, weight: .regular)
        return lbl
    }()
    
    lazy var horizontalLine: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 2.5
        
        view.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.width.equalTo(5)
        }
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()

    func setUp () {
        self.backgroundColor = UIColor.darkColor
        self.alpha = 0.6
        
        
        self.setUpViews()
        self.setUpConstraints()
    }
    
    private func setUpViews () {
        self.addSubview(titleLabel)
        self.addSubview(subtitleLabel)
        self.addSubview(horizontalLine)
        self.addSubview(contentView)
    }
    
    private func setUpConstraints () {
        horizontalLine.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(24)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(horizontalLine)
            make.leading.equalTo(horizontalLine.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        subtitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(horizontalLine)
            make.top.equalTo(titleLabel.snp.bottom).offset(0)
            make.trailing.equalTo(titleLabel)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(subtitleLabel)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}
