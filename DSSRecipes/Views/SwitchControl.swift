//
//  SwitchControl.swift
//  DSSRecipes
//
//  Created by David on 20/02/22.
//

import UIKit

class SwitchControl: UIControl {
    // MARK: - Properties
    
    var switchDescription: String? {
        get { descriptionLabel.text }
        set { descriptionLabel.text = newValue }
    }
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var switchControl: UISwitch = {
        let control = UISwitch()
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    var isOn: Bool {
        get { switchControl.isOn }
        set { switchControl.isOn = newValue }
    }
    
    // MARK: - Init
    
    convenience init(description: String) {
        self.init(frame: .zero)
        defer { self.switchDescription = description }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Handlers
    
    private func setupViews() {
        addSubview(descriptionLabel)
        addSubview(switchControl)
                
        descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: switchControl.leadingAnchor).isActive = true
        
        switchControl.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        switchControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
