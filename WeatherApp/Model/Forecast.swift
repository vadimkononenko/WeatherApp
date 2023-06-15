//
//  CurrentForecast.swift
//  WeatherApp
//
//  Created by Vadim Kononenko on 15.06.2023.
//

import Foundation

// MARK: - CurrentForecast
struct CurrentForecast: Codable {
    let location: Location
    let current: Current
}

// MARK: - Current
struct Current: Codable {
    let tempC, isDay: Int
    let condition: Condition
    let feelslikeC: Double
    let uv: Int

    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case isDay = "is_day"
        case condition
        case feelslikeC = "feelslike_c"
        case uv
    }
}

// MARK: - Condition
struct Condition: Codable {
    let text, icon: String
    let code: Int
}

// MARK: - Location
struct Location: Codable {
    let name, region, country: String
    let lat, lon: Double
    let tzID: String
    let localtimeEpoch: Int
    let localtime: String

    enum CodingKeys: String, CodingKey {
        case name, region, country, lat, lon
        case tzID = "tz_id"
        case localtimeEpoch = "localtime_epoch"
        case localtime
    }
}

//MARK: - WeeklyForecast
struct WeeklyForecast: Codable {
    let location: Location
    let current: Current
    let forecast: Forecast
}

// MARK: - Forecast
struct Forecast: Codable {
    let forecastday: [Forecastday]
}

// MARK: - Forecastday
struct Forecastday: Codable {
    let date: String
    let dateEpoch: Int
    let day: Day
    let astro: Astro
    let hour: [Hour]

    enum CodingKeys: String, CodingKey {
        case date
        case dateEpoch = "date_epoch"
        case day, astro, hour
    }
}

// MARK: - Astro
struct Astro: Codable {
}

// MARK: - Day
struct Day: Codable {
    let maxtempC, mintempC, avgtempC: Double
    let totalsnowCM: Int
    let condition: Condition

    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case mintempC = "mintemp_c"
        case avgtempC = "avgtemp_c"
        case totalsnowCM = "totalsnow_cm"
        case condition
    }
}

// MARK: - Hour
struct Hour: Codable {
    let timeEpoch: Int
    let time: String
    let tempC: Double
    let isDay: Int
    let condition: Condition
    let feelslikeC: Double

    enum CodingKeys: String, CodingKey {
        case timeEpoch = "time_epoch"
        case time
        case tempC = "temp_c"
        case isDay = "is_day"
        case condition
        case feelslikeC = "feelslike_c"
    }
}
