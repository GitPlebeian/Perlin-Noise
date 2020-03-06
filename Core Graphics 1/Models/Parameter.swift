//
//  Parameter.swift
//  Core Graphics 1
//
//  Created by Jackson Tubbs on 2/28/20.
//  Copyright © 2020 Jackson Tubbs. All rights reserved.
//

import Foundation

class Parameter: Codable {
    
    let labelText:       String
    let oneSlider:       Bool
    var slider1Value:    Float?
    let slider1Min:      Float?
    let slider1Max:      Float?
    let slider1IsFloat:  Bool?
    
    init(labelText:      String,
         oneSlider:      Bool,
         slider1Value:   Float?,
         slider1Min:     Float?,
         slider1Max:     Float?,
         slider1IsFloat: Bool?) {
        
        self.labelText      = labelText
        self.oneSlider      = oneSlider
        self.slider1Value   = slider1Value
        self.slider1Max     = slider1Max
        self.slider1Min     = slider1Min
        self.slider1IsFloat = slider1IsFloat
    }
}
