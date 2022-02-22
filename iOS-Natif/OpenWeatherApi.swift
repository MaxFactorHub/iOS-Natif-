//
//  api.swift
//  iOS-Natif
//
//  Created by Earth on 16.02.2022.
//

import Foundation

class OpenWeatherApi {

    private static let appid = "&appid=89e23deae336979d0c48c441eaf36fdb"
    private static let domain = "https://api.openweathermap.org/"

    static func getWeather(latitude: Double, longitude: Double, completion: @escaping ((OpenWeather.Welcome?) -> Void)) {
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            let parameters = "data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=metric&exclude=minutely,alerts"
            let stringUrl = domain + parameters + appid
            let url = URL(string: stringUrl)!
            let task = URLSession.shared.dataTask(with: url) {(data, _, _) in
                guard let data = data else { return }
                let value = try? JSONDecoder().decode(OpenWeather.Welcome.self, from: data)
                completion(value)
            }
            task.resume()
        }
    }

    static func getCoordinates(by locationName: String, completion: @escaping ((OpenWeather.WelcomeElement) -> Void)) {
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            var stringUrl = domain + "geo/1.0/direct?q=\(locationName)&limit=1" + appid
            stringUrl = stringUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            let url = URL(string: stringUrl)!
            let task = URLSession.shared.dataTask(with: url) {(data, _, _) in
                guard let welcomeElement = data else { return }
                if let location = try? JSONDecoder().decode([OpenWeather.WelcomeElement].self, from: welcomeElement).first {
                    completion(location)
                }
            }
            task.resume()
        }
    }
}
