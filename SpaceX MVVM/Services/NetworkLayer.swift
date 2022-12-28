//
//  NetworkLayer.swift
//  mvvm first
//  
//  Created by Vlad Zavada on 12/23/22.
//

import Foundation

final class NetworkLayer {
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    func loadData<T: Decodable>(url from: String,
                                modelType: T.Type,
                                completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: from) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else { return }

            do {
                let json = try self.decoder.decode(modelType, from: data)
                completion(.success(json))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
