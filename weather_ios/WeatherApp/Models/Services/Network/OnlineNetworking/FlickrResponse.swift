//
//  FlickrResponse.swift
//  WeatherApp
//
//  Created by paul on 17/03/2020.
//  Copyright © 2020 pavel. All rights reserved.
//

import Foundation

struct FlickrResponse: Decodable {
    let stat: String
    let photos: Photos
}

struct Photos: Decodable {
    let photo: [Photo]
}

struct Photo: Decodable {
    let id: String
    let secret: String
    let server: String
    let farm: Int
}

///https://www.flickr.com/services/rest/?method=flickr.tags.getClusterPhotos&api_key=c90c2ca88890a06da9d32d2326182358&tag=snow&cluster_id=broken%2Fclouds&format=json&nojsoncallback=1
