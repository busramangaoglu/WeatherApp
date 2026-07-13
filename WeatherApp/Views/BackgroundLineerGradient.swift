//
//  DetailBackgroundLineerGradient.swift
//  WeatherApp
//
//  Created by Büşra Mangaoğlu on 13.07.2026.
//

import SwiftUI

struct BackgroundLineerGradient: View {

    let startPoint: UnitPoint
    let endPoint: UnitPoint

    var body: some View {
        LinearGradient(
            colors: [
                Color.purple.opacity(0.4),
                Color.purple
            ],
            startPoint: startPoint,
            endPoint: endPoint
        )
        .ignoresSafeArea()
    }
}
