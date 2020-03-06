//
//  GenerationController.swift
//  Core Graphics 1
//
//  Created by Jackson Tubbs on 3/2/20.
//  Copyright © 2020 Jackson Tubbs. All rights reserved.
//

import Foundation
import UIKit
import GameKit

class GenerationController {
    
    // Shared
    static let shared = GenerationController()
    
    // MARK: Properties
    
    let height: Int = 200
    let width: Int =  200
    
    private var currentImage: UIImage?
    
    // Noise
    var noiseMap: GKNoiseMap!
    
    // MARK: Private Functions
    
    func getColorForFloat(number: Float) -> RGBA32 {
        if number <= ParameterController.shared.getWaterLevel() {
            return .water
        } else if number <= ParameterController.shared.getBeachLevel() {
            return .sand
        } else if number <= ParameterController.shared.getGrassLevel() {
            return .grass
        } else {
            return .black
        }
    }
    
    // MARK: Public Functions
    func generateImage(completion: @escaping (UIImage?) -> Void) {
        
        let noiseSource = GKPerlinNoiseSource()
        noiseSource.seed = Int32.random(in: 0...Int32.max)
        //        noiseSource.seed = 1
        //        noiseSource.frequency = 3
        //        noiseSource.octaveCount = 1
        //        noiseSource.lacunarity = 4
        let noise = GKNoise(noiseSource)
        //        noise.applyTurbulence(frequency: 1000, power: 10000, roughness: 2, seed: 8)
        noiseMap = GKNoiseMap(noise)
        //        print("\nSize: \(noiseMap.size)")
        //        print("Origin: \(noiseMap.origin)")
        //        print("Sample Count: \(noiseMap.sampleCount)")
        noiseMap = GKNoiseMap(noise, size: SIMD2(arrayLiteral: 1, 1), origin: SIMD2(arrayLiteral: ParameterController.shared.getTerrainVolatility(), ParameterController.shared.getTerrainVolatility()), sampleCount: SIMD2(arrayLiteral: ParameterController.shared.getMapSize(), ParameterController.shared.getMapSize()), seamless: true)
        
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = Int(ParameterController.shared.getMapSize())
        let height           = Int(ParameterController.shared.getMapSize())
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
        
        self.currentImage = outputImage
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
        
        static let water   = RGBA32(red: 0,   green: 148, blue: 255, alpha: 255)
        static let sand    = RGBA32(red: 255, green: 238, blue: 90,  alpha: 255)
        static let grass   = RGBA32(red: 40,  green: 255, blue: 60,  alpha: 255)
        static let black   = RGBA32(red: 0,   green: 0,   blue: 0,   alpha: 255)
        
        static let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        
        static func ==(lhs: RGBA32, rhs: RGBA32) -> Bool {
            return lhs.color == rhs.color
        }
    }
}
