//
//  DataSet.swift
//  Exercise
//

import Foundation

final class DataSet: NSObject {
    static let shared = DataSet()
    
    func loadDataFromJson(name: String, extension: String) -> Data {
        let bundle = Bundle(for: classForCoder)
        let url = bundle.url(forResource: name, withExtension: `extension`)
        
        return try! Data(contentsOf: url!)
    }
    
    func vehicleData() -> [Vehicle] {
        let json = loadDataFromJson(name: "dataSet", extension: "json")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let shop = try decoder.decode([Vehicle].self, from: json)
            return shop
        } catch {
            fatalError("Can not decoder with error: \(error)")
        }
    }
    
    func getMakeTypes() -> [String] {
        Set(vehicleData().compactMap { $0.make }).sorted { $0 < $1 }
    }
    
    func getModels(with make: String?) -> [String] {
        Set(vehicleData().filter {
            if let make = make {
                return $0.make == make
            }
            return true
        }.compactMap { $0.model }).sorted { $0 < $1 }
    }
    
    func getYear(with model: String?) -> [Int] {
        Set(vehicleData().filter {
            if let model = model {
                return $0.model == model
            }
            return true
        }.compactMap { $0.year }).sorted { $0 < $1 }
    }

    func searchVehicle(make: String?, model: String?, year: Int?, maxPrice: Int64?) -> [Vehicle] {
        var vehicles = vehicleData()
        
        if let make = make {
            vehicles = vehicles.filter { $0.make == make || $0.make.contains(make) }
        }
        
        if let model = model {
            vehicles = vehicles.filter { $0.model == model || $0.make.contains(model) }
        }
        
        if let year = year {
            vehicles = vehicles.filter { $0.year == year }
        }

        if let maxPrice = maxPrice {
            vehicles = vehicles.filter { $0.price <= maxPrice }
        }
        
        return vehicles
    }
    
    func getSearchResultTotal(vehicles: [Vehicle]) -> SearchResult {
        let min = vehicles.compactMap { $0.price }.min() ?? 0
        let max = vehicles.compactMap { $0.price }.max() ?? 0
        let median = Double((min + max) / 2)

        return SearchResult(minPrice: min, maxPrice: max, medianPrice: median, vehicleCount: vehicles.count)
    }
        
    func searchMakeOrModel(text: String, vehicles: [Vehicle]) -> [Vehicle] {
        vehicles.filter {
            $0.make.lowercased().contains(text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased())
            || $0.model.lowercased().contains(text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased())
        }
    }
}
