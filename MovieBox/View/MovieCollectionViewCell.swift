//
//  MovieCollectionViewCell.swift
//  MovieBox
//
//  Created by Бейбарыс Шагай on 12/27/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    func setup(with movie: Movie) {
        movieImageView.image = UIImage(named: "movieImg")
        nameLabel.text = movie.name
    }
}
