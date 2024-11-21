//
//  NetworkLayerMock.swift
//  WeatherApp
//
//  Created by Oren Leavitt on 11/20/24.
//

import Foundation

#if DEBUG
class NetworkLayerMock: NetworkLayer {
    
    func fetchJsonData<T: Decodable>(request: URLRequest, type: T.Type) async throws -> T {
        let query = request.url?.query() ?? ""
        let jsonString: String
        if query.contains("q=Dallas") {
            jsonString = currentJson
        } else {
            jsonString = currentErrorNoMatchJson
        }
        
        let data: Data
        switch type {
        case is CurrentWeather.Type:
            data = jsonString.data(using: .utf8) ?? Data()
            break
        default:
            data = Data()
            break
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}

private let currentJson = """
{
    "location": {
        "name": "Dallas",
        "region": "Texas",
        "country": "United States of America",
        "lat": 32.7833,
        "lon": -96.8,
        "tz_id": "America/Chicago",
        "localtime_epoch": 1732138549,
        "localtime": "2024-11-20 15:35"
    },
    "current": {
        "last_updated_epoch": 1732138200,
        "last_updated": "2024-11-20 15:30",
        "temp_c": 17.8,
        "temp_f": 64.0,
        "is_day": 1,
        "condition": {
            "text": "Sunny",
            "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png",
            "code": 1000
        },
        "wind_mph": 11.6,
        "wind_kph": 18.7,
        "wind_degree": 345,
        "wind_dir": "NNW",
        "pressure_mb": 1026.0,
        "pressure_in": 30.31,
        "precip_mm": 0.0,
        "precip_in": 0.0,
        "humidity": 18,
        "cloud": 0,
        "feelslike_c": 16.8000000001,
        "feelslike_f": 62.8999999999,
        "windchill_c": 18.3,
        "windchill_f": 65.0,
        "heatindex_c": 18.4,
        "heatindex_f": 65.1,
        "dewpoint_c": -7.9,
        "dewpoint_f": 17.8,
        "vis_km": 16.0,
        "vis_miles": 9.0,
        "uv": 1.8,
        "gust_mph": 13.4,
        "gust_kph": 21.5
    }
}
"""

private let currentErrorNoMatchJson = """
{
    "error": {
        "code": 1006,
        "message": "No matching location found."
    }
}
"""
#endif
