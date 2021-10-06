//
//  ResponseParser.swift
//  Weather
//
//  Created by sheshnath kumar on 10/6/21.
//

import Foundation
import SwiftyXMLParser


enum ParsingError: Error {
    case noInternet, unknown
}

typealias ParsingCompletionHandler = (Result<[WeatherInfo],ParsingError>) -> Void

class ResponseParser {
    
    func parse(response data:Data,completionHandler: @escaping ParsingCompletionHandler)  {
        print("response downloaded")
        let xml = XML.parse(data)
        var weatherInfos:[WeatherInfo] = []
         for time in xml["weatherdata","product","time"] {
            //print(time.attributes["from"])
            //print(time.attributes["to"])
            guard let from = time.attributes["from"] else { return }
            guard let to =  time.attributes["to"] else { return }
            weatherInfos.append(WeatherInfo(from: from, to: to))
         }
        completionHandler(.success(weatherInfos))
    }
    
}

