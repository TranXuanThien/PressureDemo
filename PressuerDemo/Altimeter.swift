//
//  Altimeter.swift
//  PressuerDemo
//
//  Created by ThienTX on 3/16/17.
//  Copyright © 2017 ThienTX. All rights reserved.
//

import Foundation

class Altimeter: NSObject {
    var pressure: Double!
    var alimeterFt: Double!
    var alimeterM: Double!
    var pressureSeaLevel: Double!
    
    override init() {
        pressure = 0
        alimeterFt = 0
        alimeterM = 0
        pressureSeaLevel = 29.92
    }
    
    init(pressure: Double, alimeterFt: Double, alimeterM: Double, pressureSeaLevel: Double) {
        self.pressure = pressure
        self.alimeterFt = alimeterFt
        self.alimeterM = alimeterM
        self.pressureSeaLevel = pressureSeaLevel
    }
}
