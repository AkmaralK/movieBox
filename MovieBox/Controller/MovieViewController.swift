//
//  MovieViewController.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 12/24/20.
//  Copyright © 2020 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit

final class MovieViewController: UIViewController {
    
    // MARK: - Oulets
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var genresStackView: UIStackView!
    @IBOutlet weak var aboutSectionView: SectionView!
    @IBOutlet weak var castSectionView: SectionView!
    @IBOutlet weak var otherMovies: SectionView!
    @IBOutlet weak var factsSectionView: SectionView!
    
    lazy var aboutLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = .systemFont(ofSize: 14)
        lbl.numberOfLines = 0
        lbl.alpha = 0.6
        lbl.text = "Отец Вергара, бывший боксёр с криминальным прошлым, прослывший экзорцистом, сослан на службу в отдалённый испанский городок. Вергара стремится забыть тёмные моменты прошлого и начать новую жизнь, но в городке начинают твориться необъяснимые вещи. Священнослужитель, с помощью мэра и местного любознательного ветеринара пытающийся найти объяснение странностям, натыкается на древнюю монету. Некоторые реликвии прокляты, и, оказавшись не в тех руках, могут разрушить устоявшийся мировой порядок."
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
    
    private let movie = Movie.getFakeMovies()[0]
    
    private let recommendedMovies = Movie.getFakeMovies()
    
    private var factsData: [(String, String)] {
        return [
            ("Исходное название",  movie.name),
            ("Исходное название",  movie.name),
            ("Исходное название",  movie.name),
        ]
    }
    
    // MARK: - UI
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
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
        
        movie.genres.forEach { (genre) in
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

extension MovieViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView is PersonList ? Person.getFake().count : recommendedMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (collectionView is PersonList) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "personCell", for: indexPath) as! PersonCell
            let personData = Person.getFake()[indexPath.row]

            cell.personNameLbl.text = personData.name
            cell.personDescriptionLbl.text = personData.characterName
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCell
            let movie = recommendedMovies[indexPath.row]

            cell.movieTitleLbl.text = movie.name
            cell.movieDescriptionLbl.text = movie.date
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView is MoviesList) {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            if let movieVC = storyboard.instantiateViewController(withIdentifier: "MovieViewController") as? MovieViewController {
                self.navigationController?.pushViewController(movieVC, animated: true)
            }
        }
    }
}
