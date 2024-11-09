//
//  PopularDishesData.swift
//  Mulakatdemo
//
//  Created by Muhammet Yıkmış on 9.11.2024.
//

import Foundation

/// Popüler yemek ve hikayeleri içeren veri yapısı
struct PopularDishesData: Codable {
    let popularDishes: [Dish]
    let popularStories: [Story]
}
