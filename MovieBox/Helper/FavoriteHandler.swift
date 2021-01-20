//
//  FavoriteHandler.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 1/20/21.
//  Copyright © 2021 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol FavoriteHandler: UIViewController, Alertable {}

extension FavoriteHandler {

    func addToFavorite (movie: MediaData) {
        if let user = Auth.auth().currentUser {
            ApiService.shared.addToFavorite(userUID: user.uid, mediaData: movie, completionHandler: { (_) in
                
//                AppStore.shared.favMovies.append(<#T##newElement: MediaData##MediaData#>)
                self.updateAllMovies(index: movie.id, isFavorite: true)
            }) { (msg) in
                self.showAlert("Error", msg)
            }
        } else {
            self.showAlert("Error", "You have to sign in")
        }
    }
    
    fileprivate func updateAllMovies (index: Int, isFavorite: Bool) {
        if let tabBarController = self.tabBarController {
            updateFirstTab(index: index, isFavorite: isFavorite)
        }
    }
    
    fileprivate func updateFirstTab (index: Int, isFavorite: Bool) {
        let navController = tabBarController!.viewControllers![0] as! UINavigationController
        
        navController.viewControllers.forEach { (vc) in
            if (vc is MainViewController) {
                updateMainVC(index: index, isFavorite: isFavorite, movieVC: vc as! MainViewController)
            } else if (vc is MovieViewController) {
                updateMovieVC(index: index, isFavorite: isFavorite, movieVC: vc as! MovieViewController)
            }
        }
    }
    
    fileprivate func updateMainVC (index: Int, isFavorite: Bool, movieVC: MainViewController) {
        for (i, el) in movieVC.data.values.enumerated() {
            for (k, _) in el.data.enumerated() {
                if (el.data[k].id == index) {
                    movieVC.data[movieVC.data.keys[movieVC.data.keys.index(movieVC.data.keys.startIndex, offsetBy: i)]]?.data[k].isFavorite = isFavorite
                }
            }
        }
        
        movieVC.tableView.reloadData()
    }
    
    fileprivate func updateMovieVC (index: Int, isFavorite: Bool, movieVC: MovieViewController) {
        for (i, _) in movieVC.recommendedMovies.data.enumerated() {
            if (movieVC.recommendedMovies.data[i].id == index) {
                movieVC.recommendedMovies.data[i].isFavorite = isFavorite
            }
        }
    }
}
