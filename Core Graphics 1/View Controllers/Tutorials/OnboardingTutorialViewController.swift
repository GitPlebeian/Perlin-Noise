//
//  OnboardingTutorialViewController.swift
//  Core Graphics 1
//
//  Created by Jackson Tubbs on 3/25/20.
//  Copyright © 2020 Jackson Tubbs. All rights reserved.
//

import UIKit

class OnboardingTutorialViewController: UIViewController {

    // MARK: Views
    
    let numberOfPages = 2
    
    // MARK: Styleguide

    // MARK: Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: Helpers
    
    // MARK: Setup Views
    private func setupViews() {
        self.view.backgroundColor = .backgroundColor
        
        let scrollView = UIScrollView()
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = false
        scrollView.backgroundColor = .blue
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        for page in 0..<numberOfPages {
            let parentView = UIView()
            parentView.backgroundColor = .red
            parentView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(parentView)
            NSLayoutConstraint.activate([
                parentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                parentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                parentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                parentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                parentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                parentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
            ])
        }
    }
}
