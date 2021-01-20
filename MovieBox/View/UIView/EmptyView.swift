//
//  EmptyView.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 1/5/21.
//  Copyright © 2021 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

final class EmptyView: UIView {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "moviePlaceholder")
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel ()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .white
        label.text = "Not Found"
        label.textAlignment = .center
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        self.setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUpViews () {
        self.backgroundColor = .darkColor
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalTo(titleLabel).inset(-16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(128)
        }
    }
}


