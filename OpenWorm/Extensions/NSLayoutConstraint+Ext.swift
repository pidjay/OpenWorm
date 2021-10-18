//
//  NSLayoutConstraint+Ext.swift
//  OpenWorm
//
//  Created by Pierre-Jean Quilleré on 2021-10-18.
//

import UIKit

extension NSLayoutConstraint {
    
    func withMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem as Any,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        
        return newConstraint
    }
    
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
