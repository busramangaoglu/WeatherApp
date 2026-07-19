import SwiftUI

struct SelectedCityWeatherView: View {

    let city: NearbyCity

    @StateObject private var viewModel = WeatherViewModel()

    private var currentTemperature: Int {
        Int(
            viewModel.weatherResponse?
                .current
                .temperature
                .rounded() ?? Constants.defaultTemperature
        )
    }

    private var maximumTemperature: Int {
        Int(
            viewModel.weatherResponse?
                .daily
                .maximumTemperatures
                .first?
                .rounded() ?? Constants.defaultTemperature
        )
    }

    private var minimumTemperature: Int {
        Int(
            viewModel.weatherResponse?
                .daily
                .minimumTemperatures
                .first?
                .rounded() ?? Constants.defaultTemperature
        )
    }

    private var weatherCode: Int {
        viewModel.weatherResponse?
            .current
            .weatherCode ?? Constants.defaultWeatherCode
    }

    var body: some View {
        ZStack {
            BackgroundLineerGradient(
                startPoint: .bottom,
                endPoint: .top
            )

            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
                    .scaleEffect(Constants.progressViewScale)

            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(
                        .system(
                            size: Constants.errorTextFontSize
                        )
                    )
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(
                        .horizontal,
                        Constants.errorTextHorizontalPadding
                    )

            } else {
                VStack(
                    spacing: Constants.mainVStackSpacing
                ) {
                    weatherContent()

                    hourlyForecastHeader()
                        .padding(
                            .top,
                            Constants.hourlyHeaderTopPadding
                        )

                    hourlyForecastList()
                        .padding(
                            .top,
                            Constants.hourlyListTopPadding
                        )

                    Spacer()
                }
                .padding(
                    .top,
                    Constants.mainContentTopPadding
                )
            }
        }
        .navigationTitle(city.city)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .task {
            await viewModel.fetchWeather(
                latitude: city.latitude,
                longitude: city.longitude
            )
        }
    }

    // MARK: - Weather Content

    @ViewBuilder
    private func weatherContent() -> some View {
        VStack(
            spacing: Constants.weatherContentSpacing
        ) {
            Text(city.city)
                .font(
                    .system(
                        size: Constants.cityNameFontSize,
                        weight: .semibold
                    )
                )
                .foregroundStyle(.white)

            HStack(
                spacing: Constants.currentWeatherSpacing
            ) {
                Image(systemName: weatherIcon)
                    .font(
                        .system(
                            size: Constants.currentWeatherIconSize
                        )
                    )
                    .foregroundStyle(
                        .white.opacity(
                            Constants.currentWeatherIconOpacity
                        )
                    )

                Text("\(currentTemperature)°")
                    .font(
                        .system(
                            size: Constants.currentTemperatureFontSize,
                            weight: .ultraLight
                        )
                    )
                    .foregroundStyle(.white)
            }

            Text(weatherCondition)
                .font(
                    .system(
                        size: Constants.conditionFontSize,
                        weight: .regular
                    )
                )
                .foregroundStyle(
                    .white.opacity(
                        Constants.conditionOpacity
                    )
                )

            HStack(
                spacing: Constants.highLowTemperatureSpacing
            ) {
                Text(
                    "\(AppStrings.Forecast.highPrefix)\(maximumTemperature)°"
                )

                Text(
                    "\(AppStrings.Forecast.lowPrefix)\(minimumTemperature)°"
                )
            }
            .font(
                .system(
                    size: Constants.highLowTemperatureFontSize,
                    weight: .regular
                )
            )
            .foregroundStyle(
                .white.opacity(
                    Constants.highLowTemperatureOpacity
                )
            )
        }
    }

    // MARK: - Hourly Forecast Header

    @ViewBuilder
    private func hourlyForecastHeader() -> some View {
        HStack {
            Text(AppStrings.Forecast.hourly)
                .font(
                    .system(
                        size: Constants.hourlyHeaderFontSize,
                        weight: .semibold
                    )
                )
                .foregroundStyle(
                    .white.opacity(
                        Constants.hourlyHeaderTextOpacity
                    )
                )

            Spacer()

            NavigationLink {
                HourlyForecastView(
                    viewModel: viewModel
                )
            } label: {
                Text(AppStrings.Forecast.details)
                    .font(
                        .system(
                            size: Constants.hourlyDetailsFontSize,
                            weight: .regular
                        )
                    )
                    .foregroundStyle(
                        .white.opacity(
                            Constants.hourlyDetailsOpacity
                        )
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(
            .horizontal,
            Constants.hourlyHeaderHorizontalPadding
        )
    }

    // MARK: - Hourly Forecast List

    @ViewBuilder
    private func hourlyForecastList() -> some View {
        ScrollView(
            .horizontal,
            showsIndicators: false
        ) {
            LazyHStack(
                spacing: Constants.hourlyCardSpacing
            ) {
                ForEach(
                    viewModel.hourlyWeatherList
                ) { hourlyWeather in
                    hourlyForecastCard(
                        for: hourlyWeather
                    )
                }
            }
            .padding(
                .horizontal,
                Constants.hourlyListHorizontalPadding
            )
        }
        .frame(
            height: Constants.hourlyListHeight
        )
    }

    // MARK: - Hourly Forecast Card

    @ViewBuilder
    private func hourlyForecastCard(
        for hourlyWeather: HourlyWeatherModel
    ) -> some View {
        RoundedRectangle(
            cornerRadius: Constants.hourlyCardCornerRadius
        )
        .fill(
            .white.opacity(
                Constants.hourlyCardBackgroundOpacity
            )
        )
        .frame(
            width: Constants.hourlyCardWidth,
            height: Constants.hourlyCardHeight
        )
        .overlay {
            VStack(
                spacing: Constants.hourlyCardContentSpacing
            ) {
                Text(hourlyWeather.time)
                    .font(
                        .system(
                            size: Constants.hourlyTimeFontSize,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(.white)

                Image(
                    systemName: hourlyWeather.type.icon
                )
                .font(
                    .system(
                        size: Constants.hourlyWeatherIconSize
                    )
                )
                .foregroundStyle(
                    .white.opacity(
                        Constants.hourlyWeatherIconOpacity
                    )
                )

                Text("\(hourlyWeather.temperature)°")
                    .font(
                        .system(
                            size: Constants.hourlyTemperatureFontSize,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.white)
            }
        }
    }

    // MARK: - Weather Icon

    private var weatherIcon: String {
        switch weatherCode {
        case 0:
            return AppWeather.WeatherIcon.sunny

        case 1, 2:
            return AppWeather.WeatherIcon.partlyCloudy

        case 3:
            return AppWeather.WeatherIcon.cloudy

        case 45, 48:
            return AppWeather.WeatherIcon.foggy

        case 51, 53, 55, 56, 57:
            return AppWeather.WeatherIcon.drizzle

        case 61, 63, 65, 66, 67:
            return AppWeather.WeatherIcon.rainy

        case 71, 73, 75, 77:
            return AppWeather.WeatherIcon.snowy

        case 80, 81, 82:
            return AppWeather.WeatherIcon.heavyRain

        case 85, 86:
            return AppWeather.WeatherIcon.snowy

        case 95, 96, 99:
            return AppWeather.WeatherIcon.thunderstorm

        default:
            return AppWeather.WeatherIcon.cloudy
        }
    }

    // MARK: - Weather Condition

    private var weatherCondition: String {
        switch weatherCode {
        case 0:
            return AppWeather.Weather.clearSky
            
        case 1:
            return AppWeather.Weather.mostlyClear

        case 2:
            return AppWeather.Weather.partlyCloudy

        case 3:
            return AppWeather.Weather.overcast

        case 45, 48:
            return AppWeather.Weather.foggy

        case 51, 53, 55, 56, 57:
            return AppWeather.Weather.drizzle

        case 61, 63, 65, 66, 67:
            return AppWeather.Weather.rainy

        case 71, 73, 75, 77:
            return AppWeather.Weather.snowy

        case 80, 81, 82:
            return AppWeather.Weather.rainShowers

        case 85, 86:
            return AppWeather.Weather.snowShowers

        case 95, 96, 99:
            return AppWeather.Weather.thunderstorm

        default:
            return AppWeather.Weather.unknown
        }
    }
}

private enum Constants {

    // MARK: - Default Values

    static let defaultTemperature: Double = 0
    static let defaultWeatherCode: Int = 0

    // MARK: - Loading

    static let progressViewScale: CGFloat = 1.5

    // MARK: - Error

    static let errorTextFontSize: CGFloat = 17
    static let errorTextHorizontalPadding: CGFloat = 24

    // MARK: - Main Layout

    static let mainVStackSpacing: CGFloat = 0
    static let mainContentTopPadding: CGFloat = 24

    // MARK: - Weather Content

    static let weatherContentSpacing: CGFloat = 8

    static let cityNameFontSize: CGFloat = 34

    static let currentWeatherSpacing: CGFloat = 16
    static let currentWeatherIconSize: CGFloat = 70
    static let currentWeatherIconOpacity: Double = 0.7
    static let currentTemperatureFontSize: CGFloat = 96

    static let conditionFontSize: CGFloat = 28
    static let conditionOpacity: Double = 0.9

    static let highLowTemperatureSpacing: CGFloat = 30
    static let highLowTemperatureFontSize: CGFloat = 20
    static let highLowTemperatureOpacity: Double = 0.8

    // MARK: - Hourly Forecast Header

    static let hourlyHeaderTopPadding: CGFloat = 32
    static let hourlyListTopPadding: CGFloat = 12

    static let hourlyHeaderFontSize: CGFloat = 18
    static let hourlyHeaderTextOpacity: Double = 0.7

    static let hourlyDetailsFontSize: CGFloat = 18
    static let hourlyDetailsOpacity: Double = 0.7

    static let hourlyHeaderHorizontalPadding: CGFloat = 24

    // MARK: - Hourly Forecast List

    static let hourlyCardSpacing: CGFloat = 16
    static let hourlyListHorizontalPadding: CGFloat = 24
    static let hourlyListHeight: CGFloat = 160

    // MARK: - Hourly Forecast Card

    static let hourlyCardCornerRadius: CGFloat = 20
    static let hourlyCardBackgroundOpacity: Double = 0.2
    static let hourlyCardWidth: CGFloat = 100
    static let hourlyCardHeight: CGFloat = 160
    static let hourlyCardContentSpacing: CGFloat = 18

    static let hourlyTimeFontSize: CGFloat = 18

    static let hourlyWeatherIconSize: CGFloat = 32
    static let hourlyWeatherIconOpacity: Double = 0.6

    static let hourlyTemperatureFontSize: CGFloat = 28
}
