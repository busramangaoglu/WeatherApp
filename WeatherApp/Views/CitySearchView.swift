import SwiftUI

struct CitySearchView: View {

    @State private var searchText = ""

    private var filteredCities: [CityModel] {
        if searchText.isEmpty {
            return CityData.cityList
        }

        return CityData.cityList.filter { city in
            city.city.localizedCaseInsensitiveContains(searchText) ||
            city.country.localizedCaseInsensitiveContains(searchText)
        }
    }

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
                            .white.opacity(Constants.matchingCitiesOpacity)
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

                    ScrollView {
                        LazyVStack(
                            spacing: Constants.cityListSpacing
                        ) {
                            ForEach(filteredCities) { city in
                                cityCard(for: city)
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
                        .searchable(
                            text: $searchText,
                            placement: .navigationBarDrawer(
                                displayMode: .always
                            ),
                            prompt: AppStrings.Search.searchCity
                        )
                    }
                }
                .padding(
                    .top,
                    Constants.contentTopPadding
                )
            }
        }
    }

    @ViewBuilder
    private func searchBar() -> some View {
        HStack(
            spacing: Constants.searchBarContentSpacing
        ) {
            Image(
                systemName: AppImages.Search.magnifyingGlass
            )
            .font(
                .system(size: Constants.searchIconSize)
            )
            .foregroundStyle(.gray)

            TextField(
                AppStrings.Search.searchCity,
                text: $searchText
            )
            .font(
                .system(size: Constants.searchTextFontSize)
            )
            .foregroundStyle(.black)
        }
        .padding(
            .horizontal,
            Constants.searchBarInnerHorizontalPadding
        )
        .frame(
            height: Constants.searchBarHeight
        )
        .background(
            .white.opacity(Constants.searchBarBackgroundOpacity)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: Constants.searchBarCornerRadius
            )
        )
        .padding(
            .horizontal,
            Constants.searchBarOuterHorizontalPadding
        )
    }

    @ViewBuilder
    private func cityCard(for city: CityModel) -> some View {
        RoundedRectangle(
            cornerRadius: Constants.cityCardCornerRadius
        )
        .fill(
            .white.opacity(Constants.cityCardBackgroundOpacity)
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
                        .white.opacity(Constants.countryNameOpacity)
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
                .white.opacity(Constants.cityCardStrokeOpacity),
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
    static let cityListBottomPadding: CGFloat = 16

    // MARK: - Search Bar

    static let searchBarContentSpacing: CGFloat = 12
    static let searchIconSize: CGFloat = 20
    static let searchTextFontSize: CGFloat = 18
    static let searchBarInnerHorizontalPadding: CGFloat = 16
    static let searchBarHeight: CGFloat = 56
    static let searchBarBackgroundOpacity: Double = 0.4
    static let searchBarCornerRadius: CGFloat = 16
    static let searchBarOuterHorizontalPadding: CGFloat = 16

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
}

#Preview {
    CitySearchView()
}
