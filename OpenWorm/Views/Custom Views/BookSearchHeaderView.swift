//
//  BookSearchHeaderView.swift
//  OpenWorm
//
//  Created by Pierre-Jean Quilleré on 2021-10-17.
//

import UIKit

class BookSearchHeaderView: UICollectionReusableView {
    
    struct ViewModel {
        let title: String
    }
    
    static let reuseIdentifier = "com.openworm.BookSearchHeaderView"
    
    let label = TitleLabel(textAlignment: .left)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground.withAlphaComponent(0.7)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with vm: ViewModel) {
        label.text = vm.title
    }
    
    private func configure() {
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
    }
}
