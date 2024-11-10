//
//  KitchenViewModel.swift
//  Mulakatdemo
//
//  Created by Muhammet Yıkmış on 4.11.2024.
//

import Foundation

// Popüler yemekler ve hikayeler için ViewModel
class KitchenViewModel {
    // MARK: - Properties
    private(set) var dishes: [Dish] = []
    private(set) var stories: [Story] = []
    // MARK: - Data Loading
    // JSON dosyasından verileri yükleme
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
            
            // Veri Kontrolü
            for dish in dishes {
                print("Dish Name: \(dish.name)")
            }
        } catch {
            print("Mock data yüklenirken hata oluştu: \(error.localizedDescription)")
        }
    }

}
