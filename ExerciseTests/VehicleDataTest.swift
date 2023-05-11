//
//  VehicleDataTest.swift
//  ExerciseTests
//

import Foundation

import XCTest
@testable import Exercise

final class VehicleDataTest: XCTestCase {
    
    var vehicles = DataSet.shared.vehicleData()

    func testSearchVehiclesInputText() {
        // act
        let searchVehicles = DataSet.shared.searchMakeOrModel(text: "Acura", vehicles: vehicles)
        
        // assert
        XCTAssertEqual(searchVehicles.count, 24)
        XCTAssertEqual(searchVehicles.first?.make, "Acura")
        XCTAssertEqual(searchVehicles.first?.model, "ILX")
        XCTAssertEqual(searchVehicles.first?.year, 2017)
        XCTAssertEqual(searchVehicles.first?.vehicleCount, 29)
        XCTAssertEqual(searchVehicles.first?.price, 39616)
    }
    
    func testSearchVehiclesInputTextWithSpaceCharacter() {
        // act
        let searchVehicles = DataSet.shared.searchMakeOrModel(text: "              Acura ", vehicles: vehicles)
        
        // assert
        XCTAssertEqual(searchVehicles.count, 24)
        XCTAssertEqual(searchVehicles.first?.make, "Acura")
        XCTAssertEqual(searchVehicles.first?.model, "ILX")
        XCTAssertEqual(searchVehicles.first?.year, 2017)
        XCTAssertEqual(searchVehicles.first?.vehicleCount, 29)
        XCTAssertEqual(searchVehicles.first?.price, 39616)
    }
    
    func testSearchVehiclesAllOptional() {
        // act
        let vehicles = DataSet.shared.searchVehicle(make: nil, model: nil, year: nil, maxPrice: nil)
        let searchResult = DataSet.shared.getSearchResultTotal(vehicles: vehicles)
        // assert
        XCTAssertEqual(searchResult.vehicleCount, 1563)
        XCTAssertEqual(searchResult.minPrice, 76)
        XCTAssertEqual(searchResult.maxPrice, 508685)
        XCTAssertEqual(searchResult.medianPrice, 254380.0)
    }
    
    func testSearchVehiclesMutipleCondition() {
        // act
        let vehicles = DataSet.shared.searchVehicle(make: "Audi", model: "S5 Sportback", year: 2021, maxPrice: 10000)
        let searchResult = DataSet.shared.getSearchResultTotal(vehicles: vehicles)

        // assert
        XCTAssertEqual(searchResult.vehicleCount, 0)
        XCTAssertEqual(searchResult.minPrice, 0)
        XCTAssertEqual(searchResult.maxPrice, 0)
        XCTAssertEqual(searchResult.medianPrice, 0)
        
        // act
        let vehicles2 = DataSet.shared.searchVehicle(make: "Audi", model: "S5 Sportback", year: nil, maxPrice: nil)
        let searchResult2 = DataSet.shared.getSearchResultTotal(vehicles: vehicles2)

        // assert
        XCTAssertEqual(searchResult2.vehicleCount, 3)
        XCTAssertEqual(searchResult2.minPrice, 71041)
        XCTAssertEqual(searchResult2.maxPrice, 117242)
        XCTAssertEqual(searchResult2.medianPrice, 94141.0)

        // act
        let vehicles3 = DataSet.shared.searchVehicle(make: "Audi", model: "S5 Sportback", year: 2021, maxPrice: 1000000)
        let searchResult3 = DataSet.shared.getSearchResultTotal(vehicles: vehicles3)

        // assert
        XCTAssertEqual(searchResult3.vehicleCount, 1)
        XCTAssertEqual(searchResult3.minPrice, 117242)
        XCTAssertEqual(searchResult3.maxPrice, 117242)
        XCTAssertEqual(searchResult3.medianPrice, 117242.0)
    }

}
