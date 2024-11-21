//
//  NetworkLayer.swift
//  WeatherApp
//
//  Created by Oren Leavitt on 11/20/24.
//

import Foundation

protocol NetworkLayer {
    func fetchJsonData<T: Decodable>(request: URLRequest, type: T.Type) async throws -> T
}
