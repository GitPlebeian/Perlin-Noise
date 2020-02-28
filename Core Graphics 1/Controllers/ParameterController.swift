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
    
    // Reset Parameters
    func resetParameters() {
        parameters = []
        parameters.append(Parameter(labelText: "Water Level", slider: true, sliderValue: 0, sliderMin: -1, sliderMax: 1))
        parameters.append(Parameter(labelText: "Beach Level", slider: true, sliderValue: 0, sliderMin: -1, sliderMax: 1))
        parameters.append(Parameter(labelText: "Grass Level", slider: true, sliderValue: 0, sliderMin: -1, sliderMax: 1))
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
    
    private func saveParameters() {
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
