//
//  NetworkManager.swift
//  WFN
//
//  Created by Suhas M on 19/12/23.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case serverError
    case unexpectedStatusCode
    case noData
    case parsingError
    case badUrlSession
}

final class NetworkManager {
    
    func fetchData(for urlString: String, completion: @escaping (Result<HomeListResponseModel, NetworkError>) -> Void) {

        guard let url = URL(string: urlString) else {
            completion(.failure(.badUrl))
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.serverError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                completion(.failure(.unexpectedStatusCode))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(HomeListResponseModel.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(.parsingError))
                return
            }
        }.resume()
    }
}

