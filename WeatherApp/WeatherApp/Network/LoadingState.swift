//
//  LoadingState.swift
//  WeatherApp
//
//  Created by Oren Leavitt on 11/20/24.
//

import Foundation

public enum LoadingState<T> {
    case empty
    case loading
    case success(T)
    case failure(Error)
}
