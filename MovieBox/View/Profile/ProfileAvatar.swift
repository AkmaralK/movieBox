//
//  ProfileAvatar.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 1/20/21.
//  Copyright © 2021 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

final class ProfileAvatar: UIView {
    
    lazy var titleLbl: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func setUp () {
        self.backgroundColor = .red
        self.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(8)
        }
    }
}
