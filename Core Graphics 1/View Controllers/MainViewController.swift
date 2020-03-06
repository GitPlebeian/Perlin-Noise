//
//  ViewController.swift
//  Core Graphics 1
//
//  Created by Jackson Tubbs on 2/11/20.
//  Copyright © 2020 Jackson Tubbs. All rights reserved.
//

import UIKit
import Photos
import GameKit

class MainViewController: UIViewController {
    
    // MARK: Views
    
    weak var imageScrollView: UIScrollView!
    weak var mainImageView:   UIImageView!
    
    weak var actionButton:    UIButton!
    weak var settingsButton:  UIButton!
    
    // MARK: Style Guide
    
    let parametersLeadingTrailingMargin: CGFloat = 8
    let parametersHeight:                CGFloat = 50
    let parametersSpacing:               CGFloat = 8
    
    // Generate Button
    var generateButtonAttributedStringForNormal:      NSAttributedString!
    var generateButtonAttributedStringForHighlighted: NSAttributedString!
    
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
        GenerationController.shared.generateImage { (image) in
            DispatchQueue.main.async {
                guard let image = image else {return}
                self.mainImageView.image = image
            }
        }
    }
    
    // View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: Other Overrides
    
    // Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // MARK: Actions
    
    // Action Button Tapped
    @objc private func actionButtonTapped() {
        updateImage()
    }
    
    // Settings Button Tapped
    @objc private func settingButtonTapped() {
        let parametersViewController = ParametersViewController()
        navigationController?.pushViewController(parametersViewController, animated: true)
    }
    
    // MARK: Helpers
    
    // Update Image
    private func updateImage() {
        GenerationController.shared.generateImage { (image) in
            DispatchQueue.main.async {
                guard let image = image else {return}
                self.mainImageView.image = image
            }
        }
    }
    
    // MARK: Set Style Guide Variables
    
    private func setStyleGuideVariables() {
        // Generate Button
        generateButtonAttributedStringForNormal = NSAttributedString(string: "Generate", attributes: [
            NSAttributedString.Key.font: UIFont(name: StyleGuide.boldPixelFontName, size: StyleGuide.buttonPixelFontSize)!,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ])
        generateButtonAttributedStringForHighlighted = NSAttributedString(string: "Generate", attributes: [
            NSAttributedString.Key.font: UIFont(name: StyleGuide.boldPixelFontName, size: StyleGuide.buttonPixelFontSize)!,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ])
    }
    
    // MARK: Setup Views
    
    private func setupViews() {
        setStyleGuideVariables()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.view.backgroundColor = .backgroundColor
        
        // Settings Button
        let settingsButton = UIButton()
        settingsButton.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)
        settingsButton.setImage(UIImage(named: "White Gear"), for: .normal)
        settingsButton.contentMode = .scaleAspectFit
        settingsButton.tintColor = .black
        settingsButton.backgroundColor = .accentColor
        settingsButton.layer.borderColor = UIColor.black.cgColor
        settingsButton.layer.borderWidth = 2
        settingsButton.layer.cornerRadius = 2
        settingsButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(settingsButton)
        NSLayoutConstraint.activate([
            settingsButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -4),
            settingsButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -4),
            settingsButton.heightAnchor.constraint(equalToConstant: 60),
            settingsButton.widthAnchor.constraint(equalToConstant: 60)
        ])
        self.settingsButton = settingsButton
        
        // Generate Button
        let actionButton = UIButton()
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        actionButton.setAttributedTitle(generateButtonAttributedStringForNormal, for: .normal)
        actionButton.setAttributedTitle(generateButtonAttributedStringForHighlighted, for: .highlighted)
        actionButton.layer.cornerRadius = 2
        actionButton.backgroundColor = .accentColor
        actionButton.layer.borderColor = UIColor.black.cgColor
        actionButton.layer.borderWidth = 2
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(actionButton)
        NSLayoutConstraint.activate([
            actionButton.heightAnchor.constraint(equalToConstant: 60),
            actionButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 4),
            actionButton.trailingAnchor.constraint(equalTo: settingsButton.leadingAnchor, constant: -4),
            actionButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -4)
        ])
        self.actionButton = actionButton
        
        // Image Scroll View
        let imageScrollView = UIScrollView()
        imageScrollView.backgroundColor = .backgroundColor
        imageScrollView.alwaysBounceVertical = true
        imageScrollView.alwaysBounceHorizontal = true
        imageScrollView.decelerationRate = .fast
        imageScrollView.showsVerticalScrollIndicator = false
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.maximumZoomScale = 30
        imageScrollView.delegate = self
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageScrollView)
        NSLayoutConstraint.activate([
            imageScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            imageScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            imageScrollView.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -4)
        ])
        self.imageScrollView = imageScrollView
        
        // Main Image View
        let mainImageView = UIImageView()
        mainImageView.contentMode = .scaleAspectFit
        mainImageView.layer.magnificationFilter = .nearest
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.backgroundColor = .clear
        imageScrollView.addSubview(mainImageView)
        NSLayoutConstraint.activate([
            mainImageView.leadingAnchor.constraint(equalTo: imageScrollView.leadingAnchor),
            mainImageView.trailingAnchor.constraint(equalTo: imageScrollView.trailingAnchor),
            mainImageView.topAnchor.constraint(equalTo: imageScrollView.topAnchor),
            mainImageView.bottomAnchor.constraint(equalTo: imageScrollView.bottomAnchor),
            mainImageView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1),
            mainImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1)
        ])
        self.mainImageView = mainImageView
    }
}

extension MainViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        self.mainImageView
    }
}

extension MainViewController {
    
//    func saveImage() {
//        PHPhotoLibrary.shared().performChanges({
//            guard let image = self.image else {return}
//            let creationRequest = PHAssetCreationRequest.forAsset()
//            guard let imageData = image.pngData() else {
//                print("Unable to create image data")
//                return
//            }
//
//            creationRequest.addResource(with: .photo, data: imageData, options: nil)
//        }) { (success, error) in
//            print("Success: \(success)")
//            if let error = error {
//                print("Error Saving: \(error.localizedDescription)")
//                return
//            }
//        }
//    }
//
//    fileprivate func requestAuthorization() {
//        PHPhotoLibrary.requestAuthorization { (status) in
//            DispatchQueue.main.async {
//                switch status {
//                case .authorized:
//                    self.saveImage()
//                case .notDetermined:
//                    if status == PHAuthorizationStatus.authorized {
//                        self.saveImage()
//                    }
//                case .restricted:
//                    let alert = UIAlertController(title: "Photo Library Restricted", message: "Photo Library access is restricted and cannot be accessed", preferredStyle: .alert)
//                    let okay = UIAlertAction(title: "Ok", style: .default)
//                    alert.addAction(okay)
//                    self.present(alert, animated: true)
//                case .denied:
//                    let alert = UIAlertController(title: "Photo Library Denied", message: "Photo Library access was previously denied.  Please update your Settings.", preferredStyle: .alert)
//                    let settings = UIAlertAction(title: "Settings", style: .default) { (action) in
//                        DispatchQueue.main.async {
//                            if let url = URL(string: UIApplication.openSettingsURLString) {
//                                UIApplication.shared.open(url, options: [:])
//                            }
//                        }
//                    }
//                    let cancel = UIAlertAction(title: "Cancel", style: .cancel)
//                    alert.addAction(settings)
//                    alert.addAction(cancel)
//                    self.present(alert, animated: true)
//                @unknown default:
//                    print("Unknown switch at \(#function)")
//                }
//            }
//        }
//    }
}

