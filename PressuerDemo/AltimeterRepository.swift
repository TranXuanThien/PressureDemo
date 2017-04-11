//
//  AltimeterRepository.swift
//  PressuerDemo
//
//  Created by ThienTX on 3/16/17.
//  Copyright © 2017 ThienTX. All rights reserved.
//

import Foundation
import MagicalRecord

class AltimeterRepository {
    
    // MARK: - Read
    
    func all() -> [Altimeter] {
        var altimeters = [Altimeter]()
        
        if let entities = AltimeterEntity.mr_findAll() as? [AltimeterEntity] {
            for entity in entities {
                altimeters.append(Mapper.altimeter(from: entity))
            }
        }
        
        return altimeters
    }
    
    func add(altimeter: Altimeter) {
        MagicalRecord.save({ (context) -> Void in
            if let entity = AltimeterEntity.mr_createEntity(in: context) {
                Mapper.map(fromAltimeter: altimeter, to: entity)
            }
        })
    }
}
