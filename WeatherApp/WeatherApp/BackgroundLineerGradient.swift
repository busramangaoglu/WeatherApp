//
//  Background.swift
//  WeatherApp
//
//  Created by Büşra Mangaoğlu on 10.07.2026.
//

import SwiftUI

struct BackgroundLineerGradient: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color.purple.opacity(0.4),
                Color.purple
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}


