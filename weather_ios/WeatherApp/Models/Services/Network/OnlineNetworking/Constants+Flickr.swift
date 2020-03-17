//
//  Constants+Flickr.swift
//  WeatherApp
//
//  Created by paul on 16/03/2020.
//  Copyright © 2020 pavel. All rights reserved.
//
// swiftlint:disable identifier_name
extension Constants {
    enum Flickr {
        static let baseURL = "https://api.flickr.com/"
        static let endpoint = "services/rest"
        static let id = "c90c2ca88890a06da9d32d2326182358"
        static let idKey = "api_key"
        static let formatKey = "format"
        static let format = "json"
        static let callbackKey = "nojsoncallback"
        static let nojsoncallback = 1
        static let tagKey = "tag"
        static let clusterKey = "cluster_id"
        static let methodKey = "method"
        static let clusterPhotosMethod = "flickr.tags.getClusterPhotos"
        static func makeImageUrlString(photo: Photo) -> String {
            return "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg"
        }
    }
}
