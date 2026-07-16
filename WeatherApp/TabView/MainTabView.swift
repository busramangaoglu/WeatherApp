//
//  MainTabView.swift
//  WeatherApp
//
//  Created by Büşra Mangaoğlu on 14.07.2026.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        
        TabView {
            WeatherView()
                .tabItem {
                    Image(systemName: AppImages.TabBar.cloudFill)
                        
                }
            CitySearchView()
                .tabItem {
                    Image(systemName: AppImages.TabBar.magnifyingglass)
                }
        }
        .accentColor(Color(.purple))
        
    }
}

#Preview {
    MainTabView()
}
