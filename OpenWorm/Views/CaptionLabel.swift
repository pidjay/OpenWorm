//
//  CaptionLabel.swift
//  OpenWorm
//
//  Created by Pierre-Jean Quilleré on 2021-10-17.
//

import UIKit

class CaptionLabel: UILabel {
    
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
        font = .preferredFont(forTextStyle: .caption1)
        textColor = .label
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.75
        lineBreakMode = .byTruncatingTail
        numberOfLines = 0
        adjustsFontForContentSizeCategory = true
    }
    
}
