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
    private lazy var dataSource = SearchDataSource(collectionView: collectionView)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        #warning("TODO: loading state")
        
        configureCollectionView()
        configureEmptyStateView()
        configureSearchController()
    }
    
    private func searchBook(_ query: String) {
        let endpoint = SearchEndpoint.query(query)
        OpenLibraryClient().fetch(endpoint, into: Book.Response.self) { result in
            switch result {
            case .success(let response):
                self.dataSource.update(with: response.docs)
                DispatchQueue.main.async {
                    self.updateEmptyState()
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.present(error: error)
                }
            }
        }
    }
    
    private func updateEmptyState() {
        let hasResults = !dataSource.isEmpty
        if !hasResults {
            emptyStateView.update(with: .init(title: "No Results", message: "There are no results for your search."))
        }
        emptyStateView.isHidden = hasResults
    }
    
    private func resetToWelcomeState() {
        // remove results from screen
        dataSource.resetData()
        
        // animate back to the welcome screen
        let animations = {
            let vm = self.welcomeStateViewModel()
            self.emptyStateView.update(with: vm)
            self.emptyStateView.isHidden = false
        }
        UIView.transition(with: view, duration: 0.25, options: [.transitionCrossDissolve], animations: animations)
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
        
        emptyStateView.update(with: welcomeStateViewModel())
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for books..."
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let inset: CGFloat = 8
        
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.42), heightDimension: .fractionalWidth(0.8))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: 0, bottom: inset, trailing: 0)
        section.orthogonalScrollingBehavior = .groupPaging
        
        // Header
        let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        headerItem.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [headerItem]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = .systemBackground
        
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.register(BookCoverCell.self, forCellWithReuseIdentifier: BookCoverCell.reuseIdentifier)
        collectionView.register(BookSearchHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BookSearchHeaderView.reuseIdentifier)
    }
    
    private func welcomeStateViewModel() -> EmptyStateView.ViewModel {
        EmptyStateView.ViewModel(
            title: "Welcome to OpenWorm",
            message: "Wormie is here to help you find books in the biggest library.\n\nStart your journey by tapping on the search bar."
        )
    }

}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        searchBook(query)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resetToWelcomeState()
    }
}

extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let book = dataSource.itemIdentifier(for: indexPath) else { return }
        let destination = BookDetailViewController(bookKey: book.key)
        show(destination, sender: self)
    }
}
