import SwiftUI
import CoreLocation

struct CitySearchView: View {
    
    @StateObject private var viewModel = CitySearchViewModel()
    @StateObject private var locationManager = LocationManager()
    

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundLineerGradient(
                    startPoint: .bottom,
                    endPoint: .top
                )

                VStack {
                    Text(AppStrings.Search.matchingCities)
                        .font(
                            .system(
                                size: Constants.matchingCitiesFontSize,
                                weight: .semibold
                            )
                        )
                        .foregroundStyle(
                            .white.opacity(
                                Constants.matchingCitiesOpacity
                            )
                        )
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                        .padding(
                            .horizontal,
                            Constants.matchingCitiesHorizontalPadding
                        )
                        .padding(
                            .top,
                            Constants.matchingCitiesTopPadding
                        )

                    cityListContent()
                }
                .padding(
                    .top,
                    Constants.contentTopPadding
                )
                .searchable(
                    text: $viewModel.searchText,
                    placement: .navigationBarDrawer(
                        displayMode: .always
                    ),
                    prompt: AppStrings.Search.searchCity
                )
            }
        }
        .task(id: viewModel.searchText) {
            let query = viewModel.searchText.trimmingCharacters(
                in: .whitespacesAndNewlines
            )

            if query.isEmpty {
                guard let location = locationManager.location else {
                    return
                }

                await viewModel.fetchNearbyCities(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )

                return
            }

            do {
                try await Task.sleep(
                    for: .milliseconds(500)
                )
            } catch {
                return
            }

            await viewModel.searchCities(
                query: query
            )
        }
    }

    // MARK: - City List Content

    @ViewBuilder
    private func cityListContent() -> some View {
        if viewModel.isLoading {
            loadingView()
        } else if let errorMessage = viewModel.errorMessage {
            errorView(message: errorMessage)
        } else if viewModel.cities.isEmpty {
            emptyView()
        } else {
            cityList()
        }
    }

    // MARK: - Loading View

    @ViewBuilder
    private func loadingView() -> some View {
        Spacer()

        ProgressView()
            .tint(.white)
            .scaleEffect(Constants.progressViewScale)

        Spacer()
    }

    // MARK: - Error View

    @ViewBuilder
    private func errorView(message: String) -> some View {
        Spacer()

        VStack(
            spacing: Constants.errorViewSpacing
        ) {
            Image(
                systemName: AppImages.Search.errorIcon
            )
            .font(
                .system(size: Constants.errorIconSize)
            )
            .foregroundStyle(.white)

            Text(message)
                .font(
                    .system(size: Constants.errorTextFontSize)
                )
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            Button {
                Task {
                    await viewModel.fetchNearbyCities(
                        latitude: Constants.defaultLatitude,
                        longitude: Constants.defaultLongitude
                    )
                }
            } label: {
                Text(AppStrings.Search.retry)
                    .font(
                        .system(
                            size: Constants.retryButtonFontSize,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(.purple)
                    .padding(
                        .horizontal,
                        Constants.retryButtonHorizontalPadding
                    )
                    .frame(
                        height: Constants.retryButtonHeight
                    )
                    .background(.white)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius:
                                Constants.retryButtonCornerRadius
                        )
                    )
            }
        }
        .padding(
            .horizontal,
            Constants.errorViewHorizontalPadding
        )

        Spacer()
    }

    // MARK: - Empty View

    @ViewBuilder
    private func emptyView() -> some View {
        Spacer()

        Text(AppStrings.Search.cityNotFound)
            .font(
                .system(size: Constants.emptyTextFontSize)
            )
            .foregroundStyle(.white.opacity(0.8))

        Spacer()
    }

    // MARK: - City List

    @ViewBuilder
    private func cityList() -> some View {
        ScrollView {
            LazyVStack(
                spacing: Constants.cityListSpacing
            ) {
                ForEach(viewModel.cities) { city in
                    NavigationLink {
                        SelectedCityWeatherView(city: city)
                    } label: {
                        cityCard(for: city)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(
                .horizontal,
                Constants.cityListHorizontalPadding
            )
            .padding(
                .top,
                Constants.cityListTopPadding
            )
            .padding(
                .bottom,
                Constants.cityListBottomPadding
            )
        }
    }

    // MARK: - City Card

    @ViewBuilder
    private func cityCard(for city: NearbyCity) -> some View {
        RoundedRectangle(
            cornerRadius: Constants.cityCardCornerRadius
        )
        .fill(
            .white.opacity(
                Constants.cityCardBackgroundOpacity
            )
        )
        .frame(
            height: Constants.cityCardHeight
        )
        .overlay {
            VStack(
                alignment: .leading,
                spacing: Constants.cityCardTextSpacing
            ) {
                Text(city.city)
                    .font(
                        .system(
                            size: Constants.cityNameFontSize,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(.white)

                Text(city.country)
                    .font(
                        .system(
                            size: Constants.countryNameFontSize,
                            weight: .regular
                        )
                    )
                    .foregroundStyle(
                        .white.opacity(
                            Constants.countryNameOpacity
                        )
                    )
            }
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .padding(
                .horizontal,
                Constants.cityCardContentHorizontalPadding
            )
        }
        .overlay {
            RoundedRectangle(
                cornerRadius: Constants.cityCardCornerRadius
            )
            .stroke(
                .white.opacity(
                    Constants.cityCardStrokeOpacity
                ),
                lineWidth: Constants.cityCardStrokeWidth
            )
        }
    }
}

private enum Constants {

    // MARK: - Main Content

    static let contentTopPadding: CGFloat = 16

    // MARK: - Matching Cities Title

    static let matchingCitiesFontSize: CGFloat = 15
    static let matchingCitiesOpacity: Double = 0.7
    static let matchingCitiesHorizontalPadding: CGFloat = 16
    static let matchingCitiesTopPadding: CGFloat = 24

    // MARK: - City List

    static let cityListSpacing: CGFloat = 12
    static let cityListHorizontalPadding: CGFloat = 16
    static let cityListTopPadding: CGFloat = 12
    static let cityListBottomPadding: CGFloat = 100

    // MARK: - Loading

    static let progressViewScale: CGFloat = 1.4

    // MARK: - Error View

    static let errorViewSpacing: CGFloat = 16
    static let errorIconSize: CGFloat = 40
    static let errorTextFontSize: CGFloat = 17
    static let errorViewHorizontalPadding: CGFloat = 24

    // MARK: - Retry Button

    static let retryButtonFontSize: CGFloat = 16
    static let retryButtonHorizontalPadding: CGFloat = 20
    static let retryButtonHeight: CGFloat = 44
    static let retryButtonCornerRadius: CGFloat = 12

    // MARK: - Empty View

    static let emptyTextFontSize: CGFloat = 18

    // MARK: - City Card

    static let cityCardCornerRadius: CGFloat = 20
    static let cityCardBackgroundOpacity: Double = 0.15
    static let cityCardHeight: CGFloat = 120
    static let cityCardTextSpacing: CGFloat = 6
    static let cityNameFontSize: CGFloat = 28
    static let countryNameFontSize: CGFloat = 20
    static let countryNameOpacity: Double = 0.7
    static let cityCardContentHorizontalPadding: CGFloat = 24
    static let cityCardStrokeOpacity: Double = 0.25
    static let cityCardStrokeWidth: CGFloat = 1
    
    // MARK: - Default Location

    static let defaultLatitude: Double = 36.9081
    static let defaultLongitude: Double = 30.6956
}


#Preview {
    CitySearchView()
}
