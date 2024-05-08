//
//  ImageCacheModel.swift
//  ImageCaching
//
//  Created by Mani on 08/05/24.
//

import Foundation

struct MediaItem: Codable {
    let id: String
    let title: String
    let language: Language
    let thumbnail: Thumbnail
    let mediaType: Int
    let coverageURL: String
    let publishedAt: String
    let publishedBy: String
    let backupDetails: BackupDetails?
    
    func generateImageURL() -> URL? {
        let imageURLString = "\(thumbnail.domain)/\(thumbnail.basePath)/0/\(thumbnail.key.rawValue)"
        return URL(string: imageURLString)
    }
}

struct BackupDetails: Codable {
    let pdfLink: String
    let screenshotURL: String
}

enum Language: String, Codable {
    case english = "english"
    case hindi = "hindi"
}

struct Thumbnail: Codable {
    let id: String
    let version: Int
    let domain: String
    let basePath: String
    let key: Key
    let qualities: [Int]
    let aspectRatio: Int
}

enum Key: String, Codable {
    case imageJpg = "image.jpg"
}

typealias VideoList = [MediaItem]
