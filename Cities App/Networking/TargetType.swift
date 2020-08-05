//
//  TargetType.swift
//  Cities App
//
//  Created by Iaroslav Shkliar on 02/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

import Foundation

public protocol TargetType {
    var baseURL: URL { get }
    var path: String { get }
    var method: RequestMethod { get }
    var task: RequestType { get }
    var headers: [String: String]? { get }
    var urlRequest: URLRequest { get }
    var sampleData: Data? { get }
}

public extension TargetType {
    var urlRequest: URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        request.httpMethod = method.rawValue

        var mutableHeaders = request.allHTTPHeaderFields ?? [:]

        if let headers = headers {
            mutableHeaders.merge(headers) { $1 }
        }

        switch task {
        case .requestPlain:
            break
        case let .requestParameters(parameters):
            switch method {
            case .get:
                if let queryURL = queryURL(from: parameters, url: url) {
                    request.url = queryURL
                }
            case .post:
                request.httpBody = formRequest(from: parameters)
            }
        case let .requestData(data):
            request.httpBody = data
        case let .requestJSON(encodable):
            if let httpBody = httpBody(from: encodable), method == .post {
                request.httpBody = httpBody
                mutableHeaders["Content-Type"] = "application/json"
            }
        }

        request.allHTTPHeaderFields = !mutableHeaders.isEmpty ? mutableHeaders : nil

        return request
    }

    // MARK: - Helpers

    private func httpBody(from encodable: Encodable) -> Data? {
        do {
            return try JSONEncoder().encode(AnyEncodable(encodable))
        } catch {
            print("JSON encoding error: \(error)")
        }

        return nil
    }

    private func queryURL(from parameters: [String: Any], url: URL) -> URL? {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return nil }

        var queryItems = components.queryItems?.reduce([String: Any]()) { parameters, queryItem in
            var parameters = parameters
            parameters[queryItem.name] = queryItem.value

            return parameters
        } ?? [:]

        queryItems.merge(parameters) { $1 }

        components.queryItems = queryItems.map { key, anyValue in
            let value = String(describing: anyValue).addingPercentEncoding(withAllowedCharacters: .alphanumerics)
            return URLQueryItem(name: key, value: value)
        }

        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")

        return components.url
    }

    private func formRequest(from parameters: [String: Any]) -> Data? {
        var formParameters: [String] = []

        parameters.forEach {
            formParameters.append($0.key + "=\($0.value)")
        }

        return formParameters.map { String($0) }.joined(separator: "&").data(using: .utf8)
    }
}

private struct AnyEncodable: Encodable {
    var value: Encodable

    init(_ value: Encodable) {
        self.value = value
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try value.encode(to: &container)
    }
}

private extension Encodable {
    func encode(to container: inout SingleValueEncodingContainer) throws {
        try container.encode(self)
    }
}
