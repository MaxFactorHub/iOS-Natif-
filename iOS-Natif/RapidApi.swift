//
//  RapidApi.swift
//  iOS-Natif
//
//  Created by Earth on 21.02.2022.
//

import Foundation

class RapidApi: NSObject {

    private override init() {}

    // MARK: - RequestStatus
    private enum DelayStatus {
        case inactive
        case activeLikeBlocking
        case activeLikeDelaying
    }

    // MARK: - Variables
    private static var delayRequestStatus: DelayStatus = .inactive
    private static var namePrefix: String = String()
    private static var completion: ((Rapid.Welcome) -> Void) = { _ in }
    private static let appid = "&appid=89e23deae336979d0c48c441eaf36fdb"
    private static let domain = "https://wft-geo-db.p.rapidapi.com/"
    private static let parameters = "v1/geo/cities?limit=10"

    // MARK: - sendingDelayRequest
    @objc private static func sendingDelayRequest() {
        RapidApi.sendingRequest(with: RapidApi.namePrefix, completion: RapidApi.completion)
        RapidApi.delayRequestStatus = .activeLikeDelaying
    }

    // MARK: - requestWithDelayControl
    static func requestWithDelayControl(with namePrefix: String, completion: @escaping ((Rapid.Welcome) -> Void)) {
        switch RapidApi.delayRequestStatus {
        case .inactive:
            RapidApi.sendingRequest(with: namePrefix, completion: completion)
            RapidApi.delayRequestStatus = .activeLikeDelaying
        case .activeLikeDelaying:
            RapidApi.namePrefix = namePrefix
            RapidApi.completion = completion
            let selector = #selector(sendingDelayRequest)
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: selector, userInfo: nil, repeats: false)
            RapidApi.delayRequestStatus = .activeLikeBlocking
        case .activeLikeBlocking:
            RapidApi.namePrefix = namePrefix
            RapidApi.completion = completion
        }
    }

    // MARK: - sendingRequest
    private static func sendingRequest(with namePrefix: String, completion: @escaping ((Rapid.Welcome) -> Void)) {
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            let headers = [
                "x-rapidapi-host": "wft-geo-db.p.rapidapi.com",
                "x-rapidapi-key": "594a5b4cbemsh80aa28e414bde44p1cddaejsn0b3a019070ab"
            ]

            var url = domain + parameters + "&namePrefix=\(namePrefix)"
            url = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 60.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers

            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, _, _) -> Void in
                guard let value = try? JSONDecoder().decode(Rapid.Welcome.self, from: data!) else { return }
                completion(value)
            })
            dataTask.resume()
        }
    }
}
