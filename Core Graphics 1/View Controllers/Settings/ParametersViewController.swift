//
//  ParametersViewController.swift
//  Core Graphics 1
//
//  Created by Jackson Tubbs on 2/22/20.
//  Copyright © 2020 Jackson Tubbs. All rights reserved.
//

import UIKit

class ParametersViewController: UIViewController {

    // MARK: Views
    
    weak var navigationControllerSeparatorView: UIView!
    weak var editorView:                        UIView!
    weak var parametersTableView:               UITableView!
    
    // MARK: Style Guide
    
    // Editor View
    let editorViewHeight: CGFloat = 150
    
    
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
    
    // MARK: Other Overrides
    
    // Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // MARK: Actions
    
    // MARK: Set Style Guide Variables
    
    private func setStyleGuideVariables() {
        
    }
    
    // MARK: Setup Views
    
    private func setupViews() {
        setStyleGuideVariables()
        
        self.view.backgroundColor = .backgroundColor
        
        // Naviagtion Controller Separator View
        let navigationControllerSeparatorView = UIView()
        navigationControllerSeparatorView.backgroundColor = .white
        navigationControllerSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(navigationControllerSeparatorView)
        NSLayoutConstraint.activate([
            navigationControllerSeparatorView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            navigationControllerSeparatorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            navigationControllerSeparatorView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            navigationControllerSeparatorView.heightAnchor.constraint(equalToConstant: 3)
        ])
        self.navigationControllerSeparatorView = navigationControllerSeparatorView
        
        // Editor View
        let editorView = UIView()
        editorView.backgroundColor = .tintColor
        editorView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(editorView)
        NSLayoutConstraint.activate([
            editorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            editorView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            editorView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            editorView.heightAnchor.constraint(equalToConstant: editorViewHeight)
        ])
        self.editorView = editorView
        
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
            parametersTableView.bottomAnchor.constraint(equalTo: editorView.topAnchor)
        ])
        self.parametersTableView = parametersTableView
    }
}

extension ParametersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ParameterController.shared.getParameterCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = parametersTableView.dequeueReusableCell(withIdentifier: "parameterCell", for: indexPath) as? ParameterTableViewCell else {return UITableViewCell()}
        
        if let parameter = ParameterController.shared.getParameterForIndex(index: indexPath.row) {
            cell.parameter = parameter
        }
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return -1
//    }
}
