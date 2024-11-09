//
//  KitchenViewModel.swift
//  Mulakatdemo
//
//  Created by Muhammet Yıkmış on 4.11.2024.
//

import Foundation

/// Popüler yemekler ve hikayeler için ViewModel
class KitchenViewModel {
    // MARK: - Properties
    private(set) var dishes: [Dish] = []       // Popüler yemekler
    private(set) var stories: [Story] = []      // Popüler hikayeler

    // MARK: - Data Loading
    /// JSON dosyasından popüler yemek ve hikaye verilerini yükler
    func loadMockData() {
        guard let path = Bundle.main.path(forResource: "mockData", ofType: "json") else {
            print("Mock data dosyası bulunamadı")
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let popularDishesData = try JSONDecoder().decode(PopularDishesData.self, from: data)
            self.dishes = popularDishesData.popularDishes
            self.stories = popularDishesData.popularStories
            
            // Kontrol amaçlı tüm isimleri yazdırma
            for dish in dishes {
                print("Dish Name: \(dish.name)")
            }
        } catch {
            print("Mock data yüklenirken hata oluştu: \(error.localizedDescription)")
        }
    }

}
