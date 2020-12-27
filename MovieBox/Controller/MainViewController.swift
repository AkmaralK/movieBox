//
//  ViewController.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 12/23/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    struct MoviesSection {
        let name: String
        let movies: [Movie]
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Init
    
    private let fakeMoviesSections = ["Best movies", "Popular movies", "Best shows"].map {
        return MoviesSection(name: $0, movies: Movie.getFakeMovies())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpUI()
    }
    
    // MARK: - Private methods
    
    private func setUpTableView () {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
//    private func setUpCollectionViews () {
//        for collectionView in [bestMoviesCollectionView, popularMoviesCollectionView, popularShowsCollectionView] {
//            collectionView?.setUp()
//            collectionView?.delegate = self
//            collectionView?.dataSource = self
//        }
//    }
    
    private func setUpUI () {
        self.view.backgroundColor = UIColor.darkColor
    }
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fakeMoviesSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell") as! MainTableViewCell
        cell.sectionView.titleLabel.text = fakeMoviesSections[indexPath.row].name
        cell.sectionView.subtitleLabel.text = "\(fakeMoviesSections[indexPath.row].movies.count) видео"
        cell.moviesCollectionView.delegate = self
        cell.moviesCollectionView.dataSource = self
        return cell
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
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        if let movieVC = storyboard.instantiateViewController(withIdentifier: "MovieViewController") as? MovieViewController {
            self.navigationController?.pushViewController(movieVC, animated: true)
        }
    }
}
