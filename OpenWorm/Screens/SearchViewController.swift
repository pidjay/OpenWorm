//
//  SearchViewController.swift
//  OpenWorm
//
//  Created by Pierre-Jean Quilleré on 2021-10-17.
//

import UIKit

class SearchViewController: UIViewController {
    
    enum Section: CaseIterable {
        case a2f
        case g2o
        case p2z
        case noAuthor
        
        var title: String {
            switch self {
            case .a2f:
                return "A – F"
            case .g2o:
                return "G – O"
            case .p2z:
                return "P – Z"
            case .noAuthor:
                return "Unknown Author"
            }
        }
    }
    
    private let emptyStateView = EmptyStateView()
    
    private lazy var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
    private lazy var dataSource = createDataSource()
    
    private var books: [Book] = []
    private var booksBySection: [Section: [Book]] = [:]
    private var visibleSections: [Section] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        #warning("TODO: loading state")
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
                self.books = response.docs
                DispatchQueue.main.async {
                    self.updateData()
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.present(error: error)
                }
            }
        }
    }
    
    private func updateData() {
        computeSections()
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Book>()
        
        for section in Section.allCases {
            guard let books = booksBySection[section] else { continue }
            snapshot.appendSections([section])
            snapshot.appendItems(books, toSection: section)
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
        
        let hasResults = !books.isEmpty
        if !hasResults {
            emptyStateView.update(with: .init(title: "No Results", message: "There are no results for your search."))
        }
        emptyStateView.isHidden = hasResults
    }
    
    private func resetToWelcomeState() {
        // remove results from screen
        books = []
        updateData()
        
        // animate back to the welcome screen
        let animations = {
            let vm = self.welcomeStateViewModel()
            self.emptyStateView.update(with: vm)
            self.emptyStateView.isHidden = false
        }
        UIView.transition(with: view, duration: 0.25, options: [.transitionCrossDissolve], animations: animations)
    }
    
    private func computeSections() {
        booksBySection = [:]
        visibleSections = []
        
        for book in books {
            var book = book
            guard let authorNames = book.authorNames else {
                var books = booksBySection[.noAuthor] ?? []
                books.append(book)
                booksBySection[.noAuthor] = books
                continue
            }
            
            // add the book to each authors' section
            for author in authorNames {
                #warning("TODO: improve parsing safety")
                let lastname = author.split(separator: " ").last!
                let firstLetter = lastname.first!.lowercased()
                
                let section: Section
                if firstLetter < "g" {
                    section = .a2f
                }
                else if firstLetter < "p" {
                    section = .g2o
                }
                else {
                    section = .p2z
                }
                
                // trick to have the same book multiple times in different sections
                book.copy += 1
                
                var books = booksBySection[section] ?? []
                books.append(book)
                booksBySection[section] = books
            }
        }
        
        for section in Section.allCases {
            guard booksBySection[section] != nil else { continue }
            visibleSections.append(section)
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
    
    private func createDataSource() -> UICollectionViewDiffableDataSource<Section, Book> {
        let dataSource = UICollectionViewDiffableDataSource<Section, Book>(collectionView: collectionView, cellProvider: { collectionView, indexPath, book in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCoverCell.reuseIdentifier, for: indexPath) as! BookCoverCell
            cell.update(with: .init(title: book.title))
            return cell
        })
        dataSource.supplementaryViewProvider = { [unowned self] collectionView, kind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BookSearchHeaderView.reuseIdentifier, for: indexPath) as! BookSearchHeaderView
            header.update(with: .init(title: self.visibleSections[indexPath.section].title))
            return header
        }
        return dataSource
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = .systemBackground
        
        collectionView.dataSource = dataSource
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
