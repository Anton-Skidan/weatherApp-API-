//
//  NetworkManager.swift
//  CurrentWeatherApp
//
//  Created by Антон Скидан on 21.06.2020.
//  Copyright © 2020 Anton Skidan. All rights reserved.
//

import Foundation
import CoreLocation

let apiKey = "611b2e059c1cc4daa636a2839435e017" // YOUR API KEY (openweathermap.org)


class NetworkManager {
    
    var onCompletion: ((CurrentWeatherModel) -> Void)?
    
    enum RequestType {
        case cityName(city: String)
        case coordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }
    
    func fetchCurrentWeather(requestType: RequestType) {
        var urlString = ""
        switch requestType {
            
        case .cityName(city: let city):
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&apikey=\(apiKey)&units=metric"
        case .coordinates(latitude: let latitude, longitude: let longitude):
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat={\(latitude)}&lon={\(longitude)}&apikey=\(apiKey)&units=metric"
        }
        performRequest(urlString: urlString)
    }
    
    fileprivate func performRequest(urlString: String) {
        guard let url = URL(string: urlString) else { return }
               let session = URLSession(configuration: .default)
               let task = session.dataTask(with: url) { data, response, error in
                   if let data = data {
                       if let currentWeather = self.parseJSON(with: data) {
                           self.onCompletion?(currentWeather)
                       }
                   }
               }
               task.resume()
    }
    
   fileprivate func parseJSON(with data: Data) -> CurrentWeatherModel? {
        let decoder = JSONDecoder()
        do {
        let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            guard let currentWeather = CurrentWeatherModel(currentWeatherData: currentWeatherData) else {
                return nil
            }
            return currentWeather
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
