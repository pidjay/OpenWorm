//
//  EmptyStateView.swift
//  OpenWorm
//
//  Created by Pierre-Jean Quilleré on 2021-10-17.
//

import UIKit

class EmptyStateView: UIView {
    
    struct ViewModel {
        let title: String
        let message: String
    }

    private let imageView = UIImageView()
    private let titleLabel = TitleLabel(textAlignment: .center)
    private let messageLabel = BodyLabel(textAlignment: .center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureContainer()
        configureImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with vm: ViewModel) {
        titleLabel.text = vm.title
        messageLabel.text = vm.message
    }
    
    private func configureContainer() {
        let container = UIStackView(arrangedSubviews: [imageView, titleLabel, messageLabel])
        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .vertical
        container.distribution = .fill
        container.alignment = .fill
        container.spacing = 12
        addSubview(container)
        
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -40),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
        ])
        
        container.setCustomSpacing(40, after: imageView)
    }
    
    private func configureImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "openworm-logo")
    }

}
