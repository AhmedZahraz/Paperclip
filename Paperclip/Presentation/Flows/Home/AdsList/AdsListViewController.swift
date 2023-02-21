//
//  AdsListViewController.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 15/02/2023.
//

import Foundation
import UIKit
import Combine

class AdsListViewController: UICollectionViewController {
    
    // MARK: - Properties
    lazy var dataSource = makeDataSource()
    private var viewModel: AdsListViewModel?
    private var coordintor: AdsListCoordinator?
    
    private var offset = 0
    private let limit = 20
    
    private let refreshControl = UIRefreshControl()
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)

    
    // MARK: - Types
    enum Section: Int, CaseIterable, Hashable {
        case all
    }
    typealias DataSource = UICollectionViewDiffableDataSource<Section, AdItem>
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Create
    static func create(with viewModel: AdsListViewModel,
                       coordintor: AdsListCoordinator) -> AdsListViewController {
        let view = AdsListViewController(collectionViewLayout: UICollectionViewFlowLayout())
        view.viewModel = viewModel
        view.coordintor = coordintor
        return view
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("adslist_screen_title", comment: "")
        
        configureRefreshControl()
        configureLoadingView()
        configureLayout()
        initDataSource()
        
        bind(to: self.viewModel)
        loadData()
    }
    
    deinit {
        print("deinit AdsListViewController")
    }
    
    // MARK: - Functions
    
    private func loadData() {
        viewModel?.loadAds(offset: offset, limit: limit)
    }
    
    @objc
    private func didPullToRefresh(_ sender: Any) {
        offset = 0
        loadData()
    }
    
    private func bind(to viewModel: AdsListViewModel?) {
        viewModel?.adsStatePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] state in
                print(" NEW state !!")
                switch state {
                case .none:
                    print("none")
                case .loading:
                    self?.refreshControl.beginRefreshing()
                    self?.activityIndicatorView.startAnimating()
                    print("Show loading view")
                case .success(let ads):
                    print("success got ads")
                    self?.refreshControl.endRefreshing()
                    self?.activityIndicatorView.stopAnimating()
                    self?.updateSnapshot(with: ads)
                case .error:
                    self?.refreshControl.endRefreshing()
                    self?.activityIndicatorView.stopAnimating()
                    self?.coordintor?.showError { [weak self] _ in
                        self?.loadData()
                    }
                    print("Error in loading ads")
                }
            })
            .store(in: &cancellables)
    }
  
  
    private func configureLayoutOLD() {
        let configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        collectionView.collectionViewLayout =
        UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    private func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
    }
    
    private func configureLoadingView() {
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func configureLayout() {
      collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
        let isPhone = layoutEnvironment.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone
        let size = NSCollectionLayoutSize(
          widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
          heightDimension: NSCollectionLayoutDimension.absolute(isPhone ? 280 : 250)
        )
        let itemCount = isPhone ? 2 : 3
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: itemCount)
          group.interItemSpacing = .fixed(10)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 10
        return section
      })
    }
    
    private func initDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AdItem>()
        snapshot.appendSections([.all])
        snapshot.appendItems([])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    /// Configured Ad cell
    /// - Returns: Cell configuration
    private let adCell = UICollectionView.CellRegistration<AdItemCollectionViewCell, AdItem> { cell, indexPath, item in
        cell.configure(with: item)
    }
    
    private func makeDataSource() -> DataSource {
        return DataSource(collectionView: collectionView) { [weak self]
            collectionView, indexPath, item -> UICollectionViewCell? in
            
            guard let strongSelf = self else { fatalError("CollectionView isn't here :(") }
            return collectionView.dequeueConfiguredReusableCell(
                using: strongSelf.adCell, for: indexPath, item: item)
        }
    }
    
    func updateSnapshot(with ads: [AdItem]) {
        if offset == 0 && collectionView.numberOfItems(inSection: 0) > 0 {
            var adSnapshot = dataSource.snapshot()
            
            adSnapshot.deleteAllItems()
            
            adSnapshot.appendSections([.all])
            adSnapshot.appendItems(ads, toSection: .all)
            dataSource.apply(adSnapshot, animatingDifferences: false)
            return
        }
        
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(ads, toSection: .all)
        dataSource.apply(snapshot, animatingDifferences: true)
        
    }
}

// MARK: - UICollectionViewDelegate
extension AdsListViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        print("Tapped item With id " + String(item.id))
        coordintor?.showAdDetails(with: item.id)
    }
}

extension AdsListViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let snapshot = dataSource.snapshot()
        guard let _ = snapshot.indexOfSection(.all) else { return }
        let itemsCount = snapshot.numberOfItems(inSection: .all)

        if indexPath.row == itemsCount - 1 {
            print("Load More items ....")
            offset += limit
            loadData()
        }
    }
}

