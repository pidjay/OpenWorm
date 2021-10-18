//
//  SecondaryTitleLabel.swift
//  OpenWorm
//
//  Created by Pierre-Jean Quilleré on 2021-10-18.
//

import UIKit

class SecondaryTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment) {
        self.init(frame: .zero)
        
        self.textAlignment = textAlignment
    }
    
    private func configure() {
        font = .preferredFont(forTextStyle: .title3)
        textColor = .label
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
        adjustsFontForContentSizeCategory = true
    }
}
