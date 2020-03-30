//
//  ParamerterTableViewCell.swift
//  Core Graphics 1
//
//  Created by Jackson Tubbs on 2/28/20.
//  Copyright © 2020 Jackson Tubbs. All rights reserved.
//

import UIKit

class ParameterTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    var parameter: Parameter! {
        didSet {
            updateViewsForParameter()
        }
    }
    
    // MARK: Views
    
    weak var paddingView:     UIView!
    weak var labelParentView: UIView!
    weak var label:           UILabel!
    weak var valueParentView: UIView!
    weak var valueLabel: UILabel!
    
    // MARK: Style GUide
    
    // Label
    let labelFontName: String  = StyleGuide.regularPixelFontName
    let labelFontSize: CGFloat = StyleGuide.smallHeadingFontSize
    var labelFont:     UIFont?
    
    // MARK: Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Overrides
    
    // Set Selected
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            valueParentView.isHidden = false
            valueLabel.text = "Bacon"
            if let value = parameter.slider1Value, let isFloat = parameter.slider1IsFloat {
                if isFloat {
                    valueLabel.text = "\(floor(value * 100) / 100)"
                } else {
                    valueLabel.text = "\(Int(floor(value)))"
                }
            }
            labelParentView.backgroundColor = .black
            label.backgroundColor = .black
            label.textColor = .white
        } else {
             valueParentView.isHidden = true
            labelParentView.backgroundColor = .accentColor
            label.backgroundColor = .accentColor
            label.textColor = .black
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        // Overriden and super not called because we don't want it to be called
    }
    
    // MARK: Helpers
    
    private func updateViewsForParameter() {
        layoutIfNeeded()
        label.text = parameter.labelText
    }
    
    // MARK: Set Style Guide Variables
    
    private func setStyleGuideVariables() {
        // Label
        labelFont = UIFont(name: labelFontName, size: labelFontSize)
    }
    
    // MARK: Setup Views
    
    private func setupViews() {
        setStyleGuideVariables()
        
        contentView.backgroundColor = .backgroundColor
        
        // Padding View
        let paddingView = UIView()
        paddingView.backgroundColor = .backgroundColor
        paddingView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(paddingView)
        NSLayoutConstraint.activate([
            paddingView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            paddingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            paddingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            paddingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            paddingView.heightAnchor.constraint(equalToConstant: 44)
        ])
        self.paddingView = paddingView
        
        // Label Parent View
        let labelParentView = UIView()
        labelParentView.backgroundColor = .accentColor
        labelParentView.layer.borderColor = UIColor.black.cgColor
        labelParentView.layer.borderWidth = 2
        labelParentView.layer.cornerRadius = 2
        labelParentView.translatesAutoresizingMaskIntoConstraints = false
        paddingView.addSubview(labelParentView)
        NSLayoutConstraint.activate([
            labelParentView.centerYAnchor.constraint(equalTo: paddingView.centerYAnchor),
            labelParentView.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor, constant: 4)
        ])
        self.labelParentView = labelParentView
        
        // Label View
        let label = UILabel()
        label.textColor = .black
        label.font = labelFont
        label.translatesAutoresizingMaskIntoConstraints = false
        labelParentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: labelParentView.topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: labelParentView.leadingAnchor, constant: 4),
            label.trailingAnchor.constraint(equalTo: labelParentView.trailingAnchor, constant: -4),
            label.bottomAnchor.constraint(equalTo: labelParentView.bottomAnchor, constant: -8)
        ])
        self.label = label
        
        // Value Parent View
        let valueParentView = UIView()
        valueParentView.isHidden = true
        valueParentView.backgroundColor = .black
        valueParentView.layer.borderWidth = 2
        valueParentView.layer.borderColor = UIColor.black.cgColor
        valueParentView.layer.cornerRadius = 2
        valueParentView.translatesAutoresizingMaskIntoConstraints = false
        paddingView.addSubview(valueParentView)
        NSLayoutConstraint.activate([
            valueParentView.leadingAnchor.constraint(equalTo: labelParentView.trailingAnchor, constant: 4),
            valueParentView.centerYAnchor.constraint(equalTo: paddingView.centerYAnchor)
        ])
        self.valueParentView = valueParentView
        
        // Value Label
        let valueLabel = UILabel()
        valueLabel.font = labelFont
        valueLabel.textColor = .white
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueParentView.addSubview(valueLabel)
        NSLayoutConstraint.activate([
            valueLabel.leadingAnchor.constraint(equalTo: valueParentView.leadingAnchor, constant: 4),
            valueLabel.trailingAnchor.constraint(equalTo: valueParentView.trailingAnchor, constant: -4),
            valueLabel.topAnchor.constraint(equalTo: valueParentView.topAnchor, constant: 8),
            valueLabel.bottomAnchor.constraint(equalTo: valueParentView.bottomAnchor, constant: -8)
        ])
        self.valueLabel = valueLabel
    }
}
