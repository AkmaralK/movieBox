//
//  AppButton.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 1/4/21.
//  Copyright © 2021 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

final class AppButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        self.initialSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialSetup () {
        self.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = .red
        self.layer.cornerRadius = 12
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 8
        self.layer.shadowOpacity = 0.4
        self.layer.shadowColor = UIColor.red.cgColor
        
        
        self.snp.makeConstraints { (make) in
            make.height.equalTo(44)
        }
    }
}
