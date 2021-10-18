//
//  SearchDataSource.swift
//  OpenWorm
//
//  Created by Pierre-Jean Quilleré on 2021-10-18.
//

import UIKit

class SearchDataSource: UICollectionViewDiffableDataSource<SearchDataSource.Section, Book> {
    
    enum Section: String, CaseIterable {
        case a2f
        case g2o
        case p2z
        case noAuthor
        
        var title: String {
            switch self {
            case .a2f:      return "A – F"
            case .g2o:      return "G – O"
            case .p2z:      return "P – Z"
            case .noAuthor: return "Unknown Author"
            }
        }
    }
    
    var isEmpty: Bool { books.isEmpty }
    
    private var books: [Book] = []
    private var booksBySection: [Section: [Book]] = [:]
    private var visibleSections: [Section] = []
    
    init(collectionView: UICollectionView) {
        let cellProvider: UICollectionViewDiffableDataSource<Section, Book>.CellProvider = { collectionView, indexPath, book in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCoverCell.reuseIdentifier, for: indexPath) as! BookCoverCell
            cell.update(with: .init(title: book.title, isbn: book.ISBNs?.first, authors: book.authorNames))
            return cell
        }
        
        super.init(collectionView: collectionView, cellProvider: cellProvider)
        
        supplementaryViewProvider = { [unowned self] collectionView, kind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BookSearchHeaderView.reuseIdentifier, for: indexPath) as! BookSearchHeaderView
            header.update(with: .init(title: self.visibleSections[indexPath.section].title))
            return header
        }
    }
    
    func update(with books: [Book]) {
        self.books = books
        computeSections()
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Book>()
        
        for section in Section.allCases {
            guard let books = booksBySection[section] else { continue }
            snapshot.appendSections([section])
            snapshot.appendItems(books, toSection: section)
        }
        
        apply(snapshot, animatingDifferences: true)
    }
    
    func resetData() {
        update(with: [])
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
}
