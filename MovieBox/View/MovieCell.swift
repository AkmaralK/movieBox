//
//  MovieCell.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 12/24/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    lazy var movieImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .red
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var movieTitleLbl: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    lazy var movieDescriptionLbl: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 1
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
        for view in [movieImage, movieTitleLbl, movieDescriptionLbl] {
            self.contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addUIConstraints()
    }
    
    private func addUIConstraints () {
        movieImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        movieImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        movieImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        movieImage.heightAnchor.constraint(equalToConstant: 175).isActive = true
        
        movieTitleLbl.topAnchor.constraint(equalTo: movieImage.bottomAnchor, constant: 8).isActive = true
        movieTitleLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        movieTitleLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        movieDescriptionLbl.topAnchor.constraint(equalTo: movieTitleLbl.bottomAnchor, constant: 0).isActive = true
        movieDescriptionLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        movieDescriptionLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        movieDescriptionLbl.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }
}
