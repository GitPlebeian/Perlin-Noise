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
    
    // MARK: Generation Variables
    
    let height: Int = 300
    let width: Int = 300
    
    // MARK: Properties

    var image: UIImage?
    var map: [[Float]] = []
    
    // Noise
    var noiseMap: GKNoiseMap!
    
    // MARK: Views
    
    weak var imageScrollView: UIScrollView!
    weak var mainImageView: UIImageView!
    weak var actionButton: UIButton!
    
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
    
    @objc private func actionButtonTapped() {
        updateImage()
    }
    
    // MARK: Helpers
    
    private func setProperties() {

    }
    
    func getColorForXY(x: Int, y: Int) -> RGBA32 {
        let randomInt = UInt8.random(in: 0...255)
        
//        let randomRed   = UInt8.random(in: 0...255)
//        let randomGreen = UInt8.random(in: 0...255)
//        let randomBlue  = UInt8.random(in: 0...255)
        
        let randomColor = RGBA32(red: randomInt, green: randomInt, blue: randomInt, alpha: 1)
        return randomColor
    }
    
    func getColorForFloat(number: Float) -> RGBA32 {
//        print("\(number) : \((number + 1) * (255 / 2))")
        let scalledNumber = UInt8((number + 1) * (255 / 2))
//        print(scalledNumber)
        let color = RGBA32(red: scalledNumber, green: scalledNumber, blue: scalledNumber, alpha: 1)
        return color
    }
    
    private func noise(x: Int, y: Int) {
        
    }
    
    private func updateImage() {
        guard let image = createImage() else {return}
        self.image = image
        mainImageView.image = image
    }
    
    // MARK: Setup Views
    
    private func setupViews() {
        setProperties()
        
        self.view.backgroundColor = .white
        
        guard let image = createImage() else {return}
        self.image = image
        
        // Image Scroll View
        let imageScrollView = UIScrollView()
        imageScrollView.backgroundColor = .black
        imageScrollView.alwaysBounceVertical = true
        imageScrollView.alwaysBounceHorizontal = true
        imageScrollView.maximumZoomScale = 30
        imageScrollView.delegate = self
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageScrollView)
        NSLayoutConstraint.activate([
            imageScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            imageScrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            imageScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.imageScrollView = imageScrollView
        
        // Main Image View
        let mainImageView = UIImageView(image: image)
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
        
        // Refresh Button
        let actionButton = UIButton()
        actionButton.backgroundColor = .white
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        actionButton.setTitle("Action", for: .normal)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(actionButton)
        NSLayoutConstraint.activate([
            actionButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 60),
            actionButton.widthAnchor.constraint(equalToConstant: 60),
            actionButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -32)
        ])
        self.actionButton = actionButton
    }
    
    func createImage() -> UIImage? {
        
//        let tileThing = SKTileMapNode(
        let noiseSource = GKPerlinNoiseSource()
//        noiseSource.
//        noiseSource.seed = Int32.random(in: 0...Int32.max)
        noiseSource.seed = 1
//        noiseSource.frequency = 3
//        noiseSource.octaveCount = 1
//        noiseSource.lacunarity = 4
        let noise = GKNoise(noiseSource)
//        noise.applyTurbulence(frequency: 1000, power: 10000, roughness: 2, seed: 8)
        noiseMap = GKNoiseMap(noise)
//        print("\nSize: \(noiseMap.size)")
//        print("Origin: \(noiseMap.origin)")
//        print("Sample Count: \(noiseMap.sampleCount)")
        noiseMap = GKNoiseMap(noise, size: SIMD2(arrayLiteral: 1, 1), origin: SIMD2(arrayLiteral: 4, 4), sampleCount: SIMD2(arrayLiteral: 300, 300), seamless: true)
        
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
            if map.count == row {
                map.append([])
            }
            for column in 0 ..< Int(width) {
                let offset = row * width + column
//                pixelBuffer[offset] = getColorForXY(x: column, y: row)
                let pointCordinated: SIMD2<Int32> = SIMD2(arrayLiteral: Int32(column), Int32(row))
                pixelBuffer[offset] = getColorForFloat(number: noiseMap.value(at: pointCordinated))
//                map[row].append(noiseMap.value(at: pointCordinated))
//                print("\(map[row])")
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

extension MainViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        self.mainImageView
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

