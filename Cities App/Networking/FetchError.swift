//
//  FetchError.swift
//  Cities App
//
//  Created by Iaroslav Shkliar on 02/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

import Foundation

public enum FetchError: Error {
    case httpError(statusCode: Int)
    case decodingError(Error?)
    case unknown(Error?)
}

extension FetchError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .httpError:
            return NSLocalizedString("Something went wrong. Please try again later.", comment: "A message describing error while getting data from API")
        case let .decodingError(error):
            return error?.localizedDescription
        case let .unknown(error):
            return error?.localizedDescription
        }
    }
}
