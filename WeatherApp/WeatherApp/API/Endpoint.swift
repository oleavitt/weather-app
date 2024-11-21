//
//  Endpoint.swift
//  WeatherApp
//
//  Created by Oren Leavitt on 11/20/24.
//

import Foundation

protocol Endpoint {
    var url: URL? { get }
    var request: URLRequest? { get }
}

// Generic endpoint source where we can switch API providers between
// production, QA, or other API vandors
struct Endpoints {
    static func currentWeather(locationQuery: String) -> Endpoint {
        WeatherApiEndpoint.current(query: locationQuery)
    }
}
