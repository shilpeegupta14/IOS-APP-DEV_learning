//
//  weatherManager.swift
//  Clima
//
//  Created by Shilpee Gupta on 27/11/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate{
    func didUpdateWeather(_weatherManager:WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    let weatherURL="https://api.openweathermap.org/data/2.5/weather?appid=e3cd6e09e2213638c9ba7f35b10c43d4&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString="\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    func fetchWeather(longitude: CLLocationDegrees,latitude: CLLocationDegrees){
        let urlString="\(weatherURL)&lon=\(longitude)&lat=\(latitude)"
        performRequest(with: urlString)
    }
  
    func performRequest(with urlString: String){
        //1) create url
        if let url=URL(string: urlString){
            //2) create urlsession
            let session=URLSession(configuration: .default)
            //3)give the session task
            let task=session.dataTask(with: url){ (data,response,error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    if let weather=self.parseJSON(_weatherData: safeData){
                        self.delegate?.didUpdateWeather(_weatherManager: self, weather: weather)
                    }
                }
                //4) start task
            }
            task.resume()
        }
    }
    
    func parseJSON(_weatherData: Data)->WeatherModel?{
        let decoder=JSONDecoder()
        do{
            let decodedData=try decoder.decode(WeatherData.self, from: weatherData)
            let id=decodedData.weather[0].id
            let name=decodedData.name
            let temp=decodedData.main.temp
            
            let weather=WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}

