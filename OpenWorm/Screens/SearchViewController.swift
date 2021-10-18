//
//  SearchViewController.swift
//  OpenWorm
//
//  Created by Pierre-Jean Quilleré on 2021-10-17.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let emptyStateView = EmptyStateView()
    
    private lazy var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        #warning("TODO: loading state")
        #warning("TODO: display content in collection view (see assignment for details)")
        #warning("TODO: empty state when no content")
        
        configureCollectionView()
        configureEmptyStateView()
        configureSearchController()
    }
    
    private func searchBook(_ query: String) {
        let endpoint = SearchEndpoint.query(query)
        OpenLibraryClient().fetch(endpoint, into: Book.Response.self) { result in
            switch result {
            case .success(let response):
                print(response.docs)
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.present(error: error)
                }
            }
        }
    }
    
    private func configureEmptyStateView() {
        view.addSubview(emptyStateView)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        let vm = EmptyStateView.ViewModel(
            title: "Welcome to OpenWorm",
            message: "Wormie is here to help you find books in the biggest library.\n\nStart your journey by tapping on the search bar."
        )
        emptyStateView.update(with: vm)
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for books..."
        navigationItem.searchController = searchController
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let inset: CGFloat = 8
        
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.42), heightDimension: .fractionalWidth(0.7))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: 0, bottom: inset, trailing: 0)
        section.orthogonalScrollingBehavior = .groupPaging
        
        // Header
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        headerItem.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [headerItem]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.register(BookCoverCell.self, forCellWithReuseIdentifier: BookCoverCell.reuseIdentifier)
        collectionView.register(BookSearchHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BookSearchHeaderView.reuseIdentifier)
    }

}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        searchBook(query)
    }
}
