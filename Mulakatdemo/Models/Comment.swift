//
//  Comment.swift
//  Mulakatdemo
//
//  Created by Muhammet Yıkmış on 9.11.2024.
//

import Foundation

/// Kullanıcı yorumlarını temsil eden model
struct Comment: Codable {
    let userName: String
    let profileImage: String
    let comment: String
    let date: String
    let likes: Int
}
