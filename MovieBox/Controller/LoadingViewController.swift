//
//  LoadingViewController.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 1/1/21.
//  Copyright © 2021 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

final class LoadingViewController: UIViewController, Alertable, UniqueIdHelper {
    
    static var uniqueID: String = "LoadingViewController"
    
    var loadedGenresByMediaType: [MediaType: Bool] = [
        MediaType.tv : false, MediaType.movie : false
    ]
    
    var loadedGenres: Bool {
        var loaded = true
        
        MediaType.allCases.forEach { (mediaType) in
            loaded = loadedGenresByMediaType[mediaType] ?? false
        }
        
        return loaded
    }
    
    lazy var loadingLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Loading..."
        lbl.textColor = .red
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(loadingLbl)
        self.view.backgroundColor = .darkColor
        
        loadingLbl.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        loadGenres()
    }
    
    // MARK: - Networking
    
    private func loadGenres () {
        MediaType.allCases.forEach { (mediaType) in
            ApiService.shared.loadGenres(mediaType: mediaType, complitionHandler: { (genres) in
                AppStore.shared.genres.append(contentsOf: genres)
                self.loadedGenresByMediaType[mediaType] = true
                
                if (self.loadedGenres) {
                    self.loadedEverythingCallback()
                }
            }) { (errorMsg) in
                self.showAlert("Error", errorMsg)
            }
        }
    }
    
    private func loadedEverythingCallback () {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: MainViewController.uniqueID) as! UITabBarController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
