//
//  NetworkLayerLive.swift
//  WeatherApp
//
//  Created by Oren Leavitt on 11/20/24.
//

import Foundation

class NetworkLayerLive: NetworkLayer {
    
    func fetchJsonData<T: Decodable>(request: URLRequest, type: T.Type) async throws -> T {
        let response = try await URLSession.shared.data(for: request)
        let data = response.0
        
#if DEBUG
        if let responseObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
            if let jsonData = try? JSONSerialization.data(withJSONObject: responseObject, options: .prettyPrinted),
               let strData = String(data: jsonData, encoding: .utf8) {
                print("RESPONSE (JSON): \(strData)")
            } else {
                print("RESPONSE (OBJECT): ", responseObject)
            }
        } else  if let strData = String(data: data, encoding: .utf8) {
            print("RESPONSE (OTHER): \(strData)")
        } else {
            print("RESPONSE: None")
        }
#endif
        
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
