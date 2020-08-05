//
//  CitiesApi.swift
//  Cities App
//
//  Created by Iaroslav Shkliar on 02/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

import Foundation

typealias CitiesApiClient = ApiProvider<CitiesApi>

enum CitiesApi {
    case cityList
    case cityDetails(id: String)
    case cityRatings(cityId: String)
    case cityVisitors(cityId: String)
}

extension CitiesApi: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://5f2719070824d8001655ef1f.mockapi.io/api/") else {
            fatalError("baseURL could not be configured")
        }

        return url
    }

    var path: String {
        switch self {
        case .cityList:
            return "cities/"
        case let .cityDetails(id):
            return "cities/\(id)/"
        case let .cityRatings(cityId: cityId):
            return "cities/\(cityId)/ratings"
        case let .cityVisitors(cityId: cityId):
            return "cities/\(cityId)/visitors"
        }
    }

    var method: RequestMethod {
        .get
    }

    var task: RequestType {
        .requestPlain
    }

    var headers: [String: String]? {
        nil
    }

    var sampleData: Data? {
        switch self {
        case .cityList:
            let url = Bundle.main.url(forResource: "cities", withExtension: "json")!
            return try? Data(contentsOf: url)
        case .cityDetails:
            return nil
        case .cityRatings:
            let url = Bundle.main.url(forResource: "rating", withExtension: "json")!
            return try? Data(contentsOf: url)
        case .cityVisitors:
            let url = Bundle.main.url(forResource: "visitors", withExtension: "json")!
            return try? Data(contentsOf: url)
        }
    }
}
