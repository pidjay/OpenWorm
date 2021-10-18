//
//  BookDetailHeaderView.swift
//  OpenWorm
//
//  Created by Pierre-Jean Quilleré on 2021-10-18.
//

import UIKit

class BookDetailHeaderView: UIView {
    
    struct ViewModel {
        let detail: BookDetail
        
        var coverURL: URL? {
            #warning("TODO: match covers on search and detail screens...")
            
            // One issue I found is that the ISBN I used for the search screen may not be available from the book API
            // for some reasons.
            // A possible workaround would be to pass the ISBN from the search screen.
            
            guard let coverId = detail.covers?.first else { return nil }
            return CoverEndpoint.id(coverId, .medium).url
        }
        
        var bookTitle: String {
            detail.title
        }
        
        var editionName: String? {
            detail.editionName
        }
        
        var authors: String? {
            #warning("TODO: need to be implemented after `BookDetail` got the authors figured out")
            return nil
        }
    }
    
    private let coverImageView = BookCoverImageView()
    private let titleLabel = LargeTitleLabel(textAlignment: .center)
    private let editionNameLabel = SecondaryTitleLabel(textAlignment: .center)
    private let authorsLabel = BodyLabel(textAlignment: .center)
    
    private var coverImageRatioConstraint: NSLayoutConstraint!
    
    init() {
        super.init(frame: .zero)
        
        configureContainer()
        configureCoverImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with vm: ViewModel) {
        coverImageView.setImage(with: vm.coverURL)
        titleLabel.text = vm.bookTitle
        editionNameLabel.text = vm.editionName
        authorsLabel.text = vm.authors
        
        editionNameLabel.isHidden = vm.editionName == nil
        authorsLabel.isHidden = vm.authors == nil
    }
    
    override func layoutSubviews() {
        if let cover = coverImageView.image {
            coverImageRatioConstraint = coverImageRatioConstraint.withMultiplier(cover.size.width / cover.size.height)
        }
        
        super.layoutSubviews()
    }
    
    private func configureContainer() {
        let container = UIStackView(arrangedSubviews: [coverImageView, titleLabel, editionNameLabel, authorsLabel])
        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .vertical
        container.distribution = .fill
        container.alignment = .center
        container.spacing = 8
        addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        container.setCustomSpacing(24, after: coverImageView)
    }
    
    private func configureCoverImageView() {
        coverImageView.contentMode = .scaleAspectFill
        
        var multiplier: CGFloat = 1
        if let cover = coverImageView.image {
            multiplier = cover.size.width / cover.size.height
        }
        coverImageRatioConstraint = coverImageView.widthAnchor.constraint(equalTo: coverImageView.heightAnchor, multiplier: multiplier)
        
        NSLayoutConstraint.activate([
            coverImageRatioConstraint,
            coverImageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200)
        ])
    }
}
