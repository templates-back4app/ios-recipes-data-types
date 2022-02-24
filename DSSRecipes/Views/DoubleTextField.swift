//
//  DoubleTextField.swift
//  DSSRecipes
//
//  Created by David on 22/02/22.
//

import UIKit

class DoubleTextField: UIStackView {
    // MARK: - Properties
        
    private var primaryTextField = TextField()
    private var secondaryTextField = TextField()
    
    var primaryText: String? {
        get { primaryTextField.text }
        set { primaryTextField.text = newValue }
    }
    
    var primaryPlaceholder: String? {
        get { primaryTextField.placeholder }
        set { primaryTextField.placeholder = newValue }
    }
    
    var primaryKeyboardType: UIKeyboardType {
        get { primaryTextField.keyboardType }
        set { primaryTextField.keyboardType = newValue }
    }
    
    var secondaryText: String? {
        get { secondaryTextField.text }
        set { secondaryTextField.text = newValue }
    }
    
    var secondaryPlaceholder: String? {
        get { secondaryTextField.placeholder }
        set { secondaryTextField.placeholder = newValue }
    }
    
    var secondaryKeyboardType: UIKeyboardType {
        get { secondaryTextField.keyboardType }
        set { secondaryTextField.keyboardType = newValue }
    }
        
    private weak var stackView: UIStackView? = nil
    
    // MARK: - Init
    
    convenience init(primaryPlaceholder: String, secondaryPlaceholder: String) {
        self.init()
        defer {
            self.primaryPlaceholder = primaryPlaceholder
            self.secondaryPlaceholder = secondaryPlaceholder
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Handlers
    
    private func setupViews() {
        addArrangedSubview(primaryTextField)
        addArrangedSubview(secondaryTextField)
        
        distribution = .fillEqually
        spacing = 4
    }
}
