//
//  SearchViewController.swift
//  OpenWorm
//
//  Created by Pierre-Jean Quilleré on 2021-10-17.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let emptyStateView = EmptyStateView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        #warning("TODO: query OpenLibrary")
        #warning("TODO: loading state")
        #warning("TODO: display content in collection view (see assignment for details)")
        #warning("TODO: empty state when no content")
        #warning("TODO: search on button tap to avoid spamming the API -> search bar delegate")
        
        configureEmptyStateView()
        configureSearchController()
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
        searchController.searchBar.placeholder = "Search for books..."
        navigationItem.searchController = searchController
    }

}
