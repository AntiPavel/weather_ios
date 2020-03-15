//
//  NetworkService.swift
//  WeatherApp
//
//  Created by paul on 15/03/2020.
//  Copyright © 2020 pavel. All rights reserved.
//

import Alamofire

typealias Response<T> = (AFDataResponse<T>) -> Void

protocol NetworkService {
    func getWeatherAt(city id: Int, result: @escaping WeatherResponse)
}

extension NetworkService {
    func fetch<T: Decodable>(_ request: DataRequest, of: T.Type, result: @escaping Response<T>) {

        let decoder = JSONDecoder()
        if let infoContext = CodingUserInfoKey.managedObjectContext {
            decoder.userInfo[infoContext] = CoreData.shared.cityUpdateContext
        }
        
        request
            .validate()
            .responseDecodable(of: T.self, decoder: decoder) { response in
                result(response)
        }
    }
    
//    func fetch
}
