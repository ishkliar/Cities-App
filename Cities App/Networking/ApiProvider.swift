//
//  ApiProvider.swift
//  Cities App
//
//  Created by Iaroslav Shkliar on 02/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

import Foundation

public typealias Response<Model> = Result<Model, FetchError>

public final class ApiProvider<Target: TargetType> {

    // MARK: - Private properties

    private let session: URLSession
    private let testMode: Bool

    // MARK: - Init

    init(session: URLSession = URLSession.shared, testMode: Bool = false) {
        self.session = session
        self.testMode = testMode
    }

    // MARK: - Methods

    public func request<Model: Decodable>(_ target: Target, completion: @escaping (Response<Model>) -> Void) {

        guard !testMode else {
            guard let data = target.sampleData else {
                fatalError("Couldn't read sample data")
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedData = try decoder.decode(Model.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.decodingError(error)))
            }

            return
        }

        let urlRequest = target.urlRequest
        let task = session.dataTask(with: urlRequest) { responseData, urlResponse, error in
            let result: Response<Model>
            let response = urlResponse as? HTTPURLResponse

            if let error = error {
                result = .failure(.unknown(error))
            } else if let statusCode = response?.statusCode {
                if ApiProvider.isSuccess(httpStatusCode: statusCode) {
                    let data = responseData ?? Data()
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let decodedData = try decoder.decode(Model.self, from: data)
                        result = .success(decodedData)
                    } catch {
                        result = .failure(.decodingError(error))
                    }
                } else {
                    result = .failure(.httpError(statusCode: statusCode))
                }
            } else {
                result = .failure(.unknown(nil))
            }

            DispatchQueue.main.async {
                completion(result)
            }
        }

        task.resume()
    }
}

public extension ApiProvider {
    static func isSuccess(httpStatusCode: Int) -> Bool {
        switch httpStatusCode {
        case 200 ... 299:
            return true
        default:
            return false
        }
    }
}

public extension Result {
    var value: Success? {
        switch self {
        case let .success(value):
            return value
        case .failure:
            return nil
        }
    }

    var error: Failure? {
        switch self {
        case .success:
            return nil
        case let .failure(error):
            return error
        }
    }
}
