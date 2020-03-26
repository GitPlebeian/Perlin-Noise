//
//  OnboardingTutorialViewController.swift
//  Core Graphics 1
//
//  Created by Jackson Tubbs on 3/25/20.
//  Copyright © 2020 Jackson Tubbs. All rights reserved.
//

import UIKit

class OnboardingTutorialViewController: UIViewController {

    // MARK: Properties
    
    let numberOfPages = 3
    var pageOriginPoints: [CGFloat] = []
    
    // MARK: Views
    
    var parentViews: [UIView] = []
    var pageIndicatorDots: [UIView] = []
    
    // MARK: Style Guide
    
    let pageIndicatorDotHeight: CGFloat = 16
    let pageIndicatorDotSpacing: CGFloat = 0

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
    
    // MARK: Other Overrides
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        for page in 0..<numberOfPages {
//            print("Page: \(page) Frame: \(parentViews[page].frame)")
//        }
//    }
    
    // MARK: Helpers
    
    // MARK: Setup Views
    private func setupViews() {
        self.view.backgroundColor = .backgroundColor
        
        let pageIndicatorParentView = UIView()
        pageIndicatorParentView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pageIndicatorParentView)
        NSLayoutConstraint.activate([
            pageIndicatorParentView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            pageIndicatorParentView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            pageIndicatorParentView.heightAnchor.constraint(equalToConstant: pageIndicatorDotHeight)
        ])
        
        for page in 0..<numberOfPages {
            let pageDot = UIView()
            pageDot.backgroundColor = .accentColor
            pageDot.layer.cornerRadius = pageIndicatorDotHeight / 2
            pageDot.translatesAutoresizingMaskIntoConstraints = false
            pageIndicatorParentView.addSubview(pageDot)
            if page == 0 {
                pageDot.leadingAnchor.constraint(equalTo: pageIndicatorParentView.leadingAnchor).isActive = true
            } else {
                pageDot.leadingAnchor.constraint(equalTo: pageIndicatorDots[page - 1].trailingAnchor, constant: pageIndicatorDotSpacing).isActive = true
                if page == numberOfPages - 1 {
                    pageDot.trailingAnchor.constraint(equalTo: pageIndicatorParentView.trailingAnchor).isActive = true
                }
            }
            NSLayoutConstraint.activate([
                pageDot.heightAnchor.constraint(equalTo: pageIndicatorParentView.heightAnchor),
                pageDot.widthAnchor.constraint(equalTo: pageIndicatorParentView.heightAnchor)
            ])
            if page != 0 {
                pageDot.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }
            pageIndicatorDots.append(pageDot)
        }
        
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.decelerationRate = .fast
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
            scrollView.bottomAnchor.constraint(equalTo: pageIndicatorParentView.topAnchor, constant: -8)
        ])

        for page in 0..<numberOfPages {
            let parentView = UIView()
            parentView.backgroundColor = .backgroundColor
            parentView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(parentView)
            if page == 0 {
                parentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
            } else {
                parentView.leadingAnchor.constraint(equalTo: parentViews[page - 1].trailingAnchor).isActive = true
                if page == numberOfPages - 1 {
                    parentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
                }
            }
            NSLayoutConstraint.activate([
                parentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                parentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                parentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                parentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
            ])
            parentViews.append(parentView)
            pageOriginPoints.append(CGFloat(page) * self.view.frame.width + self.view.frame.width / 2)

            let dot = UIView()
            dot.backgroundColor = .black
            dot.translatesAutoresizingMaskIntoConstraints = false
            parentView.addSubview(dot)
            NSLayoutConstraint.activate([
                dot.centerYAnchor.constraint(equalTo: parentView.centerYAnchor),
                dot.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
                dot.heightAnchor.constraint(equalToConstant: 30),
                dot.widthAnchor.constraint(equalToConstant: 30)
            ])
        }
    }
}

extension OnboardingTutorialViewController: UIScrollViewDelegate {
    
    // Did Scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for (index, originPoint) in pageOriginPoints.enumerated() {
            var multiplier = (((scrollView.contentOffset.x + self.view.frame.width / 2) - originPoint) / self.view.frame.width)
            if multiplier < 0 {
                multiplier *= -1
            }
            if multiplier > 0.5 {
                pageIndicatorDots[index].transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            } else {
                pageIndicatorDots[index].transform = CGAffineTransform(scaleX: 1 - multiplier, y: 1 - multiplier)
            }
        }
    }
    
    // Paging Feature
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        var closestPoint: CGFloat = CGFloat.infinity
        for index in 0..<pageOriginPoints.count {
            var distanceToOrigin = targetContentOffset.pointee.x + self.view.bounds.width / 2 - pageOriginPoints[index]
            if distanceToOrigin < 0 {
                distanceToOrigin *= -1
            }
            if distanceToOrigin  < closestPoint {
                closestPoint = distanceToOrigin
                if index + 1 == pageOriginPoints.count {
                    targetContentOffset.pointee = CGPoint(x: pageOriginPoints[index] - self.view.frame.width / 2, y: 0)
                }
            } else if index == 0 {
                targetContentOffset.pointee = CGPoint(x: pageOriginPoints[index] - self.view.frame.width / 2, y: 0)
                return
            } else {
                targetContentOffset.pointee = CGPoint(x: pageOriginPoints[index - 1] - self.view.frame.width / 2, y: 0)
                return
            }
        }
    }
}
