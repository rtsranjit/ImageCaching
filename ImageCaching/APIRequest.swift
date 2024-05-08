//
//  APIRequest.swift
//  ImageCaching
//
//  Created by Mani on 08/05/24.
//

import Foundation

class APIRequest {
    static let shared = APIRequest()
    
    private let baseURL = "https://acharyaprashant.org/api/v2/"
    private let basePath = "content/misc/media-coverages?limit=100"
    
    private init() {}
    
    func fetchImages(completion: @escaping (Result<[MediaItem], Error>) -> Void) {
        
        guard let url = URL(string: baseURL + basePath) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(NSError(domain: "Data is nil", code: -1, userInfo: nil)))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let imageData = try decoder.decode([MediaItem].self, from: data)
                completion(.success(imageData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
