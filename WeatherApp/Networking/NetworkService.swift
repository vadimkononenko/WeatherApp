//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Vadim Kononenko on 15.06.2023.
//

import Foundation
import Alamofire

enum WeatherError: String, Error {
    case invalidUrl = "Bad URL"
    case unableToComplete = "Something went wrong"
    case invalidData = "Invalid data!"
    case responseError = "Bad response"
    case decodingProblem = "Unable to decode according to difinite type"
}

class NetworkService {
    static let shared = NetworkService()
    
    private let baseUrl = "http://api.weatherapi.com/v1"
    private let apiKey = Constants.apiKey
    
    private init() {}
    
    /// Making request using Alamofire
    func getWeeklyWeather(city: String, completion: @escaping (Result<WeeklyForecast, WeatherError>) -> Void) {
        let parameters: Parameters = [
            "q": city,
            "key": apiKey
        ]
        let endpoint = "/forecast.json"
        
        AF.request(baseUrl + endpoint, parameters: parameters).responseDecodable(of: WeeklyForecast.self) { response in
            guard let data = response.data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let forecast = try JSONDecoder().decode(WeeklyForecast.self, from: data)
                completion(.success(forecast))
            } catch {
                completion(.failure(.unableToComplete))
            }
        }
    }
    
    /// Making request using Alamofire
    func getWeeklyWeather(latitude: Double,
                          longitude: Double,
                          completion: @escaping (Result<WeeklyForecast, WeatherError>) -> Void
    ) {
        let coordinate = "\(latitude),\(longitude)"
        let parameters: Parameters = [
            "q": coordinate,
            "key": apiKey
        ]
        let endpoint = "/forecast.json"
        
        AF.request(baseUrl + endpoint, parameters: parameters).responseDecodable(of: WeeklyForecast.self) { response in
            guard let data = response.data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let forecast = try JSONDecoder().decode(WeeklyForecast.self, from: data)
                completion(.success(forecast))
            } catch {
                completion(.failure(.unableToComplete))
            }
        }
    }
    
    /// Making request using URLSession
    func getCurrentWeather(city: String, complition: @escaping (Result<CurrentForecast, WeatherError>) -> Void) {
        let endpoint = baseUrl + "/current.json?key=\(apiKey)&q=\(city)"
        
        guard let url = URL(string: endpoint) else {
            complition(.failure(.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                complition(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                complition(.failure(.responseError))
                return
            }
            
            guard let data = data else {
                complition(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let currentWeather = try decoder.decode(CurrentForecast.self, from: data)
                complition(.success(currentWeather))
            } catch {
                complition(.failure(.decodingProblem))
            }
        }
        
        task.resume()
    }
    
}
