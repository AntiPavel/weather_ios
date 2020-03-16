//
//  OpenWeatherMapNetwork.swift
//  WeatherApp
//
//  Created by paul on 15/03/2020.
//  Copyright © 2020 pavel. All rights reserved.
//

import Alamofire

struct OpenWeatherMapNetwork: NetworkService {
    
    func getWeatherAt(city id: Int, result: @escaping WeatherResponse) {

        fetch(request: AF.request( Router.getWeather(fetchRequest: .withId(id))),
              of: SuccessRespone.self) { response in

                result(response.value, response.error)
                print(response.value)
        }
    }
    
    func getWeatherAt(city name: String, result: @escaping WeatherResponse) {
        
        fetch(request: AF.request( Router.getWeather(fetchRequest: .withName(name))),
              of: SuccessRespone.self) { response in

                result(response.value, response.error)
                print(response.value)
        }
    }
    
    func getWeatherAt(coordinates: Coordinate, result: @escaping WeatherResponse) {
        
        fetch(request: AF.request( Router.getWeather(fetchRequest: .withCoordinates(coordinates))),
              of: SuccessRespone.self) { response in

                result(response.value, response.error)
                print(response.value)
        }
    }
    
    func getCity(id: Int, with decoder: JSONDecoder, result: @escaping CityResponse) {
        fetch(with: decoder, request: AF.request( Router.getWeather(fetchRequest: .withId(id))),
              of: City.self) { response in

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
        
        case withId(_ id: Int)
        case withName(_ name: String)
        case withCoordinates(_ coordinates: Coordinate)
        
        var parameters: Parameters {
//            if case .withId(let city) = self {
//                return [ Api.cityIdKey: city,
//                         Api.appIdKey: Api.appId,
//                         Api.unitsKey: Api.units, ]
//            }
            var params: [String: Any] = [ Api.appIdKey: Api.appId,
                                          Api.unitsKey: Api.units, ]
            switch self {
            case .withId(let id):
                params[Api.cityIdKey] = id
            case .withName(let name):
                params[Api.cityNameKey] = name
            case .withCoordinates(let coordinates):
                params[Api.cityLatKey] = coordinates.lat
                params[Api.cityLonKey] = coordinates.lon
            }
            return params
        }
    }
}
