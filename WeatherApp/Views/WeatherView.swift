import SwiftUI

struct WeatherView: View {

    private let weather = WeatherModel(
        cityName: AppStrings.City.name,
        conditionType: .sunny,
        temperature: 24,
        conditionText: AppStrings.Forecast.condition,
        highTemp: 26,
        lowTemp: 18,
    )

    private let hourlyWeatherList: [HourlyWeatherModel] = [
        HourlyWeatherModel(
            time: "Now",
            type: .sunny,
            temperature: 24
        ),
        HourlyWeatherModel(
            time: "1PM",
            type: .sunny,
            temperature: 25
        ),
        HourlyWeatherModel(
            time: "2PM",
            type: .sunny,
            temperature: 26
        ),
        HourlyWeatherModel(
            time: "3PM",
            type: .partlyCloudy,
            temperature: 26
        ),
        HourlyWeatherModel(
            time: "4PM",
            type: .partlyCloudy,
            temperature: 25
        ),
        HourlyWeatherModel(
            time: "5PM",
            type: .cloudy,
            temperature: 24
        ),
        HourlyWeatherModel(
            time: "6PM",
            type: .cloudy,
            temperature: 23
        ),
        HourlyWeatherModel(
            time: "7PM",
            type: .partlyCloudy,
            temperature: 22
        ),
        HourlyWeatherModel(
            time: "8PM",
            type: .moonStars,
            temperature: 21
        ),
        HourlyWeatherModel(
            time: "9PM",
            type: .moon,
            temperature: 20
        )
    ]

    var body: some View {
        ZStack {
            BackgroundLineerGradient()

            VStack(spacing: 0) {
                weatherContent(for: weather)

                hourlyForecastHeader()
                    .padding(.top, 32)

                hourlyForecastList()
                    .padding(.top, 12)

                Spacer()
            }
            .padding(.top, 32)
        }
    }

    @ViewBuilder
    private func weatherContent(for weather: WeatherModel) -> some View {
        VStack(spacing: 8) {
            Text(weather.cityName)
                .font(.system(size: 34, weight: .semibold))
                .foregroundStyle(.white)

            HStack(spacing: 8) {
                Image(systemName: weather.conditionType.icon)
                    .font(.system(size: 80))
                    .foregroundStyle(.white.opacity(0.6))

                Text("\(weather.temperature)°")
                    .font(.system(size: 96, weight: .ultraLight))
                    .foregroundStyle(.white)
            }

            Text(weather.conditionText)
                .font(.system(size: 28, weight: .regular))
                .foregroundStyle(.white.opacity(0.9))

            HStack(spacing: 30) {
                Text("\(AppStrings.Forecast.highPrefix)\(weather.highTemp)°")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundStyle(.white.opacity(0.8))

                Text("\(AppStrings.Forecast.lowPrefix)\(weather.lowTemp)°")
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

            Text(AppStrings.Forecast.details)
                .font(.system(size: 18, weight: .regular))
                .foregroundStyle(.white.opacity(0.7))
        }
        .padding(.horizontal, 24)
    }

    @ViewBuilder
    private func hourlyForecastList() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(hourlyWeatherList) { hourlyWeather in
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
