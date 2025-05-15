//
//  CityModel.swift
//  trtr
//
//  Created by Trakya9 on 14.05.2025.
//

import Foundation

struct TRCity: Codable {
    let id: Int
    let name: String
}

struct District: Codable {
    let name: String
    let population: Int
    let area: Int
}


struct CityDetail: Codable {
    let population: Int
    let area: Int  // Yüzölçümü
    let id: Int  // Plaka Kodu (id)
    let altitude: Int  // Rakım
    let region: Region  // Bölge bilgisi
    let districts: [District]
}

struct Region: Codable {
    let en: String
    let tr: String
}




struct CityResponse: Codable {
    let status: String
    let data: [TRCity]
}

