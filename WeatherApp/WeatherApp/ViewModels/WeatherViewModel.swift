//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Oren Leavitt on 11/20/24.
//

import Foundation
import SwiftUI

class WeatherViewModel: ObservableObject {
    
    var networkLayer: NetworkLayer
    var locationQuery: String = ""
    
    @Published var showFahrenheit = true
    @Published var state: LoadingState = .empty
    @Published var showDetails = false
    
    @AppStorage("lastLocationQuery") var lastLocationQuery: String?
    
    private var currentWeather: CurrentWeather?
    private var apiError: Error?
    
    init(networkLayer: NetworkLayer) {
        self.networkLayer = networkLayer
    }
    
    func getLastLocationQuery() -> Bool {
        locationQuery = lastLocationQuery ?? ""
        return lastLocationQuery != nil && !locationQuery.isEmpty
    }
    
    @MainActor
    func getCurrentWeather() async {
        if case .loading = state { return }
        
        guard let request = WeatherApiEndpoint.forecast(query: locationQuery).request else {
            return
        }
        
        showDetails = false
        state = .loading
        do {
            let current = try await networkLayer.fetchJsonData(request: request, type: CurrentWeather.self)
            currentWeather = current
            
            if let errorResponse = current.error {
                apiError = ApiErrorType.fromErrorCode(code: errorResponse.code)
                state = .failure
            } else {
                lastLocationQuery = locationQuery
                state = .success
            }
        } catch {
            apiError = ApiErrorType.networkError
            state = .failure
#if DEBUG
            print(error)
#endif
        }
    }
}

extension WeatherViewModel {
    var conditionsIconUrl: URL? {
        guard let path = currentWeather?.current?.condition.icon,
              var components = URLComponents(string: path) else {
            return nil
        }
        components.scheme = "https"
        return components.url
    }
    
    var locationName: String {
        currentWeather?.location?.name ?? "--"
    }
    
    var temperature: String {
        if let current = currentWeather?.current {
            return String(localized: "\((showFahrenheit ? current.tempF : current.tempC).formatted())")
        }
        return "--"
    }
    
    var feelsLike: String {
        if let current = currentWeather?.current {
            return String(localized: "\((showFahrenheit ? current.feelslikeF : current.feelslikeC).formatted())°")
        }
        return "--°"
    }
    
    var humidity: String {
        if let current = currentWeather?.current {
            return String(localized: "\(current.humidity)%")
        }
        return "--%"
    }
    
    var uvIndex: String {
        if let current = currentWeather?.current {
            return String(localized: "\(current.uv.formatted())")
        }
        return "--"
    }
    
    var errorMessage: String {
        apiError?.localizedDescription ?? ""
    }
    
    var forecastDays: [DisplayForcastDay] {
        currentWeather?.forecast?.forecastday.map {
            showFahrenheit ?
            DisplayForcastDay(hi: $0.day.maxtempF, lo: $0.day.mintempF) :
            DisplayForcastDay(hi: $0.day.maxtempC, lo: $0.day.mintempC)
        } ?? []
    }
}

struct DisplayForcastDay: Identifiable, Hashable {
    var id = UUID()
    let hi: Double
    let lo: Double
}
