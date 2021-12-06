//
//  NetworkManager.swift
//  GuardianApp
//
//  Created by Biradar, Vachanashree (623-Extern) on 05/12/21.
//

import Foundation
import Combine


class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {
        
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let apiKey = "4a5947b3-5079-4fe2-b834-5f971fb5d4fc"
    private let baseURL = "https://content.guardianapis.com/search?"
    
    private func generateSearchURL(from query: String, fields: [String], orderBy: OrderBy) -> URL? {
        let percentEncodedString = fields.joined(separator: ",").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? fields.joined(separator: ",")
        var url = baseURL
        url += "show-fields=\(percentEncodedString)"
        url += "&order-by=\(orderBy)"
        url += "&q=\(query)"
        url += "&api-key=\(apiKey)"
        return URL(string: url)
    }
    
    func getData<T: Decodable>(from query: String, fields: [String], orderBy: OrderBy,  responseType: T.Type = T.self) -> Future<T, Error> {
        return Future<T, Error> { [weak self] promise in
            guard let self = self, let url = self.generateSearchURL(from: query, fields: fields, orderBy: orderBy) else {
                return promise(.failure(NetworkError.invalidURL))
            }
            print("URL is \(url.absoluteString)")
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.unknown))
                        }
                    }
                }, receiveValue: { promise(.success($0)) })
                .store(in: &self.cancellables)
        }
    }
}


enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        }
    }
}
