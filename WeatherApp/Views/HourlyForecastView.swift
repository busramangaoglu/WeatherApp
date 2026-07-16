import SwiftUI

struct HourlyForecastView: View {
    
    @ObservedObject var viewModel: WeatherViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            BackgroundLineerGradient(
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(spacing: Constants.mainVStackSpacing) {
                hourlyForecastHeader()
                
                ScrollView {
                    LazyVStack(
                        spacing: Constants.scrollContentSpacing
                    ) {
                        currentWeatherCard()
                        hourlyForecastList()
                    }
                    .padding(
                        .horizontal,
                        Constants.scrollHorizontalPadding
                    )
                    .padding(
                        .top,
                        Constants.scrollTopPadding
                    )
                    .padding(
                        .bottom,
                        Constants.scrollBottomPadding
                    )
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
    
    @ViewBuilder
    private func hourlyForecastHeader() -> some View {
        ZStack {
            Text(AppStrings.Forecast.hourlyTitle)
                .font(
                    .system(
                        size: Constants.headerTitleFontSize,
                        weight: .semibold
                    )
                )
                .foregroundStyle(.white)
            
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(
                        systemName: AppImages.HourlyForecast.chevronLeft
                    )
                    .font(
                        .system(
                            size: Constants.headerBackIconSize,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(.white)
                }
                
                Spacer()
            }
            .padding(
                .horizontal,
                Constants.headerHorizontalPadding
            )
        }
        .frame(
            height: Constants.headerHeight
        )
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(
                    .white.opacity(Constants.headerDividerOpacity)
                )
                .frame(
                    height: Constants.headerDividerHeight
                )
        }
    }
    
    @ViewBuilder
    private func currentWeatherCard() -> some View {
        RoundedRectangle(
            cornerRadius: Constants.currentCardCornerRadius
        )
        .fill(
            .white.opacity(Constants.currentCardBackgroundOpacity)
        )
        .frame(
            height: Constants.currentCardHeight
        )
        .overlay {
            VStack(
                spacing: Constants.currentCardContentSpacing
            ) {
                Text(AppStrings.Forecast.currently)
                    .font(
                        .system(
                            size: Constants.currentlyFontSize,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(
                        .white.opacity(Constants.currentlyTextOpacity)
                    )
                
                HStack(
                    spacing: Constants.currentWeatherMainSpacing
                ) {
                    Image(
                        systemName: AppImages.HourlyForecast.sunMaxFill
                    )
                    .font(
                        .system(size: Constants.currentWeatherIconSize)
                    )
                    .foregroundStyle(.white)
                    
                    Text("\(currentTemperature)°")
                        .font(
                            .system(
                                size: Constants.currentTemperatureFontSize,
                                weight: .regular
                            )
                        )
                        .foregroundStyle(.white)
                }
                
                HStack(
                    spacing: Constants.currentConditionSpacing
                ) {
                    Text(
                        "\(AppStrings.Forecast.currentCondition) • " +
                        "\(AppStrings.Forecast.highPrefix)\(maximumTemperature)° " +
                        "\(AppStrings.Forecast.lowPrefix)\(minimumTemperature)°"
                    )
                }
                .font(
                    .system(
                        size: Constants.currentConditionFontSize,
                        weight: .regular
                    )
                )
                .foregroundStyle(
                    .white.opacity(Constants.currentConditionOpacity)
                )
            }
        }
        .overlay {
            RoundedRectangle(
                cornerRadius: Constants.currentCardCornerRadius
            )
            .stroke(
                .white.opacity(Constants.currentCardStrokeOpacity),
                lineWidth: Constants.currentCardStrokeWidth
            )
        }
    }
    
    @ViewBuilder
    private func hourlyForecastList() -> some View {
        LazyVStack(
            spacing: Constants.hourlyListSpacing
        ) {
            ForEach(viewModel.hourlyWeatherList) { hourlyWeather in
                hourlyForecastRow(for: hourlyWeather)
            }
        }
    }
    
    @ViewBuilder
    private func hourlyForecastRow(
        for hourlyWeather: HourlyWeatherModel
    ) -> some View {
        RoundedRectangle(
            cornerRadius: Constants.hourlyRowCornerRadius
        )
        .fill(
            .white.opacity(Constants.hourlyRowBackgroundOpacity)
        )
        .frame(
            height: Constants.hourlyRowHeight
        )
        .overlay {
            HStack {
                VStack(
                    alignment: .leading,
                    spacing: Constants.hourlyRowTextSpacing
                ) {
                    Text(hourlyWeather.time)
                        .font(
                            .system(
                                size: Constants.hourlyTimeFontSize,
                                weight: .semibold
                            )
                        )
                        .foregroundStyle(.white)
                    
                    Text(
                        "\(Int(hourlyWeather.precipitation ?? Constants.defaultPrecipitation))% prec."
                    )
                    .font(
                        .system(
                            size: Constants.precipitationFontSize,
                            weight: .regular
                        )
                    )
                    .foregroundStyle(
                        .white.opacity(Constants.precipitationOpacity)
                    )
                }
                
                Spacer()
                
                HStack(
                    spacing: Constants.hourlyWeatherInfoSpacing
                ) {
                    Image(systemName: hourlyWeather.type.icon)
                        .font(
                            .system(size: Constants.hourlyWeatherIconSize)
                        )
                        .foregroundStyle(.white)
                    
                    Text(hourlyWeather.type.name)
                        .font(
                            .system(
                                size: Constants.hourlyWeatherNameFontSize,
                                weight: .regular
                            )
                        )
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                Text("\(hourlyWeather.temperature)°")
                    .font(
                        .system(
                            size: Constants.hourlyTemperatureFontSize,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(.white)
            }
            .padding(
                .horizontal,
                Constants.hourlyRowHorizontalPadding
            )
        }
        .overlay {
            RoundedRectangle(
                cornerRadius: Constants.hourlyRowCornerRadius
            )
            .stroke(
                .white.opacity(Constants.hourlyRowStrokeOpacity),
                lineWidth: Constants.hourlyRowStrokeWidth
            )
        }
    }
    
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
}

private enum Constants {
    
    // MARK: - Main Layout
    
    static let mainVStackSpacing: CGFloat = 0
    
    static let scrollContentSpacing: CGFloat = 16
    static let scrollHorizontalPadding: CGFloat = 16
    static let scrollTopPadding: CGFloat = 24
    static let scrollBottomPadding: CGFloat = 24
    
    // MARK: - Header
    
    static let headerTitleFontSize: CGFloat = 22
    static let headerBackIconSize: CGFloat = 22
    static let headerHorizontalPadding: CGFloat = 16
    static let headerHeight: CGFloat = 64
    
    static let headerDividerOpacity: Double = 0.25
    static let headerDividerHeight: CGFloat = 1
    
    // MARK: - Current Weather Card
    
    static let currentCardCornerRadius: CGFloat = 20
    static let currentCardBackgroundOpacity: Double = 0.15
    static let currentCardHeight: CGFloat = 200
    static let currentCardContentSpacing: CGFloat = 18
    
    static let currentlyFontSize: CGFloat = 22
    static let currentlyTextOpacity: Double = 0.8
    
    static let currentWeatherMainSpacing: CGFloat = 12
    static let currentWeatherIconSize: CGFloat = 60
    static let currentTemperatureFontSize: CGFloat = 72
    
    static let currentConditionSpacing: CGFloat = 6
    static let currentConditionFontSize: CGFloat = 20
    static let currentConditionOpacity: Double = 0.9
    
    static let currentCardStrokeOpacity: Double = 0.35
    static let currentCardStrokeWidth: CGFloat = 1
    
    // MARK: - Hourly Forecast List
    
    static let hourlyListSpacing: CGFloat = 12
    
    // MARK: - Hourly Forecast Row
    
    static let hourlyRowCornerRadius: CGFloat = 18
    static let hourlyRowBackgroundOpacity: Double = 0.18
    static let hourlyRowHeight: CGFloat = 90
    static let hourlyRowHorizontalPadding: CGFloat = 20
    
    static let hourlyRowTextSpacing: CGFloat = 2
    static let hourlyTimeFontSize: CGFloat = 24
    
    static let precipitationFontSize: CGFloat = 18
    static let precipitationOpacity: Double = 0.7
    static let defaultPrecipitation: Double = 0
    
    static let hourlyWeatherInfoSpacing: CGFloat = 12
    static let hourlyWeatherIconSize: CGFloat = 32
    static let hourlyWeatherNameFontSize: CGFloat = 20
    
    static let hourlyTemperatureFontSize: CGFloat = 28
    
    static let hourlyRowStrokeOpacity: Double = 0.3
    static let hourlyRowStrokeWidth: CGFloat = 1
    
    // MARK: - Default Values
    
    static let defaultTemperature: Double = 0
}

#Preview {
    NavigationStack {
        HourlyForecastView(
            viewModel: WeatherViewModel()
        )
    }
}


