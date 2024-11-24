//
//  Theme.swift
//  WeatherApp
//
//  Created by Oren Leavitt on 11/23/24.
//

import Foundation
import SwiftUI

var currentTheme = WeatherAppTheme.default

struct WeatherAppTheme {
    static let `default` = WeatherAppTheme(
        fontFamily: "Poppins",
        backgroundColor: Color(white: 0.95)
    )
    
    let fontFamily: String
    let backgroundColor: Color
}
