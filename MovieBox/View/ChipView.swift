//
//  ChipView.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 12/25/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit
import SnapKit

class ChipView: UIView {
    
    lazy var titleLbl: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews () {
        self.addSubview(titleLbl)
        self.backgroundColor = .darkColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        
        
        titleLbl.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.bottom.equalToSuperview().inset(3)
        }
        
        self.snp.makeConstraints { (make) in
            make.height.equalTo(44)
        }
    }
}
