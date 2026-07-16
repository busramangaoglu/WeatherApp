
import SwiftUI
import CoreLocation

struct WeatherView: View {
    
    @StateObject private var viewModel = WeatherViewModel()
    @StateObject private var locationManager = LocationManager()
    
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
                        .scaleEffect(Constants.progressViewScale)
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
            .task {
                locationManager.requestLocation()
            }
            .onChange(of: locationManager.location) { _, newLocation in
                guard let newLocation else {
                    return
                }

                print(
                    "Latitude:",
                    newLocation.coordinate.latitude
                )

                print(
                    "Longitude:",
                    newLocation.coordinate.longitude
                )

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
        VStack(
            spacing: Constants.weatherContentSpacing
        ) {
            Text(locationManager.cityName)
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
                Image(
                    systemName: AppImages.WeatherView.sunMaxFill
                )
                .font(
                    .system(size: Constants.currentWeatherIconSize)
                )
                .foregroundStyle(
                    .white.opacity(Constants.currentWeatherIconOpacity)
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

            Text(AppStrings.Forecast.condition)
                .font(
                    .system(
                        size: Constants.conditionFontSize,
                        weight: .regular
                    )
                )
                .foregroundStyle(
                    .white.opacity(Constants.conditionOpacity)
                )

            HStack(
                spacing: Constants.highLowTemperatureSpacing
            ) {
                Text(
                    "\(AppStrings.Forecast.highPrefix)\(maximumTemperature)°"
                )
                .font(
                    .system(
                        size: Constants.highLowTemperatureFontSize,
                        weight: .regular
                    )
                )
                .foregroundStyle(
                    .white.opacity(Constants.highLowTemperatureOpacity)
                )

                Text(
                    "\(AppStrings.Forecast.lowPrefix)\(minimumTemperature)°"
                )
                .font(
                    .system(
                        size: Constants.highLowTemperatureFontSize,
                        weight: .regular
                    )
                )
                .foregroundStyle(
                    .white.opacity(Constants.highLowTemperatureOpacity)
                )
            }
        }
    }

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
                    .white.opacity(Constants.hourlyHeaderTextOpacity)
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
                        .white.opacity(Constants.hourlyDetailsOpacity)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(
            .horizontal,
            Constants.hourlyHeaderHorizontalPadding
        )
    }

    @ViewBuilder
    private func hourlyForecastList() -> some View {
        ScrollView(
            .horizontal,
            showsIndicators: false
        ) {
            LazyHStack(
                spacing: Constants.hourlyCardSpacing
            ) {
                ForEach(viewModel.hourlyWeatherList) { hourlyWeather in
                    RoundedRectangle(
                        cornerRadius: Constants.hourlyCardCornerRadius
                    )
                    .fill(
                        .white.opacity(Constants.hourlyCardBackgroundOpacity)
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
                                .white.opacity(Constants.hourlyWeatherIconOpacity)
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
}

private enum Constants {
    
    // MARK: - Default Values
    
    static let defaultTemperature: Double = 0
    
    // MARK: - Loading
    
    static let progressViewScale: CGFloat = 1.5
    
    // MARK: - Main Layout
    
    static let mainVStackSpacing: CGFloat = 0
    static let mainContentTopPadding: CGFloat = 32
    static let hourlyHeaderTopPadding: CGFloat = 32
    static let hourlyListTopPadding: CGFloat = 12
    
    // MARK: - Weather Content
    
    static let weatherContentSpacing: CGFloat = 8
    
    static let cityNameFontSize: CGFloat = 34
    
    static let currentWeatherSpacing: CGFloat = 8
    static let currentWeatherIconSize: CGFloat = 80
    static let currentWeatherIconOpacity: Double = 0.6
    static let currentTemperatureFontSize: CGFloat = 96
    
    static let conditionFontSize: CGFloat = 28
    static let conditionOpacity: Double = 0.9
    
    static let highLowTemperatureSpacing: CGFloat = 30
    static let highLowTemperatureFontSize: CGFloat = 20
    static let highLowTemperatureOpacity: Double = 0.8
    
    // MARK: - Hourly Forecast Header
    
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

#Preview {
    WeatherView()
}


