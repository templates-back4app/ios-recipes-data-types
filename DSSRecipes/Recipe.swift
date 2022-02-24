//
//  Recipe.swift
//  DSSRecipes
//
//  Created by David on 19/02/22.
//

import Foundation
import ParseSwift

struct Recipe: ParseObject {
    /// Enumeration for the recipe category
    enum Category: Int, CaseIterable, Codable {
        case breakfast = 0, lunch = 1, dinner = 2
        
        var title: String {
            switch self {
            case .breakfast: return "Breakfast"
            case .lunch: return "Lunch"
            case .dinner: return "Dinner"
            }
        }
    }
    
    // Required properties from ParseObject protocol
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    
    /// A *String* type property
    var name: String?
    
    /// An *Integer* type property
    var servings: Int?
    
    /// A *Double* (or *Float*) type property
    var price: Double?
    
    /// A *Boolean* type property
    var isAvailable: Bool?
    
    /// An *Enumeration* type property
    var category: Category?
    
    /// An array of *structs*
    var ingredients: [Ingredient]
    
    /// An array of *Strings*
    var sideOptions: [String]
    
    /// A dictionary property
    var nutritionalInfo: [String: String]
    
    /// A *Date* type property
    var releaseDate: Date?
    
    /// Maps the nutritionalInfo property into an array of tuples
    func nutritionalInfoArray() -> [(name: String, value: String)] {
        return nutritionalInfo.map { ($0.key, $0.value) }
    }
}

extension Recipe {
    static let omelette: Recipe = {
        let ingredients: [Ingredient] = [
            Ingredient(quantity: 3, description: "Eggs beaten"),
            Ingredient(quantity: 1, description: "Tsp sunflower oil"),
            Ingredient(quantity: 1, description: "Tsp butter")
        ]
        
        let nutritionalInfo: [String: String] = ["Calories": "500Cal", "Fat": "8g"]
        
        return Recipe(
            name: "Omelette",
            servings: 2,
            price: 7.99,
            isAvailable: false,
            category: .breakfast,
            ingredients: ingredients,
            sideOptions: ["Juice", "Bacon"],
            nutritionalInfo: nutritionalInfo,
            releaseDate: Date(timeIntervalSince1970: 10000000)
        )
    }()
}
