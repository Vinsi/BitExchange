//
//  BFXSocketServiceManager.swift
//  BitExchange
//
//  Created by Vinsi on 28/08/2021.
//

import Foundation
import Starscream
import Combine

final class BFXSocketServiceManager {
    
    private static let shared = BFXSocketServiceManager()
    private init() {}
    private(set) var command: String = ""
    class func sharedInstance() -> BFXSocketServiceManager {
        return shared
    }
    
    private(set)var socket: WebSocket!
    
    func start<T:SocketBuildable>(with builder: T) -> AnyPublisher<[Any], APIError>   {
        command = builder.parameter.toJsonString
        socket = WebSocket(request: builder.urlRequest())
        let future = Future<[Any],APIError> { [weak self] promise in
            guard let self = self else {
                return
            }
            self.socket.onEvent = { event in
                switch event {
                case .connected(_):
                    self.socket.write(string: self.command)
                case .error(.some(let err)):
                    print("socket disconnected\(err.localizedDescription)")
                    promise(.failure(.disconnected))
                case .text(let word):
                    print( word.data(using: .utf16))
                    guard let data = word.data(using: .utf16) ,
                          let jsonData = try? JSONSerialization.jsonObject(with: data) else {
                        return
                    }
                    print(jsonData)
                    let array = jsonData as? [[Any]]
                    DispatchQueue.main.async {
                        promise(.success(array?[1] ?? []))
                    }
                default:
                    break
                }
            }
        }
        defer {
            socket.connect()
        }
        return future.eraseToAnyPublisher()
    }
}
