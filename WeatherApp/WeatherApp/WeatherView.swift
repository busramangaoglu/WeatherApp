//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Büşra Mangaoğlu on 10.07.2026.
//

import SwiftUI

struct WeatherView: View {
    var body: some View {
        ZStack {
            BackgroundLineerGradient()
            
            VStack {
                weatherContent
                    .padding(.top, 32)

                Spacer()
            }
           
        }
    }

    @ViewBuilder
    private var weatherContent: some View {
        VStack(spacing: 8) {
            Text("Kastamonu")
                .font(.system(size: 34, weight: .semibold))
                .foregroundStyle(.white)

            HStack(spacing: 8) {
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.white.opacity(0.6))

                Text("24°")
                    .font(.system(size: 96, weight: .ultraLight))
                    .foregroundStyle(.white)
            }
            Text("Mostly Sunny")
                .font(.system(size: 28, weight: .regular))
                .foregroundStyle(.white.opacity(0.9))
            
            HStack(spacing: 30) {
                    Text("H:26°")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundStyle(.white.opacity(0.8))

                    Text("L:18°")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundStyle(.white.opacity(0.8))
                }
        }
    }
}

#Preview {
    WeatherView()
}
