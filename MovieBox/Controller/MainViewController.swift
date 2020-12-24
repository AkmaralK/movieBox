//
//  ViewController.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 12/23/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var popularMoviesCollectionView: MoviesList!
    @IBOutlet weak var bestMoviesCollectionView: MoviesList!
    @IBOutlet weak var popularShowsCollectionView: MoviesList!
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionViews()
        setUpUI()
    }
    
    // MARK: - Private methods
    
    private func setUpCollectionViews () {
        for collectionView in [bestMoviesCollectionView, popularMoviesCollectionView, popularShowsCollectionView] {
            collectionView?.setUp()
            collectionView?.delegate = self
            collectionView?.dataSource = self
        }
    }
    
    private func setUpUI () {
        self.view.backgroundColor = UIColor.darkColor
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Movie.getFakeMovies().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let fakeData = Movie.getFakeMovies()
        
        let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCell
        movieCell.movieImage.image = UIImage(named: "movieImg")
        movieCell.movieTitleLbl.text = fakeData[indexPath.row].name
        movieCell.movieDescriptionLbl.text = fakeData[indexPath.row].date
        return movieCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "movieDetails", sender: nil)
    }
}
