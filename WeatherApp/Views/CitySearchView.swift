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
                    //                searchBar()
                    
                    Text("MATCHING CITIES")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.7))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.top, 24)
                    
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredCities) { city in
                                cityCard(for: city)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        .padding(.bottom, 16)
                        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search City") {
                            
                        }
                    }
                }
                .padding(.top, 16)
            }
        }
    }

    @ViewBuilder
    private func searchBar() -> some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 20))
                .foregroundStyle(.gray)

            TextField("Search city", text: $searchText)
                .font(.system(size: 18))
                .foregroundStyle(.black)
        }
        .padding(.horizontal, 16)
        .frame(height: 56)
        .background(.white.opacity(0.4))
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private func cityCard(for city: CityModel) -> some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.white.opacity(0.15))
            .frame(height: 120)
            .overlay {
                VStack(alignment: .leading, spacing: 6) {
                    Text(city.city)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(.white)

                    Text(city.country)
                        .font(.system(size: 20, weight: .regular))
                        .foregroundStyle(.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.white.opacity(0.25), lineWidth: 1)
            }
    }
    
    

}

#Preview {
    CitySearchView()
}
