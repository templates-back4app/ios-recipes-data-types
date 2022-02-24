//
//  ViewController.swift
//  DSSUserProfile
//
//  Created by David on 19/02/22.
//

import UIKit

extension UIColor {
    static let primary: UIColor = UIColor(red: 11 / 255, green: 140 / 255, blue: 229 / 255, alpha: 1)
}

class RecipesController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupNavigationBar()
        
        fetchRecipes()
        let omelette: Recipe = .omelette
        _ = try? omelette.save()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .primary
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Parse data types".uppercased()
    }

    private func fetchRecipes() {
        let query = Recipe.query()
        
        query.find { result in
            switch result {
            case .success(let recipes):
                break
            case .failure(let error):
                break
            }
        }
    }
}

