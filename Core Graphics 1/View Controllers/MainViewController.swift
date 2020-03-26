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
    
    // MARK: Properties
    let selectionFeedback: UISelectionFeedbackGenerator = UISelectionFeedbackGenerator()
    
    // MARK: Views
    
    weak var imageScrollView: UIScrollView!
    weak var mainImageView:   UIImageView!
    
    weak var actionButton:    UIButton!
    weak var settingsButton:  UIButton!
    weak var saveImageButton: UIButton!
    weak var saveImageActivityIndicator: UIActivityIndicatorView!
    
    
    // MARK: Style Guide

    // Generate Button
    var generateButtonAttributedStringForNormal:      NSAttributedString!
    var generateButtonAttributedStringForHighlighted: NSAttributedString!
    
    // MARK: Init
    
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
        GenerationController.shared.generateNewTerrain { (image) in
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
    
    // View Did Appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if TutorialController.shared.didDoTutorial(tutorial: .onboarding) == false {
            present(OnboardingTutorialViewController(), animated: true) {
//                TutorialController.shared.completedTutorial(tutorial: .onboarding)
            }
        }
    }
    
    // MARK: Other Overrides
    
    // Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // MARK: Actions
    
    // Action Button Tapped
    @objc private func actionButtonTapped() {
        resetActionButtonColors()
        updateImage()
        selectionFeedback.selectionChanged()
    }
    
    // Action Button Touch Down
    @objc private func actionButtonTouchDown() {
        setActionButtonColorsForHighlighted()
    }
    
    // Action Button Drag Enter
    @objc private func actionButtonDragEnter() {
        setActionButtonColorsForHighlighted()
    }
    
    // Action Button Drag Exit
    @objc private func actionButtonDragExit() {
        resetActionButtonColors()
    }
    
    // Settings Button Tapped
    @objc private func settingsButtonTapped() {
        selectionFeedback.selectionChanged()
        resetSettingsButtonColors()
        let parametersViewController = ParametersViewController()
        navigationController?.pushViewController(parametersViewController, animated: true)
    }
    
    // Settings Button Touch Down
    @objc private func settingsButtonTouchDown() {
        setSettingsButtonColorsForHighlighted()
    }
    
    // Settings Button Drag Enter
    @objc private func settingsButtonDragEnter() {
        setSettingsButtonColorsForHighlighted()
    }
    
    // Settings Button Drag Exit
    @objc private func settingsButtonDragExit() {
        resetSettingsButtonColors()
    }
    
    // Save Button Tapped
    @objc private func saveButtonTapped() {
        selectionFeedback.selectionChanged()
        resetSaveButtonColors()
        saveImage()
    }
    
    // Save Button Touch Down
    @objc private func saveButtonTouchDown() {
        setSaveButtonColorsForHighlighted()
    }
    
    // Save Button Drag Enter
    @objc private func saveButtonDragEnter() {
        setSaveButtonColorsForHighlighted()
    }
    
    // Save Button Drag Exit
    @objc private func saveButtonDragExit() {
        resetSaveButtonColors()
    }
    
    // MARK: Helpers
    
    // Update Image
    private func updateImage() {
        GenerationController.shared.generateNewTerrain { (image) in
            DispatchQueue.main.async {
                guard let image = image else {return}
                self.mainImageView.image = image
            }
        }
    }
    
    // Set Action Button Colors For Highlighted
    private func setActionButtonColorsForHighlighted() {
        actionButton.backgroundColor = .black
    }
    
    // Reset Action Button Colors
    private func resetActionButtonColors() {
        actionButton.backgroundColor = .accentColor
    }
    
    // Set Settings Button Colors For Highlighted
    private func setSettingsButtonColorsForHighlighted() {
        settingsButton.backgroundColor = .black
    }
    
    // Reset Settings Button Colors For Highlighted
    private func resetSettingsButtonColors() {
        settingsButton.backgroundColor = .accentColor
    }
    
    // Set Save Button Colors For Highlighted
    private func setSaveButtonColorsForHighlighted() {
        saveImageButton.backgroundColor = .black
    }
    
    // Reset Save Button Colors
    private func resetSaveButtonColors() {
        saveImageButton.backgroundColor = .accentColor
    }
    
    // Present Basic Alert
    private func presentBasicAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
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
            NSAttributedString.Key.foregroundColor: UIColor.white
        ])
    }
    
    // MARK: Setup Views
    
    private func setupViews() {
        setStyleGuideVariables()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.view.backgroundColor = .backgroundColor
        
        // Settings Button
        let settingsButton = UIButton()
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(settingsButtonTouchDown), for: .touchDown)
        settingsButton.addTarget(self, action: #selector(settingsButtonDragEnter), for: .touchDragEnter)
        settingsButton.addTarget(self, action: #selector(settingsButtonDragExit), for: .touchDragExit)
        settingsButton.setImage(UIImage(named: "Black Gear"), for: .normal)
        settingsButton.setImage(UIImage(named: "White Gear"), for: .highlighted)
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
        
        // Save Image Button
        let saveImageButton = UIButton()
        saveImageButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveImageButton.addTarget(self, action: #selector(saveButtonTouchDown), for: .touchDown)
        saveImageButton.addTarget(self, action: #selector(saveButtonDragEnter), for: .touchDragEnter)
        saveImageButton.addTarget(self, action: #selector(saveButtonDragExit), for: .touchDragExit)
        saveImageButton.setImage(UIImage(named: "Black Save"), for: .normal)
        saveImageButton.setImage(UIImage(named: "White Save"), for: .highlighted)
        saveImageButton.setImage(UIImage(named: "Transparent"), for: .disabled)
        saveImageButton.contentMode = .scaleAspectFit
        saveImageButton.imageEdgeInsets = UIEdgeInsets(top: 17, left: 17, bottom: 17, right: 17)
        saveImageButton.backgroundColor = .accentColor
        saveImageButton.layer.cornerRadius = 2
        saveImageButton.layer.borderColor = UIColor.black.cgColor
        saveImageButton.layer.borderWidth = 2
        saveImageButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(saveImageButton)
        NSLayoutConstraint.activate([
            saveImageButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 4),
            saveImageButton.heightAnchor.constraint(equalToConstant: 60),
            saveImageButton.widthAnchor.constraint(equalToConstant: 60),
            saveImageButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -4)
        ])
        self.saveImageButton = saveImageButton
        
        // Save Image Activity Indicator
        let saveImageActivityIndicator = UIActivityIndicatorView()
        saveImageActivityIndicator.hidesWhenStopped = true
        saveImageActivityIndicator.color = .black
        saveImageActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        saveImageButton.addSubview(saveImageActivityIndicator)
        NSLayoutConstraint.activate([
            saveImageActivityIndicator.centerYAnchor.constraint(equalTo: saveImageButton.centerYAnchor),
            saveImageActivityIndicator.centerXAnchor.constraint(equalTo: saveImageButton.centerXAnchor)
        ])
        self.saveImageActivityIndicator = saveImageActivityIndicator
        
        // Generate Button
        let actionButton = UIButton()
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(actionButtonTouchDown), for: .touchDown)
        actionButton.addTarget(self, action: #selector(actionButtonDragEnter), for: .touchDragEnter)
        actionButton.addTarget(self, action: #selector(actionButtonDragExit), for: .touchDragExit)
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
            actionButton.leadingAnchor.constraint(equalTo: saveImageButton.trailingAnchor, constant: 4),
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
    
    private func saveImage() {
        saveImageButton.isEnabled = false
        actionButton.isEnabled = false
        saveImageActivityIndicator.startAnimating()
        PHPhotoLibrary.requestAuthorization { (status) in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    GenerationController.shared.saveImage { (success) in
                        DispatchQueue.main.async {
                            self.actionButton.isEnabled = true
                            self.saveImageButton.isEnabled = true
                            self.saveImageActivityIndicator.stopAnimating()
                            let feedback = UINotificationFeedbackGenerator()
                            if success {
                                feedback.notificationOccurred(.success)
                            } else {
                                feedback.notificationOccurred(.error)
                                self.presentBasicAlert(title: "Unable To Save Image", message: nil)
                            }
                        }
                    }
                case .notDetermined:
                    if status == PHAuthorizationStatus.authorized {
                        GenerationController.shared.saveImage { (success) in
                            DispatchQueue.main.async {
                                self.actionButton.isEnabled = true
                                self.saveImageButton.isEnabled = true
                                self.saveImageActivityIndicator.stopAnimating()
                                let feedback = UINotificationFeedbackGenerator()
                                if success {
                                    feedback.notificationOccurred(.success)
                                } else {
                                    feedback.notificationOccurred(.error)
                                    self.presentBasicAlert(title: "Unable To Save Image", message: nil)
                                }
                            }
                        }
                    }
                case .restricted:
                    let alert = UIAlertController(title: "Photo Library Restricted", message: "Photo Library access is restricted and cannot be accessed", preferredStyle: .alert)
                    let okay = UIAlertAction(title: "Ok", style: .default)
                    alert.addAction(okay)
                    self.present(alert, animated: true)
                case .denied:
                    let alert = UIAlertController(title: "Photo Library Denied", message: "Photo Library access was previously denied.  Please update your Settings.", preferredStyle: .alert)
                    let settings = UIAlertAction(title: "Settings", style: .default) { (action) in
                        DispatchQueue.main.async {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url, options: [:])
                            }
                        }
                    }
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel)
                    alert.addAction(settings)
                    alert.addAction(cancel)
                    self.present(alert, animated: true)
                @unknown default:
                    print("Unknown switch at \(#function)")
                }
            }
        }
    }
}

