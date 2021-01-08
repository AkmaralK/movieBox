//
//  EpisodeViewController.swift
//  MovieBox
//
//  Created by erkebulan elzhan on 1/8/21.
//  Copyright © 2021 Yerkebulan Yelzhan. All rights reserved.
//

import UIKit
import SkeletonView

final class EpisodeViewController: UIViewController, Alertable {
    
    // MARK: - Outlets
    
    fileprivate lazy var seasonsCollectionView: UICollectionView = {
        let horizontalLayout = UICollectionViewFlowLayout()
        horizontalLayout.itemSize = CGSize(width: 40, height: 64)
        horizontalLayout.minimumLineSpacing = 16
        horizontalLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: horizontalLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(EpisodeNumberCell.self, forCellWithReuseIdentifier: EpisodeNumberCell.uniqueID)
        collectionView.backgroundColor = .darkColor
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: EpisodeCell.uniqueID)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .black
        return tableView
    }()
    
    // MARK: - Props
    
    var tvID: Int!
    var numberOfSeasons: Int!
    var currentSeason: Int!
    var currentEpisodes: [Episode] = []
    fileprivate var isLoading: Bool = true
    
    // MARK: - Life-Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.title = "Seasons"
        self.view.backgroundColor = .black
        self.setUpUI()
        self.loadData(seasonID: self.currentSeason)
        self.seasonsCollectionView.scrollToItem(at: IndexPath(row:  self.currentSeason - 1, section: 0), at: .left, animated: true)
    }
    
    // MARK: - UI
    
    fileprivate func setUpUI () {
        self.view.addSubview(seasonsCollectionView)
        self.view.addSubview(tableView)
        
        seasonsCollectionView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(64)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(seasonsCollectionView.snp.bottom)
        }
    }
}

// MARK: - Network

extension EpisodeViewController {
    fileprivate func loadData (seasonID: Int) {
        preLoadHandler()
        
        ApiService.shared.getEpisodes(tvID: tvID, seasonID: seasonID, completionHandler: { (episodes) in
            self.dataHandler(episodes: episodes)
        }) { (msg) in
            self.errorHandler(error: msg)
        }
    }
    
    fileprivate func preLoadHandler () {
        self.currentEpisodes = []
        self.isLoading = true
        self.tableView.reloadData()
    }
    
    fileprivate func dataHandler (episodes: [Episode]) {
        self.isLoading = false
        self.currentEpisodes = episodes
        self.tableView.reloadData()
    }
    
    fileprivate func errorHandler (error: String) {
        self.showAlert("Error", error)
    }
}


// MARK: - CollectionView: Season Number Selector

extension EpisodeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfSeasons
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodeNumberCell.uniqueID, for: indexPath) as! EpisodeNumberCell
        cell.titleLbl.text = "\(indexPath.row + 1)"
        
        cell.lineView.isHidden = indexPath.row + 1 != self.currentSeason
        cell.titleLbl.textColor = indexPath.row + 1 != self.currentSeason ? .gray : .white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (self.currentSeason != indexPath.row + 1) {
            self.currentSeason = indexPath.row + 1
            self.loadData(seasonID: self.currentSeason)
            self.seasonsCollectionView.reloadData()
        }
    }
}


extension EpisodeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isLoading ? 3 : self.currentEpisodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeCell.uniqueID, for: indexPath) as! EpisodeCell
        cell.selectionStyle = .none
        
        if (isLoading) {
            cell.showSkeleton()
        } else {
            let episode = currentEpisodes[indexPath.row]
            
            cell.hideSkeleton()
            cell.episodeImageView.sd_setImage(with: URL(string: episode.imageURL ?? ""), placeholderImage: UIImage(named: "moviePlaceholder"))
            cell.episodeLbl.text = "EPISODE \(episode.episodeNumber)"
            cell.titleLbl.text = episode.title
        }
        
        return cell
    }
}



final class EpisodeNumberCell: UICollectionViewCell, UniqueIdHelper {
    static var uniqueID: String = "episodeNumberCell"
    
    fileprivate lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 20, weight: .bold)
        lbl.textColor = .gray
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.snp.makeConstraints { (make) in
            make.width.equalTo(12)
            make.height.equalTo(3)
        }
        return view
    }()
    
    override func didMoveToSuperview() {
        if (superview != nil) {
            setUpUI()
        }
    }
    
    fileprivate func setUpUI () {
        self.contentView.addSubview(containerView)
        
        containerView.addSubview(titleLbl)
        containerView.addSubview(lineView)
        
        lineView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
        }
        
        titleLbl.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(lineView).offset(-4)
            make.top.equalToSuperview().offset(5)
        }
        
        containerView.snp.makeConstraints { (make) in
            make.leading.trailing.centerY.equalToSuperview()
        }
    }
}


final class EpisodeCell: UITableViewCell, UniqueIdHelper {
    
    static var uniqueID: String = "episodeCell"
    
    lazy var episodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isSkeletonable = true
        return imageView
    }()
    
    lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14, weight: .regular)
        lbl.numberOfLines = 0
        lbl.textColor = .white
        lbl.isSkeletonable = true
        return lbl
    }()
    
    lazy var episodeLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .red
        lbl.font = .systemFont(ofSize: 13)
        lbl.isSkeletonable = true
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showCellSkeleton () {
        let gradient = SkeletonGradient(baseColor: UIColor.wetAsphalt)
        
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        episodeImageView.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
        
        titleLbl.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
        episodeLbl.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
    }
    
    func hideCellSkeleton () {
        episodeImageView.hideSkeleton()
        titleLbl.hideSkeleton()
        episodeLbl.hideSkeleton()
    }
    
    fileprivate func setUp () {
        self.contentView.addSubview(episodeImageView)
        self.contentView.addSubview(titleLbl)
        self.contentView.addSubview(episodeLbl)
        
        self.backgroundColor = .black
        
        episodeImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(16)
            make.height.equalTo(80)
            make.width.equalTo(160)
        }
        
        episodeLbl.snp.makeConstraints { (make) in
            make.leading.equalTo(episodeImageView.snp.trailing).offset(16)
            make.top.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().inset(20)
        }
        
        titleLbl.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(20)
            make.leading.equalTo(episodeImageView.snp.trailing).offset(16)
            make.top.equalTo(episodeLbl.snp.bottom).offset(4)
        }
    }
}
