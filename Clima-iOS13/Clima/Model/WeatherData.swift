//
//  weatherData.swift
//  Clima
//
//  Created by Shilpee Gupta on 28/11/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
struct WeatherData: Codable{
    let name:  String
    let main:  Main
    let weather: [Weather]
}
struct Main:Codable{
    let temp:Double
}
struct Weather:Codable{
    let description: String
    let id: Int
}
