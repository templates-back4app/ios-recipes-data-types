//
//  Switch.swift
//  DSSUserProfile
//
//  Created by David on 20/02/22.
//

import UIKit

class SwitchControl: UIControl {
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = true
        return label
    }()
    
    private var switchControl: UISwitch = {
        let control = UISwitch()
        control.translatesAutoresizingMaskIntoConstraints = true
        return control
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(descriptionLabel)
        addSubview(switchControl)
    }
}
