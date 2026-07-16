//
//  NetworkError.swift
//  WeatherApp
//
//  Created by Büşra Mangaoğlu on 14.07.2026.
//
import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidStatusCode
    case decodingError
}
