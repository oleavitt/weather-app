//
//  WeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by Oren Leavitt on 11/20/24.
//

import XCTest
@testable import WeatherApp

final class WeatherViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitialState() throws {
        let viewModel = WeatherViewModel()
        
        if case .empty = viewModel.state {
            
        } else {
            XCTFail("View model is not in empty state")
        }
    }
}
