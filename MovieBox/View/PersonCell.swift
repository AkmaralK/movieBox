//
//  PersonCell.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 12/25/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

class PersonCell: UICollectionViewCell {
    lazy var avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .red
        imageView.image = UIImage(named: "person")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var personNameLbl: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    lazy var personDescriptionLbl: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
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
        self.contentView.backgroundColor = UIColor.rgb(25, 25, 25)
        self.contentView.layer.cornerRadius = 8
        
        self.addShadow()
        
        for view in [avatarImage, personNameLbl, personDescriptionLbl] {
            self.contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addUIConstraints()
    }
    
    private func addShadow () {
        let layer = self.contentView.layer
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.8
    }
    
    private func addUIConstraints () {
        avatarImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(175)
        }
        
        personNameLbl.snp.makeConstraints { (make) in
            make.top.equalTo(avatarImage.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        personDescriptionLbl.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.equalTo(personNameLbl.snp.bottom)
        }
    }
}
