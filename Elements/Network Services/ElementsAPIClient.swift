//
//  ElementsAPIClient.swift
//  Elements
//
//  Created by Eric Davenport on 12/19/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import Foundation

struct ElementAPIClient {
  
  static func getElements(completion: @escaping (Result<[Element],AppError>) -> ()) {
    
    let endpointURLString = "https://5c1d79abbc26950013fbcaa9.mockapi.io/api/v1/elements"
    
    guard let url = URL(string: endpointURLString) else {
      completion(.failure(.badURL(endpointURLString)))
      return
    }
    
    let request = URLRequest(url: url)
    
    NetworkHelper.shared.performDataTask(with: request) { (result) in
      switch result {
      case .failure(let appError):
        completion(.failure(.networkClientError(appError)))
      case .success(let data):
        do {
          let elements = try JSONDecoder().decode([Element].self, from: data)
          
          completion(.success(elements))
        } catch {
          completion(.failure(.decodingError(error)))
        }
      }
    }
    
  }
  
  static func getFavorites(completion: @escaping (Result<[Element], AppError>) -> ()) {
    
    let endpointURLString = "http://5c1d79abbc26950013fbcaa9.mockapi.io/api/v1/favorites"
    
    guard let url = URL(string: endpointURLString) else {
      completion(.failure(.badURL(endpointURLString)))
      return
    }
    let request = URLRequest(url: url)
    
    NetworkHelper.shared.performDataTask(with: request) { (result) in
      switch result {
      case .failure(let appError):
        completion(.failure(.networkClientError(appError)))
      case .success(let data):
        do {
          let elements = try JSONDecoder().decode([Element].self, from: data)
          let favoritesElements = elements.filter {$0.favoritedBy == "Eric D."}
          completion(.success(favoritesElements))
        } catch {
          completion(.failure(.decodingError(error)))
        }
      }
    }
    
  }
  
  
  static func makeFavorite(element: Element, completion: @escaping (Result<Bool, AppError>) -> ()) {
    
    let endpointURLString = "http://5c1d79abbc26950013fbcaa9.mockapi.io/api/v1/favorites"
    
    guard let url = URL(string: endpointURLString) else {
      completion(.failure(.badURL(endpointURLString)))
      return
    }
    
    do {
      let data = try JSONEncoder().encode(element)
      
      var request = URLRequest(url: url)
      
      request.httpMethod = "POST"
      
      request.httpBody = data
      
      request.addValue("application/json", forHTTPHeaderField: "Content-Type").self
      
      NetworkHelper.shared.performDataTask(with: request) { (result) in
        switch result {
        case .failure(let appError):
          completion(.failure(.networkClientError(appError)))
        case .success:
          completion(.success(true))
        }
      }
    } catch {
      completion(.failure(.encodingError(error)))
    }
    
    
  }
  
  
  
}
