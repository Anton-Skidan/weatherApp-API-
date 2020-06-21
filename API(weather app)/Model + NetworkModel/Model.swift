//
//  Model.swift
//  CurrentWeather
//
//  Created by Антон Скидан on 21.06.2020.
//  Copyright © 2020 Anton Skidan. All rights reserved.
//

import Foundation

//MARK: - RawData
struct CurrentWeatherData: Decodable {
    
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
    let feels_like: Double
}

struct Weather: Decodable {
    let id: Int
}

//MARK: - ProcessedData
struct CurrentWeatherModel {
    
    let cityName: String
    let temperature: Double
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
    let feelsLikeTemperature: Double
    var feelsLikeTemperatureString: String {
        return String(format: "%.0f", feelsLikeTemperature)
    }
    let condition: Int
    var systemIconNameString: String {
        switch condition {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "smoke"
        default:
            return "questionmark.circle"
        }
    }
    
    init?(currentWeatherData: CurrentWeatherData ) {
        cityName = currentWeatherData.name
        temperature = currentWeatherData.main.temp
        feelsLikeTemperature = currentWeatherData.main.feels_like
        condition = currentWeatherData.weather.first!.id
    }
    
}
