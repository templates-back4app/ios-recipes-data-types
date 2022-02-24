//
//  UIViewControllerExtension.swift
//  DSSRecipes
//
//  Created by David on 20/02/22.
//

import UIKit.UIViewController

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let backAction = UIAlertAction(title: "Back", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
                
        alertController.addAction(backAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension UIView {
    func setupHideKeyboardTap() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEndEditing)))
    }
    
    @objc private func handleEndEditing() {
        endEditing(true)
    }
}
