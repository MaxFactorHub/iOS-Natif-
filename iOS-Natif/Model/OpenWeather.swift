//
//  Model.swift
//  iOS-Natif
//
//  Created by Earth on 20.02.2022.
//

import Foundation

struct OpenWeather {

    // MARK: - Variables
    private static var data: Welcome!

    // MARK: - getCurrentDate
    static func getCurrentDate() -> String {
        if let current = self.data?.current {
            return getDate(from: current.dt, with: " EEEE, MMM d, yyyy")
        }
        return ""
    }

    // MARK: - getCurrentData
    static func getCurrentData() -> (humidity: Int, temp: Double, windSpeed: Double ) {
        if let current = self.data?.current {
            return (current.humidity, current.temp, current.windSpeed)
        }
        return (0, 0, 0)
    }

    // MARK: - set(weatherData:)
    static func set(weatherData: Welcome) {
        self.data = weatherData
    }

    // MARK: - getDataTimeZone
    static func getDataTimeZone() -> String {
        return data.timezone
    }

    // MARK: - getDate
    private static func getDate(from date: Int, with format: String) -> String {
        let epocTime = TimeInterval(date)
        let myDate = Date(timeIntervalSince1970: epocTime)
        let df = DateFormatter()
        df.dateFormat = format
        return df.string(from: myDate)
    }

    // MARK: - Deily
    static func getDeily() -> [Daily] {
        self.data?.daily ?? [Daily]()
    }

    static func getDeilyCount() -> Int {
        self.data?.daily.count ?? 0
    }

    static func getDeilyDate(from index: Int) -> String {
        let daily = getDeily()
        let dt = daily[index].dt
        return getDate(from: dt, with: "E")
    }

    // MARK: - Hourly
    static func getHourlyCount() -> Int {
        self.data?.hourly.count ?? 0
    }

    static func getHourly() -> [Current] {
        self.data?.hourly ?? [Current]()
    }

    static func getHourlyDate(from index: Int) -> String {
        let hourly = getHourly()
        let dt = hourly[index].dt
        return getDate(from: dt, with: " HH:mm")
    }

    // MARK: - Welcome
    struct Welcome: Codable {
        let lat, lon: Double
        let timezone: String
        let timezoneOffset: Int
        let current: Current
        let hourly: [Current]
        let daily: [Daily]

        enum CodingKeys: String, CodingKey {
            case lat, lon, timezone
            case timezoneOffset = "timezone_offset"
            case current, hourly, daily
        }
    }

    // MARK: - Current
    struct Current: Codable {
        let dt: Int
        let sunrise, sunset: Int?
        let temp, feelsLike: Double
        let pressure, humidity: Int
        let dewPoint, uvi: Double
        let clouds, visibility: Int
        let windSpeed: Double
        let windDeg: Int
        let windGust: Double?
        let weather: [Weather]
        let pop: Double?
        let rain: Rain?
        let snow: Snow?

        enum CodingKeys: String, CodingKey {
            case dt, sunrise, sunset, temp
            case feelsLike = "feels_like"
            case pressure, humidity
            case dewPoint = "dew_point"
            case uvi, clouds, visibility
            case windSpeed = "wind_speed"
            case windDeg = "wind_deg"
            case windGust = "wind_gust"
            case weather, pop, rain, snow
        }
    }

    // MARK: - Rain
    struct Rain: Codable {
        let the1H: Double?

        enum CodingKeys: String, CodingKey {
            case the1H = "1h"
        }
    }

    // MARK: - Snow
    struct Snow: Codable {
        let the1H: Double?

        enum CodingKeys: String, CodingKey {
            case the1H = "1h"
        }
    }

    // MARK: - Weather
    struct Weather: Codable {
        let id: Int
        let main: String
        let weatherDescription: String
        let icon: String

        enum CodingKeys: String, CodingKey {
            case id, main
            case weatherDescription = "description"
            case icon
        }
    }

    // MARK: - Daily
    struct Daily: Codable {
        let dt, sunrise, sunset, moonrise: Int
        let moonset: Int
        let moonPhase: Double
        let temp: Temp
        let feelsLike: FeelsLike
        let pressure, humidity: Int
        let dewPoint, windSpeed: Double
        let windDeg: Int
        let windGust: Double?
        let weather: [Weather]
        let clouds: Int
        let pop, uvi: Double
        let rain, snow: Double?

        enum CodingKeys: String, CodingKey {
            case dt, sunrise, sunset, moonrise, moonset
            case moonPhase = "moon_phase"
            case temp
            case feelsLike = "feels_like"
            case pressure, humidity
            case dewPoint = "dew_point"
            case windSpeed = "wind_speed"
            case windDeg = "wind_deg"
            case windGust = "wind_gust"
            case weather, clouds, pop, rain, snow, uvi
        }
    }

    // MARK: - FeelsLike
    struct FeelsLike: Codable {
        let day, night, eve, morn: Double
    }

    // MARK: - Temp
    struct Temp: Codable {
        let day, min, max, night: Double
        let eve, morn: Double
    }

    // MARK: - WelcomeElement
    struct WelcomeElement: Codable {
        let name: String
        let localNames: LocalNames?
        let lat, lon: Double
        let country: String
        let state: String?

        enum CodingKeys: String, CodingKey {
            case name
            case localNames = "local_names"
            case lat, lon, country, state
        }
    }

    // MARK: - LocalNames
    struct LocalNames: Codable {
        let af, ar: String?
        let ascii: String?
        let az, bg, ca, da: String?
        let de, el: String?
        let en: String?
        let eu, fa: String?
        let featureName: String?
        let fi, fr, gl, he: String?
        let hi, hr, hu, id: String?
        let it, ja, la, lt: String?
        let mk, nl, no, pl: String?
        let pt, ro, ru, sk: String?
        let sl, sr, th, tr: String?
        let vi, zu: String?

        enum CodingKeys: String, CodingKey {
            case af, ar, ascii, az, bg, ca, da, de, el, en, eu, fa
            case featureName = "feature_name"
            case fi, fr, gl, he, hi, hr, hu, id, it, ja, la, lt, mk, nl, no, pl, pt, ro, ru, sk, sl, sr, th, tr, vi, zu
        }
    }

}
