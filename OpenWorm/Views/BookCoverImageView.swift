//
//  BookCoverImageView.swift
//  OpenWorm
//
//  Created by Pierre-Jean Quilleré on 2021-10-17.
//

import UIKit

class BookCoverImageView: UIImageView {
    
    private let coverPlaceholder = UIImage(named: "book-cover-placeholder")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 12
        layer.cornerCurve = .continuous
        layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        layer.borderWidth = 1
        
        image = coverPlaceholder
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
}
