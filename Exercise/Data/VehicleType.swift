//
//  VehicleType.swift
//  Exercise
//

import Foundation

struct VehicleType: Hashable {
    let name: String
    let image: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static func == (lhs: VehicleType, rhs: VehicleType) -> Bool {
        return lhs.name == rhs.name
    }
}

extension VehicleType {
    static func allTypes() -> [VehicleType] {
        let types = [VehicleType(name: "Compact", image: "img_compact"),
                     VehicleType(name: "Minivan", image: "img_minivan"),
                     VehicleType(name: "Convertible", image: "img_convertible"),
                     VehicleType(name: "Sedan", image: "img_sedan"),
                     VehicleType(name: "Coupe", image: "img_coupe"),
                     VehicleType(name: "Small SUV", image: "img_small_suv"),
                     VehicleType(name: "Hatchback", image: "img_hatchback"),
                     VehicleType(name: "Sports", image: "img_sports"),
                     VehicleType(name: "Hybrid/Electric", image: "img_hybrid"),
                     VehicleType(name: "SUV", image: "img_suv"),
                     VehicleType(name: "Midsize", image: "img_midsize"),
                     VehicleType(name: "Truck", image: "img_truck")]
        return types
    }

}
