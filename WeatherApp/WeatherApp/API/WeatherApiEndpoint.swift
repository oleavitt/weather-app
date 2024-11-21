//
//  WeatherApiEndpoint.swift
//  WeatherApp
//
//  Created by Oren Leavitt on 11/20/24.
//

import Foundation

var apiKey = "YOUR_API_KEY"
private let apiHost = "api.weatherapi.com"

enum WeatherApiEndpoint: Endpoint {
    case current(query: String)
    
    var url: URL? {
        switch self {
        case .current(let query):
            var components = URLComponents()
            components.scheme = "https"
            components.host = apiHost
            components.path = "/v1/current.json"
            components.queryItems = [
                URLQueryItem(name: "key", value: apiKey),
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "aqi", value: "no")
            ]
            
            return components.url
        }
    }
    
    var request: URLRequest? {
        guard let url else {
            return nil
        }
        return URLRequest(url: url)
    }
}
