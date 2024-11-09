// MapViewModel.swift

import Foundation
import MapKit

class MapViewModel {
    private var dish: Dish
    
    init(dish: Dish) {
        self.dish = dish
    }
    
    /// Annotations dizisi döndürür
    func getAnnotations() -> [MKPointAnnotation] {
        return dish.locations.map { location in
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.clLocationCoordinate
            annotation.title = dish.name
            return annotation
        }
    }
    
    /// Tüm noktaları kapsayacak bir `MKCoordinateRegion` döndürür
    func getRegion() -> MKCoordinateRegion? {
        guard !dish.locations.isEmpty else { return nil }
        
        // Konumlar aynı şehirdeyse, hepsini kapsayan bir bölge tanımla
        let coordinates = dish.locations.map { $0.clLocationCoordinate }
        
        // Bölgenin merkezini ve span'ini hesapla
        var minLat = coordinates[0].latitude
        var maxLat = coordinates[0].latitude
        var minLon = coordinates[0].longitude
        var maxLon = coordinates[0].longitude
        
        for coordinate in coordinates {
            minLat = min(minLat, coordinate.latitude)
            maxLat = max(maxLat, coordinate.latitude)
            minLon = min(minLon, coordinate.longitude)
            maxLon = max(maxLon, coordinate.longitude)
        }
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.5, longitudeDelta: (maxLon - minLon) * 1.5)
        
        return MKCoordinateRegion(center: center, span: span)
    }
}
