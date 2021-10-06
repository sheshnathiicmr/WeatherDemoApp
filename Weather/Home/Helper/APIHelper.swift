//
//  APIHelper.swift
//  Weather
//
//  Created by sheshnath kumar on 10/6/21.
//

import Foundation

enum APIRequestError: Error {
    case noInternet, unknown
}

typealias APICompletionHandler = (Result<Data,APIRequestError>) -> Void

class APIHelper {
    
    
    private let baseURL = "https://api.met.no/weatherapi/locationforecast/2.0/classic?"
    
    static let shared = APIHelper()

    func getWeatherInfo(latitude:String, longitude:String, completionHandler: @escaping APICompletionHandler) {
        var request = URLRequest(url: URL(string: "\(self.baseURL)lat=\(latitude)&lon=\(longitude)")!)
            request.httpMethod = "GET"
            let session = URLSession.shared
            session.dataTask(with: request) {data, response, err in
                DispatchQueue.main.async {
                    if let _ = err {
                        completionHandler(.failure(.unknown))
                    }
                    if let responseData = data {
                        completionHandler(.success(responseData))
                    }
                }
            }.resume()
    }
    
}
