//
//  Mapper.swift
//  PressuerDemo
//
//  Created by ThienTX on 3/16/17.
//  Copyright © 2017 ThienTX. All rights reserved.
//

import Foundation

class Mapper: NSObject {

    class func map(fromAltimeterEntity entity: AltimeterEntity, to altimeter: Altimeter) {
        altimeter.pressure = entity.pressure
        altimeter.alimeterFt = entity.altimeterft
        altimeter.alimeterM = entity.altimeterm
        altimeter.pressureSeaLevel = entity.pressuerSeaLevel
    }
    
    class func altimeter(from entity: AltimeterEntity) -> Altimeter {
        let altimeter = Altimeter()
        map(fromAltimeterEntity: entity, to: altimeter)
        return altimeter
    }
    
    class func map(fromAltimeter altimeter: Altimeter, to entity: AltimeterEntity) {
        entity.pressure = altimeter.pressure
        entity.altimeterft = altimeter.alimeterFt
        entity.altimeterm = altimeter.alimeterM
        entity.pressuerSeaLevel = altimeter.pressureSeaLevel
    }
}
