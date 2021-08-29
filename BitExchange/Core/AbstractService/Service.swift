//
//  Service.swift
//  NewsApp
//
//  Created by Vinsi on 03/08/2021.
//

import Foundation
import Combine

protocol Service { }

extension Service {
    
    func request<T: APIBuilder, R: Codable>(from endpoint: T, responseType: R.Type) -> AnyPublisher<R, APIError> {
        return URLSession
            .shared
            .dataTaskPublisher(for: endpoint.urlRequest)
            .receive(on: DispatchQueue.main)
            .mapError { _ in APIError.unknown }
            .flatMap { data, response -> AnyPublisher<R, APIError> in
                guard let response = response as? HTTPURLResponse else {
                    return Fail(error: APIError.unknown).eraseToAnyPublisher()
                }
                
                if (200...299).contains(response.statusCode) {
                    let jsonDecoder = JSONDecoder()
                    //jsonDecoder.dateDecodingStrategy = .iso8601
                    return Just(data)
                        .decode(type: R.self, decoder: jsonDecoder)
                        .mapError { _ in
                            APIError.decodingError }
                        .eraseToAnyPublisher()
                } else {
                    return Fail(error: APIError.errorCode(response.statusCode)).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    func requestForJsonObject<T: APIBuilder>(from endpoint: T) -> AnyPublisher<[Any], APIError> {
        return URLSession
            .shared
            .dataTaskPublisher(for: endpoint.urlRequest)
            .receive(on: DispatchQueue.main)
            .mapError { _ in APIError.unknown }
            .flatMap { data, response -> AnyPublisher<[Any], APIError> in
                guard let response = response as? HTTPURLResponse else {
                    return Fail(error: APIError.unknown).eraseToAnyPublisher()
                }
                
                if (200...299).contains(response.statusCode) {
                    //jsonDecoder.dateDecodingStrategy = .iso8601
                    return Future<[Any], APIError> { promise in
                        guard let jsonData = try? JSONSerialization.jsonObject(with: data) as? [Any] else {
                            promise(.failure(APIError.decodingError))
                            return
                        }
                        promise(.success(jsonData))
                    }.eraseToAnyPublisher()
                } else {
                    return Fail(error: APIError.errorCode(response.statusCode)).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}
