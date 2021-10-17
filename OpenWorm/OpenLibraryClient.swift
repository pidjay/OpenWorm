//
//  OpenLibraryClient.swift
//  OpenWorm
//
//  Created by Pierre-Jean Quilleré on 2021-10-17.
//

import Foundation

class OpenLibraryClient {
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: configuration)
    }
    
    func fetch<T: Decodable>(_ endpoint: APIEndPoint, into encodingType: T.Type, completionHandler: @escaping (Result<T, NetworkingError>) -> Void) {
        guard let url = endpoint.url else {
            completionHandler(.failure(.invalidURL(endpoint.debugURLString)))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            // something not related to server error happened (no connection is the most common)
            guard error == nil else {
                completionHandler(.failure(.unableToComplete))
                return
            }
            
            // check response status code
            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                completionHandler(.failure(.invalidResponse(response as? HTTPURLResponse)))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.invalidData(data)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let object = try decoder.decode(T.self, from: data)
                completionHandler(.success(object))
            } catch {
                completionHandler(.failure(.invalidData(data)))
            }
        }
        task.resume()
    }
}

fileprivate extension APIEndPoint {
    var debugURLString: String {
        var urlString = APIConstant.baseURL
        urlString += path
        
        // Append query if necessary
        if let queryItems = queryItems {
            let formattedQuery = queryItems.map { $0.debugDescription }.joined(separator: "&")
            urlString += "?\(formattedQuery)"
        }
        
        return urlString
    }
}
