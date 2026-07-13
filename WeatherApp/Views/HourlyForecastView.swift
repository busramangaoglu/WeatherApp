//
//  HourlyForecastView.swift
//  WeatherApp
//
//  Created by Büşra Mangaoğlu on 13.07.2026.
//

import SwiftUI

struct HourlyForecastView: View {
    var body: some View {
        ZStack {
            BackgroundLineerGradient(startPoint: .top, endPoint: .bottom)
            
            ScrollView {
                LazyVStack(spacing: 16) {
                    currentWeatherCard()
                    
                    hourlyForecastList()
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)
                .padding(.bottom, 24)
            }
        }
    }
    
    @ViewBuilder
    private func currentWeatherCard() -> some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.white.opacity(0.15))
            .frame(height: 200)
            .overlay {
                VStack(spacing: 18) {
                    
                    Text(AppStrings.Forecast.currently)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.8))
                    
                    HStack(spacing: 12) {
                        
                        Image(systemName: "sun.max.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.white)
                        
                        Text("24°")
                            .font(.system(size: 72, weight: .regular))
                            .foregroundStyle(.white)
                    }
                    
                    HStack(spacing: 6) {
                        
                        Text(AppStrings.Forecast.currentCondition)
                        
                        Text("•")
                        
                        Text("H: 26°")
                        
                        Text("L: 18°")
                    }
                    .font(.system(size: 20, weight: .regular))
                    .foregroundStyle(.white.opacity(0.9))
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.white.opacity(0.35), lineWidth: 1)
            }
    }
    
    @ViewBuilder
    private func hourlyForecastList() -> some View {
        LazyVStack(spacing: 12) {
            ForEach(WeatherData.hourlyWeatherList) { hourlyWeather in
                hourlyForecastRow(for: hourlyWeather)
            }
        }
    }
    
    @ViewBuilder
    private func hourlyForecastRow(
        for hourlyWeather: HourlyWeatherModel
    ) -> some View {
        RoundedRectangle(cornerRadius: 18)
            .fill(.white.opacity(0.18))
            .frame(height: 90)
            .overlay {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(hourlyWeather.time)
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.white)

                        Text("\(Int(hourlyWeather.precipitation ?? 0))% prec.")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundStyle(.white.opacity(0.7))
                    }

                    Spacer()

                    HStack(spacing: 12) {
                        Image(systemName: hourlyWeather.type.icon)
                            .font(.system(size: 32))
                            .foregroundStyle(.white)

                        Text(hourlyWeather.type.name)
                            .font(.system(size: 20, weight: .regular))
                            .foregroundStyle(.white)
                    }

                    Spacer()

                    Text("\(hourlyWeather.temperature)°")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 20)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(.white.opacity(0.3), lineWidth: 1)
            }
    }
}
    

#Preview {
    HourlyForecastView()
}
