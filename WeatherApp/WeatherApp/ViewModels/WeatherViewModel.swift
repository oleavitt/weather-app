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
    var showFahrenheit = true
    
    @Published var state: LoadingState = .empty
    
    private var currentWeather: CurrentWeather?
    private var apiError: Error?
    
    init(networkLayer: NetworkLayer) {
        self.networkLayer = networkLayer
    }
    
    @MainActor
    func getCurrentWeather() async {
        if case .loading = state { return }

        guard let request = WeatherApiEndpoint.current(query: locationQuery).request else {
            return
        }
        
        state = .loading
        do {
            let current = try await networkLayer.fetchJsonData(request: request, type: CurrentWeather.self)
            currentWeather = current

            if let errorResponse = current.error {
                apiError = ApiErrorType.fromErrorCode(code: errorResponse.code)
                state = .failure
            } else {
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
            return String(localized: "\((showFahrenheit ? current.tempF : current.tempC).formatted())°")
        }
        return "--°"
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
}
