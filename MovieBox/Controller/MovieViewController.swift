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
    
    // MARK: - Props
    
    private let movie = Movie.getFakeMovies()[0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    private func setUpUI () {
        self.view.backgroundColor = UIColor.darkColor
        aboutSectionView.setUp()
        castSectionView.setUp()
        otherMovies.setUp()
        
        aboutSectionView.titleLabel.text = "Подробнее"
        aboutSectionView.subtitleLabel.text = "Обзор"
        aboutSectionView.contentView.addSubview(aboutLbl)
        aboutLbl.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        castSectionView.titleLabel.text = "Актерский состав"
        castSectionView.subtitleLabel.text = "TOP BILLED CAST"
        castSectionView.contentView.addSubview(castCollectionView)
        castCollectionView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview()
            make.height.equalTo(250)
        }
        
        otherMovies.titleLabel.text = "Похоже фильмы"
        otherMovies.subtitleLabel.text = "Смотрите вместе с нами"
        otherMovies.contentView.addSubview(otherMoviesCollectionView)
        otherMoviesCollectionView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview()
            make.height.equalTo(300)
        }
        
        setUpMovieBackground()
        generateGenreChips()
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
        return collectionView is PersonList ? Person.getFake().count : Movie.getFakeMovies().count
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
            let movie = Movie.getFakeMovies()[indexPath.row]

            cell.movieTitleLbl.text = movie.name
            cell.movieDescriptionLbl.text = movie.date
            return cell
        }
    }
}
