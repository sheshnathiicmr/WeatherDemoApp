//
//  WeatherInfo.swift
//  Weather
//
//  Created by sheshnath kumar on 10/6/21.
//

import Foundation

class WeatherInfo {
    
    var from:String!
    var to:String!
    var temperature:String!
    
    init(from:String, to:String, temperature:String) {
        self.from = from
        self.to = to
        self.temperature = temperature
    }
    
}
