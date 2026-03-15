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
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
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
                print("[URLSession.data] URL request error: \(error.localizedDescription)")
                completionOnMain(.failure(NetworkError.urlRequestError(error)))
                
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                print("[URLSession.data] URL session error")
                completionOnMain(.failure(NetworkError.urlSessionError))
                
                return
            }
            
            guard (200..<300).contains(statusCode) else {
                print("[URLSession.data] request completed with the status: \(statusCode)")
                completionOnMain(.failure(NetworkError.httpStatusCode(statusCode)))
                
                return
            }
            
            if let data {
                completionOnMain(.success(data))
            } else {
                print("[URLSession.data] URL session error")
                completionOnMain(.failure(NetworkError.urlSessionError))
            }
        })
        
        return task
    }
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let task = data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decodableResponseData = try JSONDecoder.snakeCaseDecoder.decode(T.self, from: data)
                    
                    completion(.success(decodableResponseData))
                } catch(let error) {
                    let decodableDataToString = String(data: data, encoding: .utf8) ?? ""
                    
                    if let error = error as? DecodingError {
                        print("[URLSession.objectTask] Decoding error: \(error), for data: \(decodableDataToString)")
                    } else {
                        print("[URLSession.objectTask] Decoding error: \(error.localizedDescription), for data: \(decodableDataToString)")
                    }
                    
                    completion(.failure(NetworkError.decodingError(error)))
                }
            case .failure(let error):
                print("[URLSession.objectTask] request error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        return task
    }
}
