//
//  RecipesController.swift
//  DSSRecipes
//
//  Created by David on 22/02/22.
//

import UIKit

extension UILabel {
    class func titleLabel(title: String) -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .primary
        label.textAlignment = .left
        return label
    }
}

extension UIColor {
    static let primary: UIColor = UIColor(red: 11 / 255, green: 140 / 255, blue: 229 / 255, alpha: 1)
}

extension UIButton {
    convenience init(title: String) {
        self.init(type: .system)
        setTitle(title, for: .normal)
        backgroundColor = .primary
        tintColor = .white
        layer.cornerRadius = 8
    }
}

class RecipesController: UIViewController {
    enum PreviousNext: Int { case previous = 0, next = 1 }
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    var recipes: [Recipe] = []
    
    private let recipeLabel: UILabel = .titleLabel(title: "Recipe overview")
    private let ingredientsLabel: UILabel = .titleLabel(title: "Ingredients")
    private let nutritionalInfoLabel: UILabel = .titleLabel(title: "Nutritional information")
    
    let recipeOverviewView: RecipeOverviewView = {
        let recipeOverviewView = RecipeOverviewView()
        recipeOverviewView.translatesAutoresizingMaskIntoConstraints = false
        return recipeOverviewView
    }()
    
    let ingredientsStackView: UIStackView = {
        let textFields: [DoubleTextField] = (0...2).map { _ in
            DoubleTextField(primaryPlaceholder: "Quantity", secondaryPlaceholder: "Description")
        }
        let stackView = UIStackView(arrangedSubviews: textFields)
        stackView.spacing = 4
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let nutritionalInfoStackView: UIStackView = {
        let textFields: [DoubleTextField] = (0...2).map { _ in
            DoubleTextField(primaryPlaceholder: "Content", secondaryPlaceholder: "Value")
        }
        let stackView = UIStackView(arrangedSubviews: textFields)
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var saveButton: UIButton = UIButton(title: "Save")
    private var updateButton: UIButton = UIButton(title: "Update")
    private var reloadButton: UIButton = UIButton(title: "Reload")
    
    var currentRecipeIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleReloadRecipes()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .primary
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Parse data types".uppercased()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        
        let buttonsStackView = UIStackView(arrangedSubviews: [saveButton, updateButton, reloadButton])
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.spacing = 8
        
        let padding: CGFloat = 12
        let buttonsStackViewHeight: CGFloat = 44
        let labelHeight = recipeLabel.font.lineHeight + 4
        let overviewHeight = recipeOverviewView.intrinsicContentSize.height
        let ingredientsHeight = 58 * ingredientsStackView.arrangedSubviews.count - 8
        let nutritionalInfoHeight = 58 * nutritionalInfoStackView.arrangedSubviews.count - 8
        
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        scrollView.addSubview(buttonsStackView)
        scrollView.addSubview(recipeLabel)
        scrollView.addSubview(recipeOverviewView)
        scrollView.addSubview(ingredientsLabel)
        scrollView.addSubview(ingredientsStackView)
        scrollView.addSubview(nutritionalInfoLabel)
        scrollView.addSubview(nutritionalInfoStackView)
        
        buttonsStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: padding / 2).isActive = true
        buttonsStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        buttonsStackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -20).isActive = true
        buttonsStackView.heightAnchor.constraint(equalToConstant: buttonsStackViewHeight).isActive = true
        
        recipeLabel.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: padding).isActive = true
        recipeLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        recipeLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -20).isActive = true
        recipeLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        recipeOverviewView.topAnchor.constraint(equalTo: recipeLabel.bottomAnchor).isActive = true
        recipeOverviewView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        recipeOverviewView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -20).isActive = true
        recipeOverviewView.heightAnchor.constraint(equalToConstant: overviewHeight).isActive = true
        
        ingredientsLabel.topAnchor.constraint(equalTo: recipeOverviewView.bottomAnchor, constant: padding).isActive = true
        ingredientsLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        ingredientsLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -20).isActive = true
        ingredientsLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        ingredientsStackView.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor).isActive = true
        ingredientsStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        ingredientsStackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -20).isActive = true
        ingredientsStackView.heightAnchor.constraint(equalToConstant: CGFloat(ingredientsHeight)).isActive = true
                
        nutritionalInfoLabel.topAnchor.constraint(equalTo: ingredientsStackView.bottomAnchor, constant: padding).isActive = true
        nutritionalInfoLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        nutritionalInfoLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -20).isActive = true
        nutritionalInfoLabel.heightAnchor.constraint(equalToConstant: labelHeight).isActive = true
        
        nutritionalInfoStackView.topAnchor.constraint(equalTo: nutritionalInfoLabel.bottomAnchor).isActive = true
        nutritionalInfoStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        nutritionalInfoStackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -20).isActive = true
        nutritionalInfoStackView.heightAnchor.constraint(equalToConstant: CGFloat(ingredientsHeight)).isActive = true
        
        let contentHeight = padding / 2 + buttonsStackViewHeight + 3 * (padding + labelHeight) + overviewHeight + CGFloat(ingredientsHeight + nutritionalInfoHeight)
        
        scrollView.contentSize.height = contentHeight
        scrollView.contentInset = .init(top: 8, left: 0, bottom: 8, right: 0)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        view.setupHideKeyboardTap()
        
        saveButton.addTarget(self, action: #selector(handleSaveRecipe), for: .touchUpInside)
        updateButton.addTarget(self, action: #selector(handleUpdateRecipe), for: .touchUpInside)
        reloadButton.addTarget(self, action: #selector(handleReloadRecipes), for: .touchUpInside)
    }
    
    @objc private func handleKeyboardWillShow(notification: Notification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        scrollView.contentInset.bottom = 8 + keyboardHeight
    }
    
    @objc private func handleKeyboardWillHide(notification: Notification) {
        scrollView.contentInset.bottom = 8
    }
}
