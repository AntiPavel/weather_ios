//
//  OpenWeatherMapNetwork.swift
//  WeatherApp
//
//  Created by paul on 15/03/2020.
//  Copyright © 2020 pavel. All rights reserved.
//

import Alamofire

final class OnlineNetworking: NetworkService {
    
    func getWeatherAt(city id: Int, result: @escaping WeatherResponse) {

        fetch(request: AF.request( Router.getWeather(fetchRequest: .withId(id))),
              of: SuccessRespone.self) { response in
                result(response.value, response.error)
        }
    }
    
    func getWeatherAt(city name: String, result: @escaping WeatherResponse) {
        
        fetch(request: AF.request( Router.getWeather(fetchRequest: .withName(name))),
              of: SuccessRespone.self) { response in
                result(response.value, response.error)
        }
    }
    
    func getWeatherAt(coordinates: Coordinate, result: @escaping WeatherResponse) {
        
        fetch(request: AF.request( Router.getWeather(fetchRequest: .withCoordinates(coordinates))),
              of: SuccessRespone.self) { response in
                result(response.value, response.error)
        }
    }
    
    func fetchCityForStorage(id: Int, isSuccess: @escaping Success) {
        fetch(request: AF.request( Router.getWeather(fetchRequest: .withId(id))),
              of: City.self) { response in
            switch response.result {
            case .success:
                isSuccess(true)
            case .failure:
                isSuccess(false)
            }
        }
    }
    
    func getCity(id: Int, with decoder: JSONDecoder, result: @escaping CityResponse) {
        fetch(with: decoder, request: AF.request( Router.getWeather(fetchRequest: .withId(id))),
              of: City.self) { response in
                result(response.value, response.error)
        }
    }
}

extension OnlineNetworking: ImageProvider {
    
    func getImage(tag: String, cluster: String, result: @escaping (UIImage?) -> Void) {
        
        fetch(request: AF.request( Router.getImages(fetchRequest: .images(tag: tag, cluster: cluster))),
              of: FlickrResponse.self) { [weak self] flickrResponse in

                switch flickrResponse.result {
                case .success(let flickrData):
                    guard let photo = flickrData.photos.photo.randomElement() else {
                            result(nil)
                            return
                        }
                    let url = Constants.Flickr.makeImageUrlString(photo: photo)
                    self?.fetchImage(url: url) { image in
                        result(image)
                    }
                case .failure:
                    result(nil)
                }
        }
    }
    
    private func fetchImage(url: String, result: @escaping (UIImage?) -> Void) {
        
        AF.request(url, method: .get).response { response in
           switch response.result {
           case .success(let responseData):
                guard let data = responseData else { return }
                result(UIImage(data: data, scale: 1))
           case .failure:
                result(nil)
            }
        }
    }
    
    private func makeImageUrlString(photo: Photo) -> String {
        return "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg"
    }
}
    
    // MARK: API configuration
private extension OnlineNetworking {
    
    typealias Api = Constants.OpenWeatherMap
    typealias FlickrApi = Constants.Flickr
    
    enum Router: URLRequestConvertible {
        
        case getWeather(fetchRequest: FetchRequest)
        case getImages(fetchRequest: FetchRequest)
        
        var method: HTTPMethod {
            switch self {
            case .getWeather, .getImages:
                return .get
            }
        }
        
        var endpoint: String {
            switch self {
            case .getWeather:
                return Api.weatherEndpoint
            case .getImages:
                return FlickrApi.endpoint
            }
        }
        
        func asURLRequest() throws -> URLRequest {

            switch self {
            case .getWeather(let fetchRequest):
                let url = try Api.baseURL.asURL()
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method.rawValue
                urlRequest.url = urlRequest.url?.appendingPathComponent(endpoint)
                urlRequest = try URLEncoding.default.encode(urlRequest,
                                                            with: fetchRequest.parameters)
                return urlRequest
            case .getImages(let fetchRequest):
                let url = try FlickrApi.baseURL.asURL()
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = method.rawValue
                urlRequest.url = urlRequest.url?.appendingPathComponent(endpoint)
                urlRequest = try URLEncoding.default.encode(urlRequest,
                                                            with: fetchRequest.parameters)
                return urlRequest
            }
        }
        
    }
    
    enum FetchRequest {
        
        case withId(_ id: Int)
        case withName(_ name: String)
        case withCoordinates(_ coordinates: Coordinate)
        case images(tag: String, cluster: String)
        
        var parameters: Parameters {

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
            case .images(let tag, let cluster):
                params = [FlickrApi.tagKey: tag,
                          FlickrApi.clusterKey: cluster,
                          FlickrApi.idKey: FlickrApi.id,
                          FlickrApi.formatKey: FlickrApi.format,
                          FlickrApi.callbackKey: FlickrApi.nojsoncallback,
                          FlickrApi.methodKey: FlickrApi.clusterPhotosMethod,
                        ]
            }
            return params
        }
        
    }
}
