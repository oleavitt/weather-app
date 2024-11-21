//
//  WeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by Oren Leavitt on 11/20/24.
//

import XCTest
@testable import WeatherApp

final class WeatherViewModelTests: XCTestCase {

    var viewModel: WeatherViewModel = WeatherViewModel(networkLayer: NetworkLayerMock())
    
    override func setUpWithError() throws {
        viewModel = WeatherViewModel(networkLayer: NetworkLayerMock())
    }

    func testInitialState() {
        XCTAssertEqual(viewModel.state, .empty)
    }
    
    func testLocationQuery() async {
        viewModel.locationQuery = "Dallas"
        
        await viewModel.getCurrentWeather()
        
        XCTAssertEqual(viewModel.locationName, "Dallas")
        XCTAssertEqual(viewModel.temperature, "64°")
        XCTAssertEqual(viewModel.feelsLike, "62.9°")
        XCTAssertEqual(viewModel.humidity, "18%")
        XCTAssertEqual(viewModel.uvIndex, "1.8")
        XCTAssert(viewModel.errorMessage.isEmpty)
        
        XCTAssertNotNil(viewModel.conditionsIconUrl)
    }
    
    func testLocationQueryCelsius() async {
        viewModel.locationQuery = "Dallas"
        viewModel.showFahrenheit = false
        
        await viewModel.getCurrentWeather()
        
        XCTAssertEqual(viewModel.locationName, "Dallas")
        XCTAssertEqual(viewModel.temperature, "17.8°")
        XCTAssertEqual(viewModel.feelsLike, "16.8°")
        XCTAssertEqual(viewModel.humidity, "18%")
        XCTAssertEqual(viewModel.uvIndex, "1.8")
        XCTAssert(viewModel.errorMessage.isEmpty)
        
        XCTAssertNotNil(viewModel.conditionsIconUrl)
    }

    func testInvalidLocationQuery() async {
        viewModel.locationQuery = "xxxxx"
        
        await viewModel.getCurrentWeather()
        
        XCTAssertEqual(viewModel.locationName, "--")
        XCTAssertEqual(viewModel.temperature, "--°")
        XCTAssertEqual(viewModel.feelsLike, "--°")
        XCTAssertEqual(viewModel.humidity, "--%")
        XCTAssertEqual(viewModel.uvIndex, "--")
        XCTAssertEqual(viewModel.errorMessage, "Location not found. Please try another search.")
        
        XCTAssertNil(viewModel.conditionsIconUrl)
    }
}
