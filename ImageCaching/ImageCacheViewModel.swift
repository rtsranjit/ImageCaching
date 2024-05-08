//
//  ImageCacheViewModel.swift
//  ImageCaching
//
//  Created by Mani on 08/05/24.
//

import Foundation

class ImageListViewModel {
    var mediaItem: [MediaItem] = []
    
    func fetchImages(completion: @escaping (Result<[MediaItem], Error>) -> Void) {
        APIRequest.shared.fetchImages { result in
            switch result {
            case .success(let mediaItem):
                self.mediaItem = mediaItem
                completion(.success(mediaItem))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
