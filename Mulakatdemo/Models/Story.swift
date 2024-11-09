//
//  Story.swift
//  Mulakatdemo
//
//  Created by Muhammet Yıkmış on 9.11.2024.
//

import Foundation

/// Hikaye bilgilerini temsil eden model
struct Story: Codable {
    let id: Int
    let title: String
    let image: String
}
