//
//  NetworkService.swift
//  WeatherApp
//
//  Created by paul on 15/03/2020.
//  Copyright © 2020 pavel. All rights reserved.
//

import Alamofire

typealias Response<T> = (AFDataResponse<T>) -> Void
typealias WeatherResponse = (WeatherModel?, Error?) -> Void
typealias CityResponse = (City?, Error?) -> Void
typealias Success = (Bool) -> Void

protocol NetworkService {
    // swiftlint:disable identifier_name
    func getWeatherAt(city id: Int, result: @escaping WeatherResponse)
    func getWeatherAt(city name: String, result: @escaping WeatherResponse)
    func getWeatherAt(coordinates: Coordinate, result: @escaping WeatherResponse)
    func fetchCityForStorage(id: Int, isSuccess: @escaping Success)
    func getCity(id: Int, with decoder: JSONDecoder, result: @escaping CityResponse)
}

extension NetworkService {

    func fetch<T: Decodable>(with decoder: JSONDecoder = JSONDecoder(), request: DataRequest, of: T.Type, result: @escaping Response<T>) {
        
        request
            .validate()
            .responseDecodable(of: T.self, decoder: decoder) { response in
                result(response)
        }
    }
}
