//
//  PopularDishesData.swift
//  Mulakatdemo
//
//  Created by Muhammet Yıkmış on 9.11.2024.
//

import Foundation

// Popüler yemek ve hikayeler
struct PopularDishesData: Codable {
    let popularDishes: [Dish]
    let popularStories: [Story]
}
