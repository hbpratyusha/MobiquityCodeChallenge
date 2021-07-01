//
//  APIManager.swift
//  MobiquityCodeChallenge
//
//  Created by Pratyusha on 30/06/21.
//  Copyright © 2021 Mobiquity. All rights reserved.
//

import Foundation
import CoreLocation
public enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
}
struct APIResponse<T: Decodable>: Decodable {
    var list: [T]?
    var success: Bool
    var message: String
}
class APIManager: NSObject {
    static let sharedInstance: APIManager = {
        let instance = APIManager()
        return instance
    }()
    var currentLocation: CLLocationCoordinate2D? = nil
    var shouldReload: Bool = false
    var shouldReloadForecast: Bool = false
    func requestWith<T: Codable>(urlString: String, _ method: HTTPMethod = .post, params: [String : Any]?, model: T.Type, completion: ((_ response: APIResponse<T>)->())?) {
        guard let url = URL(string: self.buildURL(urlString, params: params)) else {
            completion?(self.decodableData(response: nil, err: Utility.getErrorWith(msg: ErrorMessages.invalidURL.rawValue)))
            return
        }
        Utility.isConnectedToNetwork { (isConnected) in
            if isConnected {
                var request = URLRequest(url: url)
                request.httpMethod = method.rawValue
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                let session = URLSession.shared
                let task = session.dataTask(with: request) { (data, response, error)  in
                    if let handler = completion {
                        if let data = data {
                           do {
                                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                                handler(self.decodableData(response: json, err: error))
                           } catch let err {
                                handler(self.decodableData(response: nil, err: err))
                               print("error")
                           }
                        } else {
                            handler(self.decodableData(response: nil, err: error))
                        }
                    }
                }
                task.resume()
            } else {
                completion?(self.decodableData(response: nil, err: Utility.getErrorWith(msg: ErrorMessages.noInternet.rawValue)))
            }
        }
    }
    private func buildURL(_ urlString: String, params: [String: Any]?) -> String {
        var completeUrl = urlString
        if let params = params {
            for (key, value) in params {
                completeUrl.append("\(key)=\(value)&")
            }
        }
        return completeUrl
    }
    private func decodableData<T: Codable>(response: Any?, err: Error?) -> APIResponse<T> {
        var res = APIResponse<T>(list: [], success: false, message: "")
        if let objJson = response as? [String: Any] {
            if let arr = objJson[ResponseKeys.list] as? Array<Any>, arr.count > 0 {
                return self.getDecodedData(input: arr)
            } else {
                return self.getDecodedData(input: [objJson])
            }
        } else if let objJson = response as? [Any] {
            return self.getDecodedData(input: objJson)
        } else {
            res.message = err?.localizedDescription ?? ErrorMessages.unknownError.rawValue
            res.success = false
            res.list = nil
        }
        return res
    }
    private func getDecodedData<T: Codable>(input: Any) -> APIResponse<T>  {
        var res = APIResponse<T>(list: [], success: false, message: "")
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: input, options: .prettyPrinted)
            let decoder = JSONDecoder()
            let decodedValue = try decoder.decode([T].self, from: jsonData)
            res.list = decodedValue
            res.success = true
            res.message = StaticStrings.found
        } catch let error {
            res.message = error.localizedDescription
        }
        return res
    }
    func fetchDataFromLocalJson<T: Codable>(fileName: String, model: T.Type, completion: @escaping (_ response: APIResponse<T>) -> Void) {
        do {
            if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let json = try JSONSerialization.jsonObject(with: data) as? [Any]
                return completion(self.decodableData(response: json, err: nil))
            } else {
                return completion(self.decodableData(response: nil, err: nil))
            }
        } catch let error {
            return completion(self.decodableData(response: nil, err: error))
        }
    }
    func getLocationFromCoordinates(_ latitude: Double, _ longitude: Double, completionHandler: @escaping ((String, String, String)->Void)) {
        let ceo: CLGeocoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
            guard let placeMark = placemarks?.first else {
                completionHandler("", "", "")
                return
            }
                completionHandler(placeMark.locality ?? "", placeMark.country ?? "", placeMark.postalCode ?? "")
        })
    }
}
