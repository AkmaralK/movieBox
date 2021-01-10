//
//  SearchViewController.swift
//  MovieBox
//
//  Created by Akmaral on 12/25/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//
import UIKit
import SDWebImage

final class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var tvShowCollectionView: UICollectionView!
    private var movieLoader = MovieLoader()
    private var tvLoader = TVLoader()
    private var movies = [ResultMovie]()
    private var tvShows = [ResultTV]()
    let searchBar = UISearchBar()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(
          self,
          selector: #selector(updateMovies),
          name: Notification.Name("movieNotification"),
          object: nil)
        setUpNavBar()
        movieLoader.getMovieDetails()
        tvLoader.getTVDetails()
        
    }
    
    @objc func updateMovies(notification: Notification) {
        if let movies = notification.object as? [ResultMovie] {
            self.movies = movies
            movieCollectionView.reloadData()
        } else if let tvShows = notification.object as? [ResultTV] {
                self.tvShows = tvShows
                tvShowCollectionView.reloadData()
            }
    }

        func setUpNavBar() {
            searchBar.delegate = self
            searchBar.sizeToFit()
            searchBar.searchBarStyle = .minimal
            searchBar.placeholder = "Search MovieBox"
            searchBar.backgroundColor = UIColor.darkColor
            navigationItem.titleView = searchBar
            searchBar.isTranslucent = true
        }
    

    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        if let searchVC = storyboard.instantiateViewController(withIdentifier: SearchTableViewController.uniqueID) as? SearchTableViewController {
            self.present(UINavigationController(rootViewController: searchVC), animated: false, completion: nil)
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == movieCollectionView {
            return movies.count
        } else if collectionView == tvShowCollectionView {
            return tvShows.count
        } else {
            return 1
        }
    }


     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == movieCollectionView {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchMovieCell
            cell.nameLabel.text = movies[indexPath.row].originalTitle
            let posterPath = movies[indexPath.row].posterPath
            cell.movieImage.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)"), placeholderImage: UIImage(named: "placeholder.png"))
                return cell
            } else if collectionView == tvShowCollectionView {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchTVCell", for: indexPath) as! SearchMovieCell
                cell.tvLabel.text = tvShows[indexPath.row].originalName
                let posterPath = tvShows[indexPath.row].posterPath
                cell.tvImage.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)"), placeholderImage: UIImage(named: "placeholder.png"))
                return cell
            } else {
                return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item + 1)
    }
}
