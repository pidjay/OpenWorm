//
//  LoadingStateView.swift
//  OpenWorm
//
//  Created by Pierre-Jean Quilleré on 2021-10-18.
//

import UIKit

class LoadingStateView: UIView {
    
    struct ViewModel {
        let title: String
        let message: String
    }

    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
    
    private func configure() {
        addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
}
