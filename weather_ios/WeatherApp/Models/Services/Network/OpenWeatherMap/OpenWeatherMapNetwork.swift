//
//  OpenWeatherMapNetwork.swift
//  WeatherApp
//
//  Created by paul on 15/03/2020.
//  Copyright © 2020 pavel. All rights reserved.
//

import Alamofire

typealias WeatherResponse = (SuccessRespone?, Error?) -> Void

struct OpenWeatherMapNetwork: NetworkService {

    func getWeatherAt(city id: Int, result: @escaping WeatherResponse) {

        fetch( AF.request( Router.getWeather(fetchRequest: .args(city: id))),
              of: SuccessRespone.self) { response in

                result(response.value, response.error)
                print(response.value)
        }
    }
}
    
    // MARK: Open Weather Map API configuration
extension OpenWeatherMapNetwork {
    
    private typealias Api = Constants.OpenWeatherMap
    
    private enum Router: URLRequestConvertible {
        
        case getWeather(fetchRequest: FetchRequest)
        
        var method: HTTPMethod {
            switch self {
            case .getWeather:
                return .get
            }
        }
        
        var endpoint: String {
            switch self {
            case .getWeather:
                return Api.weatherEndpoint
            }
        }
        
        func asURLRequest() throws -> URLRequest {
            
            let url = try Api.baseURL.asURL()
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue

            switch self {
            case .getWeather(let fetchRequest):
                urlRequest.url = urlRequest.url?.appendingPathComponent(endpoint)
                urlRequest = try URLEncoding.default.encode(urlRequest,
                                                            with: fetchRequest.parameters)
            }
            
            return urlRequest
        }
        
    }
    
    private enum FetchRequest {
        
        case args(city: Int)
        
        var parameters: Parameters {
            if case .args(let city) = self {
                return [ Api.cityIdKey: city,
                         Api.appIdKey: Api.appId, ]
            }
            return [:]
        }
    }
}
