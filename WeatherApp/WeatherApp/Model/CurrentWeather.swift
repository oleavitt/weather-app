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
    var forecast: Forecast?
    var error: ApiError?
}

struct Current: Decodable {
    var lastUpdated: String?
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

// MARK: - Forecast
struct Forecast: Decodable {
    let forecastday: [Forecastday]
}

// MARK: - Forecastday
struct Forecastday: Decodable, Hashable {
    static func == (lhs: Forecastday, rhs: Forecastday) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        
    }
    
    let astro: Astro
    let hour: [Current]
    let day: Day
    let dateEpoch: Int
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case astro, hour, day
        case dateEpoch = "date_epoch"
        case date
    }
}

// MARK: - Astro
struct Astro: Codable {
    let sunset: String
    let isSunUp: Int
    let moonrise: String
    let moonIllumination: Int
    let sunrise, moonPhase, moonset: String
    let isMoonUp: Int
    
    enum CodingKeys: String, CodingKey {
        case sunset
        case isSunUp = "is_sun_up"
        case moonrise
        case moonIllumination = "moon_illumination"
        case sunrise
        case moonPhase = "moon_phase"
        case moonset
        case isMoonUp = "is_moon_up"
    }
}

// MARK: - Day
struct Day: Decodable {
    let avgvisKM: Int
    let mintempC, avgtempC: Double
    let totalprecipIn, totalsnowCM, dailyWillItRain: Int
    let maxtempF: Double
    let dailyWillItSnow, dailyChanceOfRain, avghumidity, totalprecipMm: Int
    let condition: Condition
    let maxwindKph, maxwindMph: Double
    let avgvisMiles: Int
    let uv: Double
    let dailyChanceOfSnow: Int
    let mintempF, avgtempF, maxtempC: Double
    
    enum CodingKeys: String, CodingKey {
        case avgvisKM = "avgvis_km"
        case mintempC = "mintemp_c"
        case avgtempC = "avgtemp_c"
        case totalprecipIn = "totalprecip_in"
        case totalsnowCM = "totalsnow_cm"
        case dailyWillItRain = "daily_will_it_rain"
        case maxtempF = "maxtemp_f"
        case dailyWillItSnow = "daily_will_it_snow"
        case dailyChanceOfRain = "daily_chance_of_rain"
        case avghumidity
        case totalprecipMm = "totalprecip_mm"
        case condition
        case maxwindKph = "maxwind_kph"
        case maxwindMph = "maxwind_mph"
        case avgvisMiles = "avgvis_miles"
        case uv
        case dailyChanceOfSnow = "daily_chance_of_snow"
        case mintempF = "mintemp_f"
        case avgtempF = "avgtemp_f"
        case maxtempC = "maxtemp_c"
    }
}

// MARK: - Location
struct Location: Codable {
    let region, country, localtime: String
    let lon, lat: Double
    let tzID, name: String
    let localtimeEpoch: Int
    
    enum CodingKeys: String, CodingKey {
        case region, country, localtime, lon, lat
        case tzID = "tz_id"
        case name
        case localtimeEpoch = "localtime_epoch"
    }
}

struct ApiError: Decodable {
    var code: Int
    var message: String
}
