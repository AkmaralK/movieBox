//
//  ViewController.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 12/23/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit
import SkeletonView
import SDWebImage

class MainViewController: UIViewController, UniqueIdHelper, Alertable {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Props
    
    static var uniqueID = "MainViewController"
    
    private var data: [MoviesSectionTypes: DataSection<MediaData>] = MoviesSectionTypes.allCases.reduce(into: [MoviesSectionTypes: DataSection]()) {
        $0[$1] = DataSection(data: [], isLoading: true)
    }
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpUI()
        self.loadData()
    }
    
    // MARK: - Private methods
    
    private func setUpTableView () {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    private func setUpUI () {
        self.view.backgroundColor = UIColor.darkColor
    }
    
    // MARK: - Navigation
    
    private func loadData () {
        MoviesSectionTypes.allCases.forEach { (type) in
            ApiService.movieLoader.loadMovieShowBySection(mediaType: type.mediaType, section: type, complitionHandler: { (moviesResponse) in
                self.data[type]!.data = moviesResponse.results
                self.data[type]?.isLoading = false
                self.data[type]?.next(totalPages: moviesResponse.total_pages)
                self.tableView.reloadData()
            }) { (msg) in
                self.showAlert("Error", msg)
            }
        }
    }
    
    private func doPagination (sectionIndex: Int) {
        let moviesSectionTypeIndex = data.keys.index(data.keys.startIndex, offsetBy: sectionIndex)
        let movieSectionType = data.keys[moviesSectionTypeIndex]

        let movieSectionData = data[movieSectionType]
        self.data[movieSectionType]?.isLoading = true
        self.tableView.reloadData()


        ApiService.movieLoader.loadMovieShowBySection(mediaType: movieSectionType.mediaType, section: movieSectionType, page: movieSectionData?.page ?? 1, complitionHandler: { (movieResponse) in
            self.data[movieSectionType]?.data.append(contentsOf: movieResponse.results)
            self.data[movieSectionType]?.isLoading = false
            self.data[movieSectionType]?.next(totalPages: movieResponse.total_pages)
            self.tableView.reloadData()
        }, complitionHandlerError: { (msg) in
            self.showAlert("Error", msg)
        })
    }
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.uniqueID) as! MainTableViewCell
        let movieData = data.values[data.values.index(data.values.startIndex, offsetBy: indexPath.row)]
        let sectionTitle = data.keys[data.keys.index(data.keys.startIndex, offsetBy: indexPath.row)].title
        
        
        cell.sectionView.titleLabel.text = sectionTitle
        cell.sectionView.subtitleLabel.text = "\(movieData.data.count) видео"
        cell.moviesCollectionView.delegate = self
        cell.moviesCollectionView.dataSource = self
        cell.moviesCollectionView.tag = indexPath.row
        cell.moviesCollectionView.reloadData()
        
        cell.selectionStyle = .none
        return cell
    }
}


extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let movieData = data.values[data.values.index(data.values.startIndex, offsetBy: collectionView.tag)]
        return movieData.isLoading ? movieData.data.count + 3 : movieData.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movieData = data.values[data.values.index(data.values.startIndex, offsetBy: collectionView.tag)]
        let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCell
        
        if movieData.isLoading && indexPath.row >= movieData.data.count {
            movieCell.showCellSkeleton()
        } else {
            movieCell.hideCellSkeleton()
            movieCell.movieImage.sd_setImage(with: URL(string: movieData.data[indexPath.row].imageUrl ?? ""))
            movieCell.movieTitleLbl.text = movieData.data[indexPath.row].title
            movieCell.movieDescriptionLbl.text = movieData.data[indexPath.row].date
        }
        
        return movieCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let movieData = data.values[data.values.index(data.values.startIndex, offsetBy: collectionView.tag)]
        
        if let movieVC = storyboard.instantiateViewController(withIdentifier: MovieViewController.uniqueID) as? MovieViewController {
            movieVC.media = movieData.data[indexPath.row]
            self.navigationController?.pushViewController(movieVC, animated: true)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let contentWidth = scrollView.contentSize.width
        if (scrollView is UICollectionView) {
            if contentWidth < offsetX + scrollView.frame.size.width + 200 {
                let movieData = data.values[data.values.index(data.values.startIndex, offsetBy: scrollView.tag)]
                if (!movieData.isFinished) {
                    doPagination(sectionIndex: scrollView.tag)
                }
            }
        }
    }
}
