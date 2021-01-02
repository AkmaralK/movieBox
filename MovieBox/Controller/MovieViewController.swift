//
//  MovieViewController.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 12/24/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit
import MBCircularProgressBar

final class MovieViewController: UIViewController, UniqueIdHelper, Alertable {
    
    // MARK: - Oulets
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLbl: UILabel!
    @IBOutlet weak var movieDesLbl: UILabel!
    @IBOutlet weak var genresStackView: UIStackView!
    @IBOutlet weak var aboutSectionView: SectionView!
    @IBOutlet weak var castSectionView: SectionView!
    @IBOutlet weak var otherMovies: SectionView!
    @IBOutlet weak var factsSectionView: SectionView!
    @IBOutlet weak var progressView: MBCircularProgressBarView!
    
    lazy var aboutLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = .systemFont(ofSize: 14)
        lbl.numberOfLines = 0
        lbl.alpha = 0.6
        return lbl
    }()
    
    lazy var castCollectionView: PersonList = {
        let collectionView = PersonList()
        collectionView.setUp()
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    lazy var otherMoviesCollectionView: MoviesList = {
        let collectionView = MoviesList()
        collectionView.setUp()
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    lazy var factItemsView: ItemsStackView = {
        let itemsStackView = ItemsStackView(itemViews: factsData.map({ (fact) -> ItemView in
            let itemView = ItemView()
            itemView.titleLbl.text = fact.1
            itemView.subtitleLbl.text = fact.0
            return itemView
        }))
        
        return itemsStackView
    }()
    
    // MARK: - Props
    
    var media: MediaData!
    
    static var uniqueID: String = "MovieViewController"
    
    private var recommendedMovies: DataSection<MediaData> = DataSection(
        data: [],
        page: 1,
        isLoading: true,
        isFinished: false
    )
    
    private var castActors: DataSection<Person> = DataSection(
        data: [],
        page: 1,
        isLoading: true,
        isFinished: false
    )
    
    private var mediaType: MediaType {
        return media is Movie ? MediaType.movie : MediaType.tv
    }
    
    private var factsData: [(String, String)] {
        return [
            ("Исходное название",  media.title),
            ("Исходное название",  media.title),
            ("Исходное название",  media.title),
        ]
    }
    
    // MARK: - UI
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.updateUI()
        self.loadRecommended()
        self.loadPeople()
    }
    
    private func setUpUI () {
        self.view.backgroundColor = UIColor.darkColor
        setUpSectionView(sectionView: aboutSectionView, title: "Подробнее", subtitle: "Обзор", subview: aboutLbl)
        setUpSectionView(sectionView: castSectionView, title: "Актерский состав", subtitle: "TOP BILLED CAST", subview: castCollectionView)
        setUpSectionView(sectionView: otherMovies, title: "Похоже фильмы", subtitle: "мотрите вместе с нами", subview: (otherMoviesCollectionView))
        setUpSectionView(sectionView: factsSectionView, title: "Факты", subtitle: "Могут быть интересными", subview: factItemsView)
        
        aboutLbl.snp.makeConstraints { (make) in
            make.bottom.top.leading.trailing.equalToSuperview()
        }
        
        castCollectionView.snp.makeConstraints { (make) in
            make.bottom.top.leading.trailing.equalToSuperview()
            make.height.equalTo(250)
        }

        otherMoviesCollectionView.snp.makeConstraints { (make) in
            make.bottom.top.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }
        
        factItemsView.snp.makeConstraints { (make) in
            make.bottom.top.leading.trailing.equalToSuperview()
        }
        
        setUpMovieBackground()
        generateGenreChips()
    }
    
    private func updateUI () {
        self.movieImageView.sd_setImage(with: URL(string: media.bigImageUrl ?? ""))
        self.movieTitleLbl.text = media.title
        self.movieDesLbl.text = media.date
        self.progressView.value = CGFloat(10 * media.voteAverage)
        self.aboutLbl.text = media.overview 
    }
    
    private func setUpSectionView (
        sectionView: SectionView,
        title: String,
        subtitle: String,
        subview: UIView
    ) {
        sectionView.setUp()
        sectionView.titleLabel.text = title
        sectionView.subtitleLabel.text = subtitle
        sectionView.contentView.addSubview(subview)
    }
    
    private func generateGenreChips () {
        genresStackView.alignment = .leading
        genresStackView.distribution = .fillEqually
        
        media.genres.forEach { (genre) in
            let genreChipView = createGenreChip (genre: genre)
            genresStackView.addArrangedSubview(genreChipView)
        }
    }
    
    private func createGenreChip (genre: Genre) -> ChipView {
        let chipView = ChipView()
        chipView.titleLbl.text = genre.name
        return chipView
    }
    
    private func setUpMovieBackground () {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.movieImageView.bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        self.movieImageView.layer.addSublayer(gradientLayer)
    }
}

// MARK: - Networking

extension MovieViewController {
    private func loadRecommended () {
        ApiService.movieLoader.loadRecommendationsMovie(mediaType: mediaType, id: media.id, complitionHandler: { (movieResponse) in
            self.recommendedMovies.isLoading = false
            self.recommendedMovies.next(totalPages: movieResponse.total_pages)
            self.recommendedMovies.data = movieResponse.results
            self.otherMoviesCollectionView.reloadData()
        }) { (msg) in
            self.showAlert("Error", msg)
        }
    }
    
    private func paginatieRecommended () {
        recommendedMovies.isLoading = true
        self.otherMoviesCollectionView.reloadData()

        ApiService.movieLoader.loadRecommendationsMovie(mediaType: mediaType, id: media.id, page: recommendedMovies.page, complitionHandler: { (movieResponse) in
            self.recommendedMovies.isLoading = false
            self.recommendedMovies.next(totalPages: movieResponse.total_pages)
            self.recommendedMovies.data.append(contentsOf: movieResponse.results)
            self.otherMoviesCollectionView.reloadData()
        }) { (msg) in
            self.showAlert("Error", msg)
        }
    }
    
    private func loadPeople () {
        ApiService.shared.loadCastPeople(mediaType: mediaType, movieID: media.id, complitionHandler: { (personsResponse) in
            self.castActors.data = personsResponse.cast
            self.castActors.isFinished = true
            self.castActors.isLoading = false
            self.castCollectionView.reloadData()
        }) { (msg) in
            self.showAlert("Error", msg)
        }
    }
}


// MARK: - Collection View

extension MovieViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView is PersonList) {
            if (castActors.isLoading) {
                return castActors.data.count + 3
            } else {
                return castActors.data.count
            }
        } else if (collectionView is MoviesList) {
            if (recommendedMovies.isLoading) {
                return recommendedMovies.data.count + 3
            } else {
                return recommendedMovies.data.count
            }
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (collectionView is PersonList) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "personCell", for: indexPath) as! PersonCell
            
            if (castActors.isLoading && indexPath.row >= castActors.data.count) {
                cell.showCellSkeleton()
            } else {
                let personData = castActors.data[indexPath.row]
                cell.hideCellSkeleton()
                cell.avatarImage.sd_setImage(with: URL(string: personData.avatarURL))
                cell.personNameLbl.text = personData.name
                cell.personDescriptionLbl.text = personData.characterName
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCell
            
            if (recommendedMovies.isLoading && indexPath.row >= recommendedMovies.data.count) {
                cell.showCellSkeleton()
            } else {
                let movie = recommendedMovies.data[indexPath.row]
                cell.hideCellSkeleton()
                cell.movieTitleLbl.text = movie.title
                cell.movieDescriptionLbl.text = movie.date
                cell.movieImage.sd_setImage(with: URL(string: movie.imageUrl ?? ""))
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView is MoviesList) {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            if let movieVC = storyboard.instantiateViewController(withIdentifier: MovieViewController.uniqueID) as? MovieViewController {
                movieVC.media = recommendedMovies.data[indexPath.row]
                self.navigationController?.pushViewController(movieVC, animated: true)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if (scrollView == otherMoviesCollectionView) {
            let offsetX = scrollView.contentOffset.x
            let contentWidth = scrollView.contentSize.width
            
            if contentWidth < offsetX + scrollView.frame.size.width + 200 {
                if (!recommendedMovies.isFinished) {
                    paginatieRecommended()
                }
            }
        }
    }
}
