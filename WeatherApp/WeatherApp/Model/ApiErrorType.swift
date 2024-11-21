//
//  ApiErrorType.swift
//  WeatherApp
//
//  Created by Oren Leavitt on 11/20/24.
//

import Foundation

enum ApiErrorType: Error {
    case noMatch
    case emptySearch
    case networkError
    case genericError
    
    static func fromErrorCode(code: Int) -> ApiErrorType {
        switch code {
        case 1003: return .emptySearch
        case 1006: return .noMatch
        default: return .genericError
        }
    }
}

extension ApiErrorType: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noMatch:
            return String(localized: "error-no-match")
        case .emptySearch:
            return String(localized: "error-empty-search")
        case .networkError:
            return String(localized: "error-network")
        case .genericError:
            return String(localized: "error-unknown")
        }
    }
}
