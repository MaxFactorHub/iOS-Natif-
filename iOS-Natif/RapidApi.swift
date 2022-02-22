//
//  RapidApi.swift
//  iOS-Natif
//
//  Created by Earth on 21.02.2022.
//

import Foundation

class RapidApi: NSObject {
    
    private override init() {}

    private enum Status {
        case free
        case stop
        case scheduled
    }
    
    private static var canReq: Status = .free
    private static var namePrefix: String = String()
    private static var completion: ((RapidApi.Welcome) -> Void) = { _ in }
    
    @objc private static func reqSent() {
        RapidApi.HHHHHHHH(with: RapidApi.namePrefix, completion: RapidApi.completion)
        print("Отправлен запрос")
        RapidApi.canReq = .scheduled
        RapidApi.printCurrentDate()
    }
    
    private static func printCurrentDate() {
        let time = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YYYY HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let formatteddate = formatter.string(from: time as Date)
        print("\(formatteddate)z")
    }
    
    static func sendReq(with namePrefix: String, completion: @escaping ((RapidApi.Welcome) -> Void)) {
        switch RapidApi.canReq {
        case .free:
            print("Отправлен запрос")
            RapidApi.HHHHHHHH(with: namePrefix, completion: completion)
            RapidApi.canReq = .scheduled
            printCurrentDate()
        case .scheduled:
            RapidApi.namePrefix = namePrefix
            RapidApi.completion = completion
            Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(reqSent), userInfo: nil, repeats: false)
            print("Запрос поставлен в очередь")
            RapidApi.canReq = .stop
            printCurrentDate()
        case .stop:
            RapidApi.namePrefix = namePrefix
            RapidApi.completion = completion
            print("Ничего не произошло. Запрос уже в очереди")
            printCurrentDate()
        }
    }
    
    private static func HHHHHHHH(with namePrefix: String, completion: @escaping ((RapidApi.Welcome) -> Void)) {
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            let headers = [
                "x-rapidapi-host": "wft-geo-db.p.rapidapi.com",
                "x-rapidapi-key": "594a5b4cbemsh80aa28e414bde44p1cddaejsn0b3a019070ab"
            ]
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://wft-geo-db.p.rapidapi.com/v1/geo/cities?limit=10&namePrefix=\(namePrefix)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 60.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error)
                } else {
                    let value = try! JSONDecoder().decode(RapidApi.Welcome.self, from: data!)
                    completion(value)
                }
            })
            
            dataTask.resume()
        }
    }
    
    // MARK: - Welcome
    struct Welcome: Codable {
        let data: [Datum]?
        let links: [Link]?
        let metadata: Metadata?
    }

    // MARK: - Datum
    struct Datum: Codable {
        let id: Int
        let wikiDataID, name, country, countryCode: String
        let region, regionCode: String
        let latitude, longitude: Double
        let population: Int

        enum CodingKeys: String, CodingKey {
            case id
            case wikiDataID = "wikiDataId"
            case name, country, countryCode, region, regionCode, latitude, longitude, population
        }
    }

    // MARK: - Link
    struct Link: Codable {
        let rel, href: String
    }

    // MARK: - Metadata
    struct Metadata: Codable {
        let currentOffset, totalCount: Int
    }
}
