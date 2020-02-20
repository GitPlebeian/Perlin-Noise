//
//  ViewController.swift
//  Core Graphics 1
//
//  Created by Jackson Tubbs on 2/11/20.
//  Copyright © 2020 Jackson Tubbs. All rights reserved.
//

import UIKit
import Photos

class MainViewController: UIViewController {
    
    // MARK: Generation Variables
    
    let height: Int = 1080
    let width: Int = 1920
    
    // MARK: Properties
    
    var image: UIImage?
    
    // MARK: Views
    
    weak var mainImageView: UIView!
    
    // MARK: Style Guide
    
    // MARK: Object Lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: Actions
    
    @objc private func canvasPinchGesturePinched(_ pinch: UIPinchGestureRecognizer) {
//        PHPhoto
    }
    
    // MARK: Helpers
    
    private func setProperties() {

    }
    
    // MARK: Setup Views
    
    private func setupViews() {
        setProperties()
        
        self.view.backgroundColor = .white
        
        guard let image = createImage() else {return}
        self.image = image
        
        // Main Image View
        let mainImageView = UIImageView(image: image)
        mainImageView.contentMode = .scaleAspectFit
        mainImageView.layer.magnificationFilter = .nearest
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.backgroundColor = .clear
        self.view.addSubview(mainImageView)
        NSLayoutConstraint.activate([
            mainImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mainImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mainImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            mainImageView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        requestAuthorization()
    }
    
    func createImage() -> UIImage? {
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = self.width
        let height           = self.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = RGBA32.bitmapInfo
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            print("unable to create context")
            return nil
        }
        
        guard let buffer = context.data else {
            print("Unable To Get Context Data")
            return nil
        }
        
        let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)
        
        for row in 0 ..< Int(height) {
            for column in 0 ..< Int(width) {
                let offset = row * width + column
                if Int.random(in: 0...3) == 0 {
                    pixelBuffer[offset] = .blue
                } else {
                    pixelBuffer[offset] = .cyan
                }
            }
        }
        context.interpolationQuality = .none
        let outputCGImage = context.makeImage()!
        
        let outputImage = UIImage(cgImage: outputCGImage, scale: 1, orientation: UIImage.Orientation.up)
        
        return outputImage
    }
    
    
    struct RGBA32: Equatable {
        private var color: UInt32

        var redComponent: UInt8 {
            return UInt8((color >> 24) & 255)
        }

        var greenComponent: UInt8 {
            return UInt8((color >> 16) & 255)
        }

        var blueComponent: UInt8 {
            return UInt8((color >> 8) & 255)
        }

        var alphaComponent: UInt8 {
            return UInt8((color >> 0) & 255)
        }

        init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
            let red   = UInt32(red)
            let green = UInt32(green)
            let blue  = UInt32(blue)
            let alpha = UInt32(alpha)
            color = (red << 24) | (green << 16) | (blue << 8) | (alpha << 0)
        }

        static let red     = RGBA32(red: 255, green: 0,   blue: 0,   alpha: 255)
        static let green   = RGBA32(red: 0,   green: 255, blue: 0,   alpha: 255)
        static let blue    = RGBA32(red: 0,   green: 0,   blue: 255, alpha: 255)
        static let white   = RGBA32(red: 255, green: 255, blue: 255, alpha: 255)
        static let black   = RGBA32(red: 0,   green: 0,   blue: 0,   alpha: 255)
        static let magenta = RGBA32(red: 255, green: 0,   blue: 255, alpha: 255)
        static let yellow  = RGBA32(red: 255, green: 255, blue: 0,   alpha: 255)
        static let cyan    = RGBA32(red: 0,   green: 255, blue: 255, alpha: 255)

        static let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue

        static func ==(lhs: RGBA32, rhs: RGBA32) -> Bool {
            return lhs.color == rhs.color
        }
    }
}

extension MainViewController {
    
    func saveImage() {
        PHPhotoLibrary.shared().performChanges({
            guard let image = self.image else {return}
            let creationRequest = PHAssetCreationRequest.forAsset()
            guard let imageData = image.pngData() else {
                print("Unable to create image data")
                return
            }
            
            creationRequest.addResource(with: .photo, data: imageData, options: nil)
        }) { (success, error) in
            print("Success: \(success)")
            if let error = error {
                print("Error Saving: \(error.localizedDescription)")
                return
            }
        }
    }
    
    fileprivate func requestAuthorization() {
        PHPhotoLibrary.requestAuthorization { (status) in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    self.saveImage()
                case .notDetermined:
                    if status == PHAuthorizationStatus.authorized {
                        self.saveImage()
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

