//
//  MovieViewController.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 12/24/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

final class MovieViewController: UIViewController {
    @IBOutlet weak var movieImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    private func setUpUI () {
        self.view.backgroundColor = UIColor.darkColor
        setUpMovieBackground()
    }
    
    private func setUpMovieBackground () {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.movieImageView.bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        self.movieImageView.layer.addSublayer(gradientLayer)
    }
}
