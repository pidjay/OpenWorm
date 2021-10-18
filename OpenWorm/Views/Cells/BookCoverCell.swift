//
//  BookCoverCell.swift
//  OpenWorm
//
//  Created by Pierre-Jean Quilleré on 2021-10-17.
//

import UIKit

class BookCoverCell: UICollectionViewCell {
    
    struct ViewModel {
        let title: String
        let isbn: String?
        let authors: [String]?
        
        var coverURL: URL? {
            guard let isbn = isbn else { return nil }
            return CoverEndpoint.isbn(isbn, .medium).url
        }
        
        var formattedAuthors: String {
            guard let authors = authors else { return "Unknown" }
            return authors.joined(separator: ",\n")
        }
    }
    
    static let reuseIdentifier = "com.openworm.BookCoverCell"
    
    let coverImageView = BookCoverImageView(frame: .zero)
    let titleLabel = BodyLabel(textAlignment: .left)
    let authorsLabel = CaptionLabel(textAlignment: .left)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with vm: ViewModel) {
        coverImageView.setImage(with: vm.coverURL)
        titleLabel.text = vm.title
        authorsLabel.text = vm.formattedAuthors
    }
    
    private func configure() {
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorsLabel)
        
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        authorsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.numberOfLines = 2
        titleLabel.setContentCompressionResistancePriority(.defaultHigh + 1, for: .vertical)
        
        authorsLabel.numberOfLines = 2
        authorsLabel.setContentCompressionResistancePriority(.defaultHigh - 1, for: .vertical)
        
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.75),
            
            titleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            authorsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            authorsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorsLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            authorsLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -8),
        ])
    }
    
}
