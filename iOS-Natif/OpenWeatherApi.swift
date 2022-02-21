//
//  api.swift
//  iOS-Natif
//
//  Created by Earth on 16.02.2022.
//

import Foundation

class OpenWeatherApi {
    
    static func getWeather(latitude: Double , longitude: Double, completion: @escaping ((OpenWeather.Welcome) -> Void)) {
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=metric&exclude=minutely,alerts&appid=89e23deae336979d0c48c441eaf36fdb")!
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                guard let data = data else { print("error"); return }
                let value = try! JSONDecoder().decode(OpenWeather.Welcome.self, from: data)
                
                print("Load weather")
                print(value.lat)
                print(value.lon)
                completion(value)
            }
            task.resume()
        }
    }

    static func getCoordinates(by location_name: String , completion: @escaping ((OpenWeather.WelcomeElement) -> Void)) {
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            let string_url = "https://api.openweathermap.org/geo/1.0/direct?q=\(location_name)&limit=1&appid=89e23deae336979d0c48c441eaf36fdb".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            let url = URL(string: string_url)!
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                guard let data = data else { print("error"); return }
                let value = try! JSONDecoder().decode([OpenWeather.WelcomeElement].self, from: data)
                print(value.first?.state)
                print(value.first?.country)
                print(value.first?.name)
                completion(value.first!)
            }
            task.resume()
        }
    }
}
