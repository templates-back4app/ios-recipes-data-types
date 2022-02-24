//
//  RecipeOverviewView.swift
//  DSSRecipes
//
//  Created by David on 20/02/22.
//

import UIKit

class RecipeOverviewView: UIView {
    // MARK: - Properties
    
    class var identifier: String { "\(NSStringFromClass(Self.self)).identifier" }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: super.intrinsicContentSize.width, height: 58 * 6 - 8)
    }
    
    var recipe: Recipe? {
        didSet {
            guard let recipe = recipe else { return }
            refreshContent(with: recipe)
        }
    }
    
    private let nameTextField = TextField(placeholder: "Name ")
    private let categoryTextField = TextField(placeholder: "Category ")
    private let priceTextField = TextField(placeholder: "Price ($) ")
    private let servingsTextField = TextField(placeholder: "Servings ")
    private let sideOptionsTextField: TextField = TextField(placeholder: "Side options (followed by commas)")
    private let availableSwitch: SwitchControl = SwitchControl(description: "Available")
    private let releaseDatePicker: DatePicker = DatePicker(description: "Release date")
    private let ingredientsTextField: TextField = TextField(placeholder: "Ingredients ")
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Handlers
    
    private func refreshContent(with recipe: Recipe) {
        nameTextField.text = recipe.name
        categoryTextField.text = recipe.category?.title
        
        availableSwitch.isOn = recipe.isAvailable ?? false
        
        if let price = recipe.price { priceTextField.text = "\(price)" }
        if let releaseDate = recipe.releaseDate { releaseDatePicker.date = releaseDate }
        
        servingsTextField.text = "\(recipe.servings ?? 0)"
        
        let infoArray = recipe.nutritionalInfo.map { item in "\(item.key) (\(item.value))" }
        infoLabel.text = infoArray.joined(separator: ", ")
        
        sideOptionsTextField.text = recipe.sideOptions.joined(separator: ", ")
        
        let ingredientsDescriptions: [String] = recipe.ingredients.map { "\($0.quantity) \($0.description)" }
        ingredientsTextField.text = ingredientsDescriptions.joined(separator: ", ")
    }
    
    private func setupViews() {
        let priceQuantityStack = UIStackView(arrangedSubviews: [priceTextField, servingsTextField])
        priceQuantityStack.spacing = 8
        priceQuantityStack.distribution = .fillEqually
        
        let stackView = UIStackView(arrangedSubviews: [
            nameTextField,
            categoryTextField,
            priceQuantityStack,
            sideOptionsTextField,
            availableSwitch,
            releaseDatePicker
        ])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
                
        let categoryPicker = UIPickerView()
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        categoryTextField.customInputView = categoryPicker
        
        setupHideKeyboardTap()
    }
    
    /// Reads all the changes the user did and creates a new instance of the current *recipe* with the new values
    func parseInputToRecipe() -> (
        objectId: String?,
        name: String?,
        servings: Int?,
        price: Double?,
        isAvailable: Bool,
        category: Recipe.Category?,
        sideOptions: [String],
        releaseDate: Date
    ) {
        let categoryId: Int = (categoryTextField.customInputView as? UIPickerView)?.selectedRow(inComponent: 0) ?? -1
        
        let sideOptions: [String]? = sideOptionsTextField.text?.split(separator: ",").map {
            return String($0.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        
        return (
            objectId: recipe?.objectId,
            name: nameTextField.text,
            servings: Int(servingsTextField.text ?? "0"),
            price: Double(priceTextField.text ?? "0"),
            isAvailable: availableSwitch.isOn,
            category: Recipe.Category(rawValue: categoryId),
            sideOptions: sideOptions ?? [],
            releaseDate: releaseDatePicker.date
        )
    }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension RecipeOverviewView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        Recipe.Category.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        Recipe.Category.allCases[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = Recipe.Category.allCases[row].title
    }
}
