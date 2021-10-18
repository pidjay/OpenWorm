//
//  BookDetailViewController.swift
//  OpenWorm
//
//  Created by Pierre-Jean Quilleré on 2021-10-17.
//

import UIKit

class BookDetailViewController: UIViewController {
    
    let bookKey: String
    
    private let headerView = BookDetailHeaderView()
    
    init(bookKey: String) {
        self.bookKey = bookKey
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureContainer()
        
        fetchData()
    }
    
    private func fetchData() {
        OpenLibraryClient().fetch(BookEndpoint.book(bookKey), into: BookDetail.self) { result in
            switch result {
            case .success(let book):
                DispatchQueue.main.async {
                    self.headerView.update(with: .init(detail: book))
                }
                
            case .failure(let error):
                self.present(error: error)
            }
        }
    }
    
    private func configureContainer() {
        let container = UIStackView(arrangedSubviews: [headerView])
        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .vertical
        container.distribution = .fill
        container.alignment = .fill
        container.spacing = 12
        view.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
        ])
    }
    
}
