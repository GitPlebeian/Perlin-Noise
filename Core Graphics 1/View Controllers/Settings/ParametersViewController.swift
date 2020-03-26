//
//  ParametersViewController.swift
//  Core Graphics 1
//
//  Created by Jackson Tubbs on 2/22/20.
//  Copyright © 2020 Jackson Tubbs. All rights reserved.
//

import UIKit

class ParametersViewController: UIViewController {

    // MARK: Properties
    var selectionFeedback: UISelectionFeedbackGenerator = UISelectionFeedbackGenerator()
    var editingParameter: Parameter?
    
    // MARK: Views
    
    weak var navigationControllerSeparatorView: UIView!
    
    weak var editorSeparatorView:               UIView!
    weak var editorView:                        UIView!
    weak var editorTitleLabel:                  UIView!
    
    weak var editorSliderOnlyView:              UIView!
    weak var editorSliderOnlyLabel:             UILabel!
    weak var editorSliderOnlyValueView:         UIView!
    weak var editorSliderOnlyValueLabel:        UILabel!
    weak var editorSliderOnlySliderView:        UIView!
    weak var editorSliderOnlySlider:            UISlider!
    
    weak var parametersTableView:               UITableView!
    
    // MARK: Style Guide
    
    // Editor View
    let editorViewHeight:      CGFloat = 250
    let editorWidthMultiplier: CGFloat = 0.9
    
    // Editor Only Slider
    let editorSliderOnlyLabelFontName: String  = StyleGuide.boldPixelFontName
    let editorSliderOnlyLabelFontSize: CGFloat = StyleGuide.mediumHeadingFontSize
    var editorSliderOnlyLabelFont:     UIFont?
    
    // MARK: Object Lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: View Lifecycle
    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if TutorialController.shared.didDoTutorial(tutorial: .parameters) {
            
        }
    }
    
    // MARK: Other Overrides
    
    // Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // MARK: Actions
    
    @objc private func editorSliderOnlySliderValueChanged() {
        guard let parameter = editingParameter else {return}
        parameter.slider1Value = editorSliderOnlySlider.value
        if parameter.slider1IsFloat == true {
            editorSliderOnlyValueLabel.text = "\(floorf(editorSliderOnlySlider.value * 100) / 100)"
        } else {
            editorSliderOnlyValueLabel.text = "\(Int(editorSliderOnlySlider.value))"
        }
        ParameterController.shared.saveParameters()
    }
    
    // MARK: Set Style Guide Variables
    
    private func setStyleGuideVariables() {
        // Editor Only Slider
        editorSliderOnlyLabelFont = UIFont(name: editorSliderOnlyLabelFontName, size: editorSliderOnlyLabelFontSize)
    }
    
    // MARK: Helpers
    
    // Hide Other Editor Views
    private func hideEditorViews() {
        editorSliderOnlyView.isHidden = true
    }
    
    // Update Editor With Parameter
    private func updateEditor() {
        guard let parameter = editingParameter else {return}
        if parameter.oneSlider == true {
            hideEditorViews()
            guard let min = parameter.slider1Min,
                let max = parameter.slider1Max,
                let value = parameter.slider1Value else {return}
            editorSliderOnlySlider.minimumValue = min
            editorSliderOnlySlider.maximumValue = max
            editorSliderOnlySlider.value = value
            editorSliderOnlyLabel.text = parameter.labelText
            if parameter.slider1IsFloat == true {
                editorSliderOnlyValueLabel.text = "\(floorf(editorSliderOnlySlider.value * 100) / 100)"
            } else {
                editorSliderOnlyValueLabel.text = "\(Int(editorSliderOnlySlider.value))"
            }
            editorSliderOnlyView.isHidden = false
            editingParameter = parameter
            editorSliderOnlyLabel.text = parameter.labelText
            editorSliderOnlyView.isHidden = false
        }
    }
    
    // MARK: Setup Views
    
    private func setupViews() {
        setStyleGuideVariables()
        self.navigationItem.title = "Parameters"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: StyleGuide.boldPixelFontName, size: 18.0)!,
                                                                         NSAttributedString.Key.foregroundColor: UIColor.black]
        self.view.backgroundColor = .backgroundColor
        
        let backImage = UIImage(named: "Back Arrow")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Naviagtion Controller Separator View
        let navigationControllerSeparatorView = UIView()
        navigationControllerSeparatorView.backgroundColor = .black
        navigationControllerSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(navigationControllerSeparatorView)
        NSLayoutConstraint.activate([
            navigationControllerSeparatorView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            navigationControllerSeparatorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            navigationControllerSeparatorView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            navigationControllerSeparatorView.heightAnchor.constraint(equalToConstant: 2)
        ])
        self.navigationControllerSeparatorView = navigationControllerSeparatorView
        
        // Editor View
        let editorView = UIView()
        editorView.backgroundColor = .backgroundColor
        editorView.layer.borderColor = UIColor.black.cgColor
        editorView.layer.borderWidth = 2
        editorView.layer.cornerRadius = 2
        editorView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(editorView)
        NSLayoutConstraint.activate([
            editorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
            editorView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),
            editorView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            editorView.heightAnchor.constraint(equalToConstant: editorViewHeight)
        ])
        self.editorView = editorView
        
        // Editor Title Label
        let editorTitleLabel = UILabel()
        editorTitleLabel.font = UIFont(name: StyleGuide.boldPixelFontName, size: StyleGuide.mediumHeadingFontSize)
        editorTitleLabel.text = "Editor"
        editorTitleLabel.textColor = .black
        editorTitleLabel.textAlignment = .left
        editorTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(editorTitleLabel)
        NSLayoutConstraint.activate([
            editorTitleLabel.leadingAnchor.constraint(equalTo: editorView.leadingAnchor, constant: 8),
            editorTitleLabel.bottomAnchor.constraint(equalTo: editorView.topAnchor, constant: -8)
        ])
        self.editorTitleLabel = editorTitleLabel
        
        // Editor Separator View
        let editorSeparatorView = UIView()
        editorSeparatorView.backgroundColor = .black
        editorSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(editorSeparatorView)
        NSLayoutConstraint.activate([
            editorSeparatorView.bottomAnchor.constraint(equalTo: editorTitleLabel.topAnchor, constant: -8),
            editorSeparatorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            editorSeparatorView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            editorSeparatorView.heightAnchor.constraint(equalToConstant: 2)
        ])
        self.editorSeparatorView = editorSeparatorView
        
        // Editor Only Slider View
        let editorSliderOnlyView = UIView()
        editorSliderOnlyView.backgroundColor = .backgroundColor
        editorSliderOnlyView.isHidden = true
        editorSliderOnlyView.translatesAutoresizingMaskIntoConstraints = false
        editorView.addSubview(editorSliderOnlyView)
        NSLayoutConstraint.activate([
            editorSliderOnlyView.topAnchor.constraint(equalTo: editorView.topAnchor),
            editorSliderOnlyView.leadingAnchor.constraint(equalTo: editorView.leadingAnchor),
            editorSliderOnlyView.trailingAnchor.constraint(equalTo: editorView.trailingAnchor),
            editorSliderOnlyView.bottomAnchor.constraint(equalTo: editorView.bottomAnchor)
        ])
        self.editorSliderOnlyView = editorSliderOnlyView
        
        // Editor Only Slider Label
        let editorSliderOnlyLabel = UILabel()
        editorSliderOnlyLabel.font = editorSliderOnlyLabelFont
        editorSliderOnlyLabel.textColor = .black
        editorSliderOnlyLabel.textAlignment = .left
        editorSliderOnlyLabel.textColor = .black
        editorSliderOnlyLabel.text = "Water Level"
        editorSliderOnlyLabel.translatesAutoresizingMaskIntoConstraints = false
        editorSliderOnlyView.addSubview(editorSliderOnlyLabel)
        NSLayoutConstraint.activate([
            editorSliderOnlyLabel.leadingAnchor.constraint(equalTo: editorSliderOnlyView.leadingAnchor, constant: 8),
            editorSliderOnlyLabel.topAnchor.constraint(equalTo: editorSliderOnlyView.topAnchor, constant: 8)
        ])
        self.editorSliderOnlyLabel = editorSliderOnlyLabel
        
        // Editor Slider Only Value View
        let editorSliderOnlyValueView = UIView()
        editorSliderOnlyValueView.backgroundColor = .accentColor
        editorSliderOnlyValueView.layer.cornerRadius = 2
        editorSliderOnlyValueView.layer.borderColor = UIColor.black.cgColor
        editorSliderOnlyValueView.layer.borderWidth = 2
        editorSliderOnlyValueView.translatesAutoresizingMaskIntoConstraints = false
        editorSliderOnlyView.addSubview(editorSliderOnlyValueView)
        NSLayoutConstraint.activate([
            editorSliderOnlyValueView.topAnchor.constraint(equalTo: editorSliderOnlyLabel.bottomAnchor, constant: 8),
            editorSliderOnlyValueView.leadingAnchor.constraint(equalTo: editorSliderOnlyView.leadingAnchor, constant: 8)
        ])
        self.editorSliderOnlyValueView = editorSliderOnlyValueView
        
        // Editor Only Slider Value Label
        let editorSliderOnlyValueLabel = UILabel()
        editorSliderOnlyValueLabel.font = UIFont(name: StyleGuide.regularPixelFontName, size: StyleGuide.readableMediumFontSize)
        editorSliderOnlyValueLabel.textColor = .black
        editorSliderOnlyValueLabel.textAlignment = .left
        editorSliderOnlyValueLabel.translatesAutoresizingMaskIntoConstraints = false
        editorSliderOnlyValueView.addSubview(editorSliderOnlyValueLabel)
        NSLayoutConstraint.activate([
            editorSliderOnlyValueLabel.topAnchor.constraint(equalTo: editorSliderOnlyValueView.topAnchor, constant: 8),
            editorSliderOnlyValueLabel.leadingAnchor.constraint(equalTo: editorSliderOnlyValueView.leadingAnchor, constant: 4),
            editorSliderOnlyValueLabel.trailingAnchor.constraint(equalTo: editorSliderOnlyValueView.trailingAnchor, constant: -4),
            editorSliderOnlyValueLabel.bottomAnchor.constraint(equalTo: editorSliderOnlyValueView.bottomAnchor, constant: -8)
        ])
        self.editorSliderOnlyValueLabel = editorSliderOnlyValueLabel
        
        // Editor Slider Only Slider View
        let editorSliderOnlySliderView = UIView()
        editorSliderOnlySliderView.backgroundColor = .backgroundColor
        editorSliderOnlySliderView.translatesAutoresizingMaskIntoConstraints = false
        editorSliderOnlyView.addSubview(editorSliderOnlySliderView)
        NSLayoutConstraint.activate([
            editorSliderOnlySliderView.topAnchor.constraint(equalTo: editorSliderOnlyValueView.bottomAnchor),
            editorSliderOnlySliderView.leadingAnchor.constraint(equalTo: editorSliderOnlyView.leadingAnchor, constant: 8),
            editorSliderOnlySliderView.trailingAnchor.constraint(equalTo: editorSliderOnlyView.trailingAnchor, constant: -8),
            editorSliderOnlySliderView.bottomAnchor.constraint(equalTo: editorSliderOnlyView.bottomAnchor)
        ])
        self.editorSliderOnlySliderView = editorSliderOnlySliderView
        
        // Editor Slider Only Slider
        let editorSliderOnlySlider = UISlider()
        editorSliderOnlySlider.addTarget(self, action: #selector(editorSliderOnlySliderValueChanged), for: .valueChanged)
        editorSliderOnlySlider.setThumbImage(UIImage(named: "UI Slider Thumb"), for: .normal)
        
        editorSliderOnlySlider.minimumTrackTintColor = .black
        editorSliderOnlySlider.translatesAutoresizingMaskIntoConstraints = false
        editorSliderOnlySliderView.addSubview(editorSliderOnlySlider)
        NSLayoutConstraint.activate([
            editorSliderOnlySlider.centerYAnchor.constraint(equalTo: editorSliderOnlySliderView.centerYAnchor),
            editorSliderOnlySlider.leadingAnchor.constraint(equalTo: editorSliderOnlySliderView.leadingAnchor),
            editorSliderOnlySlider.trailingAnchor.constraint(equalTo: editorSliderOnlySliderView.trailingAnchor)
        ])
        self.editorSliderOnlySlider = editorSliderOnlySlider
        
        // Parameters Table View
        let parametersTableView = UITableView()
        parametersTableView.delegate = self
        parametersTableView.dataSource = self
        parametersTableView.register(ParameterTableViewCell.self, forCellReuseIdentifier: "parameterCell")
        parametersTableView.separatorStyle = .none
        parametersTableView.backgroundColor = .backgroundColor
        parametersTableView.allowsSelection = true
        parametersTableView.estimatedRowHeight = -1
        parametersTableView.showsVerticalScrollIndicator = false
        parametersTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(parametersTableView)
        NSLayoutConstraint.activate([
            parametersTableView.topAnchor.constraint(equalTo: navigationControllerSeparatorView.bottomAnchor),
            parametersTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            parametersTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            parametersTableView.bottomAnchor.constraint(equalTo: editorSeparatorView.topAnchor)
        ])
        self.parametersTableView = parametersTableView
    }
}

extension ParametersViewController: UITableViewDelegate, UITableViewDataSource {
    // Num Rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ParameterController.shared.getParameterCount()
    }
    
    // Cell for row at
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = parametersTableView.dequeueReusableCell(withIdentifier: "parameterCell", for: indexPath) as? ParameterTableViewCell else {return UITableViewCell()}
        
        if let parameter = ParameterController.shared.getParameterForIndex(index: indexPath.row) {
            cell.parameter = parameter
        }
        
        return cell
    }
    
    // Did Select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectionFeedback.selectionChanged()
        if let parameter = ParameterController.shared.getParameterForIndex(index: indexPath.row) {
            editingParameter = parameter
            updateEditor()
        }
    }
}
