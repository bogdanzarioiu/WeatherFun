//
//  WeatherManager.swift
//  JustWeather
//
//  Created by Bogdan on 9/29/20.
//  Copyright © 2020 Bogdan Zarioiu. All rights reserved.
//

import Foundation
import CoreLocation

class WeatherManager {
    private let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=your_api_key&units=metric"
    var delegate: WeatherManagerDelegate?
    
    
    func getWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString: urlString)
        
    }
    
    func performRequest(urlString: String) {
        
        //create URL
        if let url = URL(string: urlString) {
            //create a url session
            let session = URLSession(configuration: .default)
            //give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    //TODO: display an alert for the networking error
                    print(error!)
                    return
                }
                if let data = data {
                    if let weather =  self.parseJSON(weatherData: data) {
                        self.delegate?.didUpdateWeather(weather: weather)
                    }
                }
                
                
            }
            //start the task
            task.resume()
        }
        
    }
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CityName.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let cityName = decodedData.name
            
            let weather = WeatherModel(conditionID: id, cityName: cityName, temperature: temp)
            return weather
            
        } catch {
            return nil
        }
        
    }
    
}


protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
}



// lat: 45.46
// long: 9.19




