//
//  WeatherManager.swift
//  Clima
//
//  Created by Infinity Code on 9/8/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
// API Key
let apiKey = "7de012738620e395f61495bf4675365f"


protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
}


struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)&units=imperial"
    
    // Delegate
    var delegate = WeatherManagerDelegate?
    
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        
        print(urlString)
        performRequest(urlString: urlString)
    }
    
    // Handles Networking Api
    func performRequest(urlString: String) {
        // 1. Create URL
        if let url = URL(string: urlString) {
            
            // 2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
            // 4. Start the task
            task.resume()
        }
        
    }
    
    // Data parser
    func parseJSON(weatherData: Data) -> WeatherModel {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            
            // Data fetching
            let weather = WeatherModel(conditionId: id, name: name, temperature: temp)
            print(weather.conditionaName)
            print(weather.temperatureString)

        } catch {
            print(error)
            return nil
        }
        
    }
    
}
