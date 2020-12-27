//
//  ItemsStackView.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 12/27/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

class ItemsStackView: UIStackView {
    
    init (itemViews: [ItemView]) {
        super.init(frame: .zero)
        self.axis = .vertical
        self.alignment = .fill
        self.distribution = .fill
        self.spacing = 4.0
        
        for itemView in itemViews {
            self.addArrangedSubview(itemView)
            let dividerView = createDivider()
            self.addArrangedSubview(dividerView)
            dividerView.snp.makeConstraints { (make) in
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(1)
            }
        }
    }
    
    func rebuildItems(with itemViews: [ItemView]) {
        for view in self.arrangedSubviews {
            self.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createDivider () -> UIView {
        let divider = UIView()
        divider.backgroundColor = .lightGray
        divider.layer.cornerRadius = 0.5
        return divider
    }
}
