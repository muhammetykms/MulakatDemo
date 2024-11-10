//
//  Dish.swift
//  Mulakatdemo
//
//  Created by Muhammet Yıkmış on 4.11.2024.
//

import Foundation

// Yemek Modeli
struct Dish: Codable {
    let id: Int
    let name: String
    let description: String
    let location: String
    let price: String
    let likes: Int
    let images: [String]
    let ingredients: String
    let deliveryOptions: [String]
    let categoryTags: [String]
    let comments: [Comment]
    let locations: [Coordinate]
}
