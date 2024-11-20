//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Oren Leavitt on 11/20/24.
//

import Foundation

struct CurrentWeather: Decodable {
    var location: Location?
    var current: Current?
    var error: ApiError?
}

struct Location: Decodable {
    var name: String = ""
    var region: String = ""
    var country: String = ""
    var lat: Double = 0.0
    var lon: Double = 0.0
    var localtime: String = ""
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case region = "region"
        case country = "country"
        case lat = "lat"
        case lon = "lon"
        case localtime = "localtime"
    }
}

struct Current: Decodable {
    var lastUpdated: String = ""
    var tempC: Double = 0.0
    var tempF: Double = 0.0
    var isDay: Int = 0
    var condition: Condition
    var windMph: Double = 0.0
    var windKph: Double = 0.0
    var windDegree: Int = 0
    var windDir: String = ""
    var pressureMb: Double = 0.0
    var pressureIn: Double = 0.0
    var precipMm: Double = 0.0
    var precipIn: Double = 0.0
    var humidity: Int = 0
    var cloud: Int = 0
    var feelslikeC: Double = 0.0
    var feelslikeF: Double = 0.0
    var windchillC: Double = 0.0
    var windchillF: Double = 0.0
    var heatindexC: Double = 0.0
    var heatindexF: Double = 0.0
    var dewpointC: Double = 0.0
    var dewpointF: Double = 0.0
    var visKm: Double = 0.0
    var visMiles: Double = 0.0
    var uv: Double = 0.0
    var gustMph: Double = 0.0
    var gustKph: Double = 0.0
    
    enum CodingKeys: String, CodingKey {
        case lastUpdated = "last_updated"
        case tempC = "temp_c"
        case tempF = "temp_f"
        case isDay = "is_day"
        case condition = "condition"
        case windMph = "wind_mph"
        case windKph = "wind_kph"
        case windDegree = "wind_degree"
        case windDir = "wind_dir"
        case pressureMb = "pressure_mb"
        case pressureIn = "pressure_in"
        case precipMm = "precip_mm"
        case precipIn = "precip_in"
        case humidity = "humidity"
        case cloud = "cloud"
        case feelslikeC = "feelslike_c"
        case feelslikeF = "feelslike_f"
        case windchillC = "windchill_c"
        case windchillF = "windchill_f"
        case heatindexC = "heatindex_c"
        case heatindexF = "heatindex_f"
        case dewpointC = "dewpoint_c"
        case dewpointF = "dewpoint_f"
        case visKm = "vis_km"
        case visMiles = "vis_miles"
        case uv = "uv"
        case gustMph = "gust_mph"
        case gustKph = "gust_kph"
    }
}

struct Condition: Decodable {
    var text: String = ""
    var icon: String = ""
    var code: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case text = "text"
        case icon = "icon"
        case code = "code"
    }
}

struct ApiError: Decodable {
    var code: Int
    var message: String
}
