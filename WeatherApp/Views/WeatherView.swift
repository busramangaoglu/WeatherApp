import SwiftUI
import CoreLocation

struct WeatherView: View {
    
    @StateObject private var viewModel = WeatherViewModel()
    @StateObject private var locationManager = LocationManager()
    
    private var currentTemperature: Int {
        Int(viewModel.weatherResponse?.current.temperature.rounded() ?? 0)
    }

    private var maximumTemperature: Int {
        Int(
            viewModel.weatherResponse?
                .daily
                .maximumTemperatures
                .first?
                .rounded() ?? 0
        )
    }

    private var minimumTemperature: Int {
        Int(
            viewModel.weatherResponse?
                .daily
                .minimumTemperatures
                .first?
                .rounded() ?? 0
        )
    }
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundLineerGradient(
                    startPoint: .bottom,
                    endPoint: .top
                )

                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(1.5)
                } else {
                    VStack(spacing: 0) {
                        weatherContent()

                        hourlyForecastHeader()
                            .padding(.top, 32)

                        hourlyForecastList()
                            .padding(.top, 12)

                        Spacer()
                    }
                    .padding(.top, 32)
                }
            }
            .task {
                locationManager.requestLocation()
            }
            
            .onChange(of: locationManager.location) { _, newLocation in
                guard let newLocation else {
                    return
                }

                print("Latitude:", newLocation.coordinate.latitude)
                print("Longitude:", newLocation.coordinate.longitude)

                Task {
                    await viewModel.fetchWeather(
                        latitude: newLocation.coordinate.latitude,
                        longitude: newLocation.coordinate.longitude
                    )
                }
            }
        }
    }

    @ViewBuilder
    private func weatherContent() -> some View {
        VStack(spacing: 8) {
            Text(locationManager.cityName)
                .font(.system(size: 34, weight: .semibold))
                .foregroundStyle(.white)

            HStack(spacing: 8) {
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.white.opacity(0.6))

                Text("\(currentTemperature)°")
                    .font(.system(size: 96, weight: .ultraLight))
                    .foregroundStyle(.white)
            }

            Text(AppStrings.Forecast.condition)
                .font(.system(size: 28, weight: .regular))
                .foregroundStyle(.white.opacity(0.9))

            HStack(spacing: 30) {
                Text("\(AppStrings.Forecast.highPrefix)\(maximumTemperature)°")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundStyle(.white.opacity(0.8))

                Text("\(AppStrings.Forecast.lowPrefix)\(minimumTemperature)°")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundStyle(.white.opacity(0.8))
            }
        }
    }

    @ViewBuilder
    private func hourlyForecastHeader() -> some View {
        HStack {
            Text(AppStrings.Forecast.hourly)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white.opacity(0.7))

            Spacer()

            NavigationLink {
                HourlyForecastView(viewModel: viewModel)
            } label: {
                Text(AppStrings.Forecast.details)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundStyle(.white.opacity(0.7))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 24)
    }

    @ViewBuilder
    private func hourlyForecastList() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(viewModel.hourlyWeatherList) { hourlyWeather in
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white.opacity(0.2))
                        .frame(width: 100, height: 160)
                        .overlay {
                            VStack(spacing: 18) {
                                Text(hourlyWeather.time)
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundStyle(.white)

                                Image(systemName: hourlyWeather.type.icon)
                                    .font(.system(size: 32))
                                    .foregroundStyle(.white.opacity(0.6))

                                Text("\(hourlyWeather.temperature)°")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                        }
                }
            }
            .padding(.horizontal, 24)
        }
        .frame(height: 160)
    }

}

#Preview {
    WeatherView()
}
