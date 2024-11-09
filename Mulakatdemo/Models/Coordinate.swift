//
//  Coordinate.swift
//  Mulakatdemo
//
//  Created by Muhammet Yıkmış on 8.11.2024.
//

import Foundation
import CoreLocation

struct Coordinate : Codable{
    let latitude: Double
    let longitude : Double
    
    var clLocationCoordinate : CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
