//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Kislov Vadim on 27.02.2026.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidRequest
    case decodingError(Error)
}

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let completionOnMain: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let error {
                completionOnMain(.failure(NetworkError.urlRequestError(error)))
                
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                completionOnMain(.failure(NetworkError.urlSessionError))
                
                return
            }
            
            guard (200..<300).contains(statusCode) else {
                completionOnMain(.failure(NetworkError.httpStatusCode(statusCode)))
                
                return
            }
            
            if let data {
                completionOnMain(.success(data))
            } else {
                completionOnMain(.failure(NetworkError.urlSessionError))
            }
        })
        
        return task
    }
}
