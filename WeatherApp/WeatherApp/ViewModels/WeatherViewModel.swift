//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Oren Leavitt on 11/20/24.
//

import Foundation
import SwiftUI

class WeatherViewModel: ObservableObject {    
    @Published var state: LoadingState<CurrentWeather> = .empty
}
