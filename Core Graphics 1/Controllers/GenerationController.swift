//
//  GenerationController.swift
//  Core Graphics 1
//
//  Created by Jackson Tubbs on 3/2/20.
//  Copyright © 2020 Jackson Tubbs. All rights reserved.
//

import UIKit
import GameKit
import Photos

class GenerationController {
    
    // Shared
    static let shared = GenerationController()
    
    // MARK: Properties
    
    let generatedImageWidth: Int = 2000
    
    private var currentImage: UIImage?
    
    // Noise
    var noiseMap: GKNoiseMap!
    
    // MARK: Private Functionsd
    
    // Get Color For Float
    func getColorForFloat(number: Float) -> RGBA32 {
        if number <= ParameterController.shared.getDeepWaterLevel() {
            return .deepWater
        } else if number <= ParameterController.shared.getWaterLevel() {
            return .water
        } else if number <= ParameterController.shared.getBeachLevel() {
            return .sand
        } else if number <= ParameterController.shared.getGrassLevel() {
            return .grass
        } else if number <= ParameterController.shared.getForestLevel() {
            return .forest
        } else if number <= ParameterController.shared.getDirtLevel() {
            return .dirt
        } else if number <= ParameterController.shared.getMountainLevel() {
            return .mountain
        } else if number <= ParameterController.shared.getSnowLevel() {
            return .snow
        } else {
            return .snow
        }
    }
    
    // Generate Noise Map
    private func generateNoiseMap() {
        let noiseSource = GKPerlinNoiseSource()
        noiseSource.seed = Int32.random(in: 0...Int32.max)
        let noise = GKNoise(noiseSource)
        noiseMap = GKNoiseMap(noise, size: SIMD2(arrayLiteral: 1, 1), origin: SIMD2(arrayLiteral: ParameterController.shared.getTerrainVolatility(), ParameterController.shared.getTerrainVolatility()), sampleCount: SIMD2(arrayLiteral: ParameterController.shared.getMapSize(), ParameterController.shared.getMapSize()), seamless: true)
    }
    
    // Generate Image
    private func generateImage(imageScale: Int, completion: @escaping (UIImage?) -> Void) {
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = Int(ParameterController.shared.getMapSize()) * imageScale
        let height           = Int(ParameterController.shared.getMapSize()) * imageScale
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = RGBA32.bitmapInfo
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            print("unable to create context")
            completion(nil)
            return
        }
        
        guard let buffer = context.data else {
            print("Unable To Get Context Data")
            completion(nil)
            return
        }
        
        let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)
        
        for row in 0 ..< Int(height) {
            for column in 0 ..< Int(width) {
                let offset = row * width + column
                let pointCordinated: SIMD2<Int32> = SIMD2(arrayLiteral: Int32(column / imageScale), Int32(row / imageScale))
                pixelBuffer[offset] = getColorForFloat(number: noiseMap.value(at: pointCordinated))
            }
        }
        context.interpolationQuality = .none
        let outputCGImage = context.makeImage()!
        
        let outputImage = UIImage(cgImage: outputCGImage, scale: 1, orientation: UIImage.Orientation.up)
        
        if imageScale == 1 {
            self.currentImage = outputImage
        }
        completion(outputImage)
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
        
        static let deepWater = RGBA32(red: 22,  green: 49,  blue: 218, alpha: 255)
        static let water     = RGBA32(red: 14,  green: 97,  blue: 255, alpha: 255)
        static let sand      = RGBA32(red: 227, green: 237, blue: 124, alpha: 255)
        static let grass     = RGBA32(red: 86,  green: 236, blue: 40,  alpha: 255)
        static let forest    = RGBA32(red: 39,  green: 170, blue: 64,  alpha: 255)
        static let dirt      = RGBA32(red: 147, green: 102, blue: 0,   alpha: 255)
        static let mountain  = RGBA32(red: 91,  green: 72,  blue: 16,  alpha: 255)
        static let snow      = RGBA32(red: 255, green: 255, blue: 255, alpha: 255)
        
        static let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        
        static func ==(lhs: RGBA32, rhs: RGBA32) -> Bool {
            return lhs.color == rhs.color
        }
    }
    
    // MARK: Public Functions
    
    // Generate New Terrain
    func generateNewTerrain(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.generateNoiseMap()
            self.generateImage(imageScale: 1, completion: { (image) in
                completion(image)
            })
        }
    }
    
    // Save Image
    func saveImage(completion: @escaping (Bool) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let originalImageWidth = self.currentImage?.cgImage?.width else {
                completion(false)
                return
            }
            var currentWidth = originalImageWidth
            var multiplier = 1
            while currentWidth < self.generatedImageWidth {
                currentWidth = multiplier * originalImageWidth
                multiplier += 1
            }
            self.generateImage(imageScale: multiplier, completion: { (image) in
                PHPhotoLibrary.shared().performChanges({
                    guard let image = image else {
                        completion(false)
                        return
                    }
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    guard let imageData = image.pngData() else {
                        print("Unable to create image data")
                        completion(false)
                        return
                    }
                    creationRequest.addResource(with: .photo, data: imageData, options: nil)
                }) { (success, error) in
                    if let error = error {
                        print("Error Saving: \(error.localizedDescription)")
                        completion(false)
                        return
                    }
                    completion(true)
                }
            })
        }
    }
}
