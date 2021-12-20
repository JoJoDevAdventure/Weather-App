//
//  WeatherManager.swift
//  Weather App
//
//  Created by Youssef Bhl on 20/12/2021.
//

import Foundation
import CoreLocation

class WeatherManager {
    func getCurrentLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\("c9c2e8cbc5d11440e50eca29bfef11b3")&units=metric") else { fatalError("Missing URL") }
        
        let urlRequeest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequeest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {fatalError("Error fetching data")}
        
        let decoderData = try JSONDecoder().decode(ResponseBody.self, from: data)
        
        return decoderData
    }
}

struct ResponseBody: Decodable {
    var coord: CoordinatesResponse
    var weather: [WeatherResponse]
    var main: MainResponse
    var name: String
    var wind: WindResponse

    struct CoordinatesResponse: Decodable {
        var lon: Double
        var lat: Double
    }

    struct WeatherResponse: Decodable {
        var id: Double
        var main: String
        var description: String
        var icon: String
    }

    struct MainResponse: Decodable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Double
    }
    
    struct WindResponse: Decodable {
        var speed: Double
        var deg: Double
    }
}

extension ResponseBody.MainResponse {
    var feelsLike: Double { return feels_like }
    var tempMin: Double { return temp_min }
    var tempMax: Double { return temp_max }
}
