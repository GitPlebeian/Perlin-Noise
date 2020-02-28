//
//  Parameter.swift
//  Core Graphics 1
//
//  Created by Jackson Tubbs on 2/28/20.
//  Copyright © 2020 Jackson Tubbs. All rights reserved.
//

import Foundation

struct Parameter: Codable {
    
    let labelText: String
    let slider: Bool
    var sliderValue: Float?
    let sliderMin: Float?
    let sliderMax: Float?
}
