//
//  ParameterController.swift
//  Core Graphics 1
//
//  Created by Jackson Tubbs on 2/28/20.
//  Copyright © 2020 Jackson Tubbs. All rights reserved.
//

import Foundation

class ParameterController {
    
    static let shared = ParameterController()
    
    private var parameters: [Parameter] = []
    
    init() {
        
    }
    
    // MARK: Public Functions
    
    // Get Parameter Count
    func getParameterCount() -> Int {
        return parameters.count
    }
    
    // Get Water Level
    func getWaterLevel() -> Float {
        return parameters[0].slider1Value ?? 0
    }
    
    // Get Beach Level
    func getBeachLevel() -> Float {
        return parameters[1].slider1Value ?? 0
    }
    
    // Get Grass Level
    func getGrassLevel() -> Float {
        return parameters[2].slider1Value ?? 0
    }
    
    // Get Map Size
    func getMapSize() -> Int32 {
        return Int32(parameters[3].slider1Value ?? 100)
    }
    
    // Get Terrain Volatility
    func getTerrainVolatility() -> Double {
        return Double(parameters[4].slider1Value ?? 1)
    }
    
    // Reset Parameters
    func resetParameters() {
        parameters = []
        parameters.append(Parameter(labelText: "Water Level",        oneSlider: true, slider1Value: -0.33, slider1Min: -1, slider1Max: 1, slider1IsFloat: true))
        parameters.append(Parameter(labelText: "Beach Level",        oneSlider: true, slider1Value: -0.15, slider1Min: -1, slider1Max: 1, slider1IsFloat: true))
        parameters.append(Parameter(labelText: "Grass Level",        oneSlider: true, slider1Value: 1,     slider1Min: -1, slider1Max: 1, slider1IsFloat: true))
        parameters.append(Parameter(labelText: "Map Size",           oneSlider: true, slider1Value: 130,   slider1Min: 10, slider1Max: 250, slider1IsFloat: false))
        parameters.append(Parameter(labelText: "Terrain Volatility", oneSlider: true, slider1Value: 8,     slider1Min: 1, slider1Max: 40, slider1IsFloat: true))
        saveParameters()
    }
    
    // Get Parameter For Int
    func getParameterForIndex(index: Int) -> Parameter? {
        if parameters.count > index {
            return parameters[index]
        }
        return nil
    }
    
    // MARK: Persistence
    
    func saveParameters() {
        let jsonEncoder = JSONEncoder()
        
        do {
            let data = try jsonEncoder.encode(parameters)
            try data.write(to: fileUrl())
        } catch let e {
            print(e)
        }
    }
    
    func loadParameters() {
        do {
            let data = try Data(contentsOf: fileUrl())
            let jsonDecoder = JSONDecoder()
            let parameters = try jsonDecoder.decode([Parameter].self, from: data)
            self.parameters = parameters
        } catch {
            print("Unable to load parameters, creating new parameters")
            resetParameters()
        }
    }
    
    func fileUrl() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let fileName = "parameters.json"
        let fullURL = documentDirectory.appendingPathComponent(fileName)
        return fullURL
    }
}
