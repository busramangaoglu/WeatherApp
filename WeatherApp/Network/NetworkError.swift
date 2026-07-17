//
//  NetworkError.swift
//  WeatherApp
//
//  Created by Büşra Mangaoğlu on 14.07.2026.
//
import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidStatusCode(Int)
    case decodingError
    case requestFailed(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Geçersiz URL."

        case .invalidResponse:
            return "Sunucudan geçersiz yanıt alındı."

        case .invalidStatusCode:
            return "Sunucu başarılı olmayan bir durum kodu döndürdü."

        case .decodingError:
            return "Veriler okunamadı."

        case .requestFailed(let error):
            return "İstek başarısız oldu: \(error.localizedDescription)"
        }
    }
}
