//
//  ContentView.swift
//  Weather App
//
//  Created by Youssef Bhl on 20/12/2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var weather: ResponseBody?
    
    var body: some View {
        VStack {
            
            if let location = locationManager.location {
                if let weather = weather {
                    WeatherView(weather: weather)
                } else {
                        LoadingView()
                        .task {
                            do {
                                weather = try await weatherManager.getCurrentLocation(latitude: location.latitude, longitude: location.longitude)
                            } catch {
                                print("Error Getting weather\(error)")
                            }
                        }
                    }
                } else {
                if locationManager.isLoading {
                    LoadingView()
                } else {
                    WelcomeView()
                        .environmentObject(locationManager)
                }
            }
        }
        .background(Color(hue: 0.668, saturation: 0.689, brightness: 0.354))
        .preferredColorScheme(.dark)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

