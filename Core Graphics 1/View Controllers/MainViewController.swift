//
//  ViewController.swift
//  Core Graphics 1
//
//  Created by Jackson Tubbs on 2/11/20.
//  Copyright © 2020 Jackson Tubbs. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: Generation Variables
    
    let columns: Int = 600
    let rows: Int = 600
    
    // MARK: Properties
    
    var canvasWidth: CGFloat = 0
    var canvasHeight: CGFloat = 0
    var cellSize: CGFloat = 0
    var lastScale: CGFloat = 1
    
    // MARK: Views
    
    weak var canvasView: UIView!
    
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
        print(lastScale * pinch.scale)
        canvasView.transform = CGAffineTransform(scaleX: lastScale * pinch.scale, y: lastScale * pinch.scale)
//        lastScale = pinch.scale
//        print("State: \(pinch.state.rawValue)")
        if (pinch.state == .ended) {
            lastScale = pinch.scale
        }
    }
    
    // MARK: Helpers
    
    private func setProperties() {
        let viewWidth: CGFloat = self.view.bounds.width
        cellSize = floor(viewWidth / CGFloat(columns))
        if cellSize < 1 {
            cellSize = 1
        }
        canvasWidth = cellSize * CGFloat(columns)
        canvasHeight = cellSize * CGFloat(rows)
    }
    
    // MARK: Setup Views
    
    private func setupViews() {
        setProperties()
        
        self.view.backgroundColor = .white
        
        // Canvas View
//        let canvasView = CanvasView()
//        canvasView.setCellSize(cellSize: cellSize)
//        canvasView.setColsAndRows(cols: columns, rows: rows)
//        let canvasPinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(canvasPinchGesturePinched))
//        canvasView.addGestureRecognizer(canvasPinchGesture)
//        canvasView.backgroundColor = .black
//        canvasView.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(canvasView)
//        NSLayoutConstraint.activate([
//            canvasView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            canvasView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
//            canvasView.heightAnchor.constraint(equalToConstant: canvasHeight),
//            canvasView.widthAnchor.constraint(equalToConstant: canvasWidth)
//        ])
//        self.canvasView = canvasView
        guard let image = processPixels(in: UIImage(named: "Bookmark")!) else {return}
        print("Image: \(image)")
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .red
        self.view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    
    
    func processPixels(in image: UIImage) -> UIImage? {
        guard let inputCGImage = image.cgImage else {
            print("unable to get cgImage")
            return nil
        }
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = inputCGImage.width
        let height           = inputCGImage.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = RGBA32.bitmapInfo

        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            print("unable to create context")
            return nil
        }
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        guard let buffer = context.data else {
            print("unable to get context data")
            return nil
        }

        let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)

        for row in 0 ..< Int(height) {
            for column in 0 ..< Int(width) {
                let offset = row * width + column
                if Int.random(in: 0...6) == 0 {
                    pixelBuffer[offset] = .green
                }
            }
        }

        let outputCGImage = context.makeImage()!
        let outputImage = UIImage(cgImage: outputCGImage, scale: image.scale, orientation: image.imageOrientation)

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

extension MainViewController: UIGestureRecognizerDelegate {
    
}