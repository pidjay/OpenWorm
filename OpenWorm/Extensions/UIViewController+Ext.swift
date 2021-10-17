//
//  UIViewController+Ext.swift
//  OpenWorm
//
//  Created by Pierre-Jean Quilleré on 2021-10-17.
//

import UIKit

extension UIViewController {
    
    func present(error: UserFriendlyError) {
        let alert = UIAlertController(title: "Error", message: error.userFriendlyDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }
}
