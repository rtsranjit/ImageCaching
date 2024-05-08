//
//  ImageCacheManager.swift
//  ImageCaching
//
//  Created by Mani on 08/05/24.
//

import Foundation
import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager()
    private let memoryCache = NSCache<NSURL, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    private init() {
        // Define cache directory
        if let directory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
            cacheDirectory = directory.appendingPathComponent("ImageCache")
            // Create cache directory if it doesn't exist
            if !fileManager.fileExists(atPath: cacheDirectory.path) {
                do {
                    try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print("Error creating cache directory: \(error)")
                }
            }
        } else {
            // Fallback directory if cache directory creation fails
            cacheDirectory = fileManager.temporaryDirectory
        }
    }

    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        // Check memory cache
        if let cachedImage = memoryCache.object(forKey: url as NSURL) {
            completion(cachedImage)
            return
        }

        // Check disk cache
        if let cachedImage = loadImageFromDiskCache(url: url) {
            // Cache in memory and return
            memoryCache.setObject(cachedImage, forKey: url as NSURL)
            completion(cachedImage)
            return
        }

        // If image not in cache, fetch from network
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let newImage = UIImage(data: data) else {
                completion(nil)
                return
            }

            // Cache in memory
            self.memoryCache.setObject(newImage, forKey: url as NSURL)
            
            // Cache in disk
            self.saveImageToDiskCache(image: newImage, url: url)

            completion(newImage)
        }.resume()
    }

    private func loadImageFromDiskCache(url: URL) -> UIImage? {
        let cacheFileURL = cacheFileURL(for: url)
        guard let data = try? Data(contentsOf: cacheFileURL) else { return nil }
        return UIImage(data: data)
    }
    
    private func saveImageToDiskCache(image: UIImage, url: URL) {
        let cacheFileURL = cacheFileURL(for: url)
        if let data = image.jpegData(compressionQuality: 1.0) {
            do {
                try data.write(to: cacheFileURL)
            } catch {
                print("Error saving image to disk cache: \(error)")
            }
        }
    }
    
    private func cacheFileURL(for url: URL) -> URL {
        // Extract the filename from the URL
        var components = url.pathComponents
        guard let _ = components.last else {
            // If filename extraction fails, fallback to using the entire URL string
            return cacheDirectory.appendingPathComponent(url.absoluteString)
        }
        // Append the filename to the cache directory
        components.removeFirst()
        return cacheDirectory.appendingPathComponent(components.joined())
    }
}
