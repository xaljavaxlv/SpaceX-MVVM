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
                                completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: from) else { return }
        return URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else { return }

            do {
                let json = try self.decoder.decode(T.self, from: data)
                completion(.success(json))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
}
