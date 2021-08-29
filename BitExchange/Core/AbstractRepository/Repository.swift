//
//  Repository.swift
//  NewsApp
//
//  Created by Vinsi on 02/08/2021.
//
import Foundation
import Combine

enum RepoError: Error {
  case serverError(ApiError: APIError)
  case localStorageError
}

protocol RepositoryType {
    
    associatedtype ModelType
    func getAll() -> AnyPublisher<ModelType,RepoError>
    func get<T>(for param: T) -> AnyPublisher<ModelType,RepoError>
    func deleteAll()
    func create( a: ModelType ) -> AnyPublisher<Bool,RepoError>
    func update( a: ModelType ) -> AnyPublisher<Bool,RepoError>
    func delete( a: ModelType ) -> AnyPublisher<Bool,RepoError>
}

extension RepositoryType {
    
    func getAll() -> AnyPublisher<ModelType,RepoError> {
        fatalError("Not implemented")
    }
    
    func get<T>(for param: T) -> AnyPublisher<ModelType,RepoError>{
        fatalError("Not implemented")
    }
    
    func deleteAll() {
        fatalError("Not implemented")
    }
    
    func create( a: ModelType ) -> AnyPublisher<Bool,RepoError> {
        fatalError("Not implemented")
    }
    
    func update( a: ModelType ) -> AnyPublisher<Bool,RepoError> {
        fatalError("Not implemented")
    }
    
    func delete( a: ModelType ) -> AnyPublisher<Bool,RepoError> {
        fatalError("Not implemented")
    }
}
