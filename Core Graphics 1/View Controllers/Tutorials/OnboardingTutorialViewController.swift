//
//  OnboardingTutorialViewController.swift
//  Core Graphics 1
//
//  Created by Jackson Tubbs on 3/25/20.
//  Copyright © 2020 Jackson Tubbs. All rights reserved.
//

import UIKit
import StoreKit

class OnboardingTutorialViewController: UIViewController {

    // MARK: Properties
    
    let numberOfPages = 2
    var pageOriginPoints: [CGFloat] = []
    
    // MARK: Views
    
    var parentViews: [UIView] = []
    var pageIndicatorDots: [UIView] = []
    weak var rateButton: UIButton!
    
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
    
    // MARK: Actions
    
    // Rate App Button Tapped
    @objc private func rateAppButtonTapped() {
        resetRateAppButton()
        SKStoreReviewController.requestReview()
    }
    
    // Rate App Button Touch Down
    @objc private func rateAppButtonTouchDown() {
        setRateAppButton()
    }
    
    // Rate App Button Drag Enter
    @objc private func rateAppButtonDragEnter() {
        setRateAppButton()
    }
    
    // Rate App Button Drag Exit
    @objc private func rateAppButtonDragExit() {
        resetRateAppButton()
    }
    
    // Rate App Button Canceled
    @objc private func rateAppButtonCanceled() {
        resetRateAppButton()
    }
    
    // MARK: Helpers
    
    // Reset Rate App Button
    func resetRateAppButton() {
        rateButton.backgroundColor = .accentColor
    }
    
    // Set Rate App Button
    func setRateAppButton() {
        rateButton.backgroundColor = .black
    }
    
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
        scrollView.backgroundColor = .backgroundColor
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
            
            switch page {
            case 0:
                let layoutView = UIView()
                layoutView.translatesAutoresizingMaskIntoConstraints = false
                parentView.addSubview(layoutView)
                NSLayoutConstraint.activate([
                    layoutView.centerYAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.centerYAnchor),
                    layoutView.widthAnchor.constraint(equalTo: parentView.widthAnchor, multiplier: 0.85),
                    layoutView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor)
                ])
                let welcomeLabel = UILabel()
                welcomeLabel.font = UIFont(name: StyleGuide.boldPixelFontName, size: 40)
                welcomeLabel.text = "Welcome"
                welcomeLabel.textColor = .black
                welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
                layoutView.addSubview(welcomeLabel)
                NSLayoutConstraint.activate([
                    welcomeLabel.topAnchor.constraint(equalTo: layoutView.topAnchor, constant: 0),
                    welcomeLabel.leadingAnchor.constraint(equalTo: layoutView.leadingAnchor, constant: 0),
                    welcomeLabel.trailingAnchor.constraint(equalTo: layoutView.trailingAnchor)
                ])
                let messageLabelStyle = NSMutableParagraphStyle()
                messageLabelStyle.lineSpacing = 3
                let messageLabelString = NSMutableAttributedString(string: "This app generates random terrain-like images using Perlin Noise.\n\nThis app’s design was inspired by the game Papers Please.")
                messageLabelString.addAttribute(NSAttributedString.Key.paragraphStyle, value: messageLabelStyle, range: NSMakeRange(0, messageLabelString.length))
                let messageLabel = UILabel()
                messageLabel.font = UIFont(name: StyleGuide.regularPixelFontName, size: 18)
                messageLabel.textColor = .black
                messageLabel.numberOfLines = 0
                messageLabel.attributedText = messageLabelString
                messageLabel.translatesAutoresizingMaskIntoConstraints = false
                layoutView.addSubview(messageLabel)
                NSLayoutConstraint.activate([
                    messageLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 8),
                    messageLabel.leadingAnchor.constraint(equalTo: welcomeLabel.leadingAnchor),
                    messageLabel.trailingAnchor.constraint(equalTo: layoutView.trailingAnchor)
                ])
                
                let generateParentView = UIView()
                generateParentView.translatesAutoresizingMaskIntoConstraints = false
                layoutView.addSubview(generateParentView)
                NSLayoutConstraint.activate([
                    generateParentView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 30),
                    generateParentView.leadingAnchor.constraint(equalTo: layoutView.leadingAnchor),
                    generateParentView.trailingAnchor.constraint(equalTo: layoutView.trailingAnchor)
                ])

                let generateDescriptionString = NSMutableAttributedString(string: "To create a new image using your given parameters, tap")
                generateDescriptionString.addAttribute(NSAttributedString.Key.paragraphStyle, value: messageLabelStyle, range: NSMakeRange(0, generateDescriptionString.length))
                let generateDescription = UILabel()
                generateDescription.attributedText = generateDescriptionString
                generateDescription.font = UIFont(name: StyleGuide.regularPixelFontName, size: 18)
                generateDescription.textColor = .black
                generateDescription.numberOfLines = 0
                generateDescription.translatesAutoresizingMaskIntoConstraints = false
                generateParentView.addSubview(generateDescription)
                NSLayoutConstraint.activate([
                    generateDescription.topAnchor.constraint(equalTo: generateParentView.topAnchor, constant: 0),
                    generateDescription.leadingAnchor.constraint(equalTo: generateParentView.leadingAnchor),
                    generateDescription.trailingAnchor.constraint(equalTo: generateParentView.trailingAnchor)
                ])
                
                let generateButton = UIImageView(image: UIImage(named: "Generate Button"))
                generateButton.contentMode = .scaleAspectFit
                generateButton.translatesAutoresizingMaskIntoConstraints = false
                generateParentView.addSubview(generateButton)
                NSLayoutConstraint.activate([
                    generateButton.leadingAnchor.constraint(equalTo: generateParentView.leadingAnchor),
                    generateButton.topAnchor.constraint(equalTo: generateDescription.bottomAnchor, constant: 8),
                    generateButton.widthAnchor.constraint(equalToConstant: 60 * 3.983333),
                    generateButton.heightAnchor.constraint(equalToConstant: 60),
                    generateButton.bottomAnchor.constraint(equalTo: generateParentView.bottomAnchor)
                ])
                
                let settingsParentView = UIView()
                settingsParentView.translatesAutoresizingMaskIntoConstraints = false
                layoutView.addSubview(settingsParentView)
                NSLayoutConstraint.activate([
                    settingsParentView.topAnchor.constraint(equalTo: generateParentView.bottomAnchor, constant: 30),
                    settingsParentView.leadingAnchor.constraint(equalTo: layoutView.leadingAnchor),
                    settingsParentView.trailingAnchor.constraint(equalTo: layoutView.trailingAnchor)
                ])
                
                let settingsLabelString = NSMutableAttributedString(string: "To edit your parameters, tap")
                settingsLabelString.addAttribute(NSAttributedString.Key.paragraphStyle, value: messageLabelStyle, range: NSMakeRange(0, settingsLabelString.length))
                let settingsLabel = UILabel()
                settingsLabel.font = UIFont(name: StyleGuide.regularPixelFontName, size: 18)
                settingsLabel.textColor = .black
                settingsLabel.attributedText = settingsLabelString
                settingsLabel.numberOfLines = 0
                settingsLabel.translatesAutoresizingMaskIntoConstraints = false
                settingsParentView.addSubview(settingsLabel)
                NSLayoutConstraint.activate([
                    settingsLabel.topAnchor.constraint(equalTo: settingsParentView.topAnchor),
                    settingsLabel.leadingAnchor.constraint(equalTo: settingsParentView.leadingAnchor),
                    settingsLabel.trailingAnchor.constraint(equalTo: settingsParentView.trailingAnchor)
                ])
                
                let settingsButton = UIImageView(image: UIImage(named: "Settings Button"))
                settingsButton.contentMode = .scaleAspectFit
                settingsButton.translatesAutoresizingMaskIntoConstraints = false
                settingsParentView.addSubview(settingsButton)
                NSLayoutConstraint.activate([
                    settingsButton.topAnchor.constraint(equalTo: settingsLabel.bottomAnchor, constant: 8),
                    settingsButton.leadingAnchor.constraint(equalTo: settingsParentView.leadingAnchor),
                    settingsButton.heightAnchor.constraint(equalToConstant: 60),
                    settingsButton.widthAnchor.constraint(equalToConstant: 60),
                    settingsButton.bottomAnchor.constraint(equalTo: settingsParentView.bottomAnchor)
                ])
                
                let saveParentView = UIView()
                saveParentView.translatesAutoresizingMaskIntoConstraints = false
                layoutView.addSubview(saveParentView)
                NSLayoutConstraint.activate([
                    saveParentView.topAnchor.constraint(equalTo: settingsParentView.bottomAnchor, constant: 30),
                    saveParentView.leadingAnchor.constraint(equalTo: layoutView.leadingAnchor),
                    saveParentView.trailingAnchor.constraint(equalTo: layoutView.trailingAnchor),
                    saveParentView.bottomAnchor.constraint(equalTo: layoutView.bottomAnchor)
                ])
                
                let saveLabelString = NSMutableAttributedString(string: "The button below will save the image around 3000 x 3000 pixels")
                saveLabelString.addAttribute(NSAttributedString.Key.paragraphStyle, value: messageLabelStyle, range: NSMakeRange(0, saveLabelString.length))
                let saveLabel = UILabel()
                saveLabel.font = UIFont(name: StyleGuide.regularPixelFontName, size: 18)
                saveLabel.textColor = .black
                saveLabel.attributedText = saveLabelString
                saveLabel.numberOfLines = 0
                saveLabel.translatesAutoresizingMaskIntoConstraints = false
                saveParentView.addSubview(saveLabel)
                NSLayoutConstraint.activate([
                    saveLabel.topAnchor.constraint(equalTo: saveParentView.topAnchor),
                    saveLabel.leadingAnchor.constraint(equalTo: saveParentView.leadingAnchor),
                    saveLabel.trailingAnchor.constraint(equalTo: saveParentView.trailingAnchor)
                ])
                
                let saveButton = UIImageView(image: UIImage(named: "Save Button"))
                saveButton.contentMode = .scaleAspectFit
                saveButton.translatesAutoresizingMaskIntoConstraints = false
                saveParentView.addSubview(saveButton)
                NSLayoutConstraint.activate([
                    saveButton.topAnchor.constraint(equalTo: saveLabel.bottomAnchor, constant: 8),
                    saveButton.leadingAnchor.constraint(equalTo: saveParentView.leadingAnchor),
                    saveButton.heightAnchor.constraint(equalToConstant: 60),
                    saveButton.widthAnchor.constraint(equalToConstant: 60),
                    saveButton.bottomAnchor.constraint(equalTo: saveParentView.bottomAnchor)
                ])
            case 1:
                let layoutView = UIView()
                layoutView.translatesAutoresizingMaskIntoConstraints = false
                parentView.addSubview(layoutView)
                NSLayoutConstraint.activate([
                    layoutView.centerYAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.centerYAnchor),
                    layoutView.widthAnchor.constraint(equalTo: parentView.widthAnchor, multiplier: 0.85),
                    layoutView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor)
                ])
                
                let headingLabel = UILabel()
                headingLabel.font = UIFont(name: StyleGuide.boldPixelFontName, size: 40)
                headingLabel.textColor = .black
                headingLabel.text = "About"
                headingLabel.translatesAutoresizingMaskIntoConstraints = false
                layoutView.addSubview(headingLabel)
                NSLayoutConstraint.activate([
                    headingLabel.topAnchor.constraint(equalTo: layoutView.topAnchor),
                    headingLabel.leadingAnchor.constraint(equalTo: layoutView.leadingAnchor),
                    headingLabel.trailingAnchor.constraint(equalTo: layoutView.trailingAnchor)
                ])
                
                let aboutLabelStyle = NSMutableParagraphStyle()
                aboutLabelStyle.lineSpacing = 3
                let aboutLabelString = NSMutableAttributedString(string: "My name is Jax and I built this app in swift without storyboards because I don't like them that much.\n\nThis was a very fun app to code and I most likely spent too much time on UI but I really don't care.")
                aboutLabelString.addAttribute(NSAttributedString.Key.paragraphStyle, value: aboutLabelStyle, range: NSMakeRange(0, aboutLabelString.length))
                let aboutLabel = UILabel()
                aboutLabel.font = UIFont(name: StyleGuide.regularPixelFontName, size: 18)
                aboutLabel.textColor = .black
                aboutLabel.attributedText = aboutLabelString
                aboutLabel.numberOfLines = 0
                aboutLabel.translatesAutoresizingMaskIntoConstraints = false
                layoutView.addSubview(aboutLabel)
                NSLayoutConstraint.activate([
                    aboutLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 8),
                    aboutLabel.leadingAnchor.constraint(equalTo: layoutView.leadingAnchor),
                    aboutLabel.trailingAnchor.constraint(equalTo: layoutView.trailingAnchor)
                ])
                
                let rateAppButtonStringForNormal = NSAttributedString(string: "Rate App", attributes: [
                    NSAttributedString.Key.font: UIFont(name: StyleGuide.regularPixelFontName, size: StyleGuide.buttonPixelFontSize)!,
                    NSAttributedString.Key.foregroundColor: UIColor.black
                ])
                let rateAppButtonStringForHighlighted = NSAttributedString(string: "Rate App", attributes: [
                    NSAttributedString.Key.font: UIFont(name: StyleGuide.regularPixelFontName, size: StyleGuide.buttonPixelFontSize)!,
                    NSAttributedString.Key.foregroundColor: UIColor.white
                ])
                
                let rateAppButton = UIButton()
                rateAppButton.addTarget(self, action: #selector(rateAppButtonTapped), for: .touchUpInside)
                rateAppButton.addTarget(self, action: #selector(rateAppButtonTouchDown), for: .touchDown)
                rateAppButton.addTarget(self, action: #selector(rateAppButtonDragEnter), for: .touchDragEnter)
                rateAppButton.addTarget(self, action: #selector(rateAppButtonDragExit), for: .touchDragExit)
                rateAppButton.addTarget(self, action: #selector(rateAppButtonCanceled), for: .touchCancel)
                rateAppButton.layer.borderColor = UIColor.black.cgColor
                rateAppButton.layer.borderWidth = 2
                rateAppButton.layer.cornerRadius = 2
                rateAppButton.backgroundColor = .accentColor
                rateAppButton.setAttributedTitle(rateAppButtonStringForNormal, for: .normal)
                rateAppButton.setAttributedTitle(rateAppButtonStringForHighlighted, for: .highlighted)
                rateAppButton.translatesAutoresizingMaskIntoConstraints = false
                layoutView.addSubview(rateAppButton)
                NSLayoutConstraint.activate([
                    rateAppButton.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: 30),
                    rateAppButton.leadingAnchor.constraint(equalTo: layoutView.leadingAnchor),
                    rateAppButton.trailingAnchor.constraint(equalTo: layoutView.trailingAnchor),
                    rateAppButton.heightAnchor.constraint(equalToConstant: 60),
                    rateAppButton.bottomAnchor.constraint(equalTo: layoutView.bottomAnchor)
                ])
                self.rateButton = rateAppButton
            default:
                print("Unknown page")
            }
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
