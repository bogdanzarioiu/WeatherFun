//
//  WeatherModel.swift
//  JustWeather
//
//  Created by Bogdan on 9/29/20.
//  Copyright © 2020 Bogdan Zarioiu. All rights reserved.
//

import Foundation


struct CityName: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
    
}

struct Main: Decodable {
    var temp: Double
    var feels_like: Double
    
}

struct Weather: Decodable {
    let description: String
    let id: Int
}

//weather[0].description
