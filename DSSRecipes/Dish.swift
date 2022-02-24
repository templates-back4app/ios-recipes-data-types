//
//  Dish.swift
//  DSSUserProfile
//
//  Created by David on 19/02/22.
//

import Foundation
import ParseSwift

struct Recipe: ParseObject {
    enum DishType: Int, Codable {
        case salad = 0, cake = 1, general = 2
    }
    
    
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    
    /// A *String* type property
    var name: String?
    
    /// An *Integer* type property
    var servings: Int?
    var attack: Int?
    
    /// A *Double* (or *Float*) type property
    var armor: Double?
    
    /// A *Boolean* type property
    var isAvailable: Bool?
    
    /// An *Enumeration* type property
    var type: DishType?
    
    /// An array of structs
    var ingredients: [Ingredient] = []
    
    /// An array of *Strings*
    var inventory: [String] = []
    
    /// A dictionary
    var talents: [Int: String] = [:]
    
    /// An array of *Integers*
    var experiencePerLevel: [Int] = []
    
    /// A *Date* type property
    var releaseDate: Date?
}

extension Recipe {
    static let sven: Recipe = {
        let abilities: [Ingredient] = [
            Ingredient(id: 0, name: "Stun", damage: 150),
            Ingredient(id: 1, name: "God's strength", damage: 500)
        ]
        return Recipe(
            name: "Sven",
            level: 27,
            hitPoints: 3000,
            attack: 170,
            armor: 4.5,
            isAvailable: true,
            mainAttribute: .strength,
            abilities: abilities,
            inventory: ["Boots", "Spear"],
            talents: [1: "Regeneration", 2: "Blink"],
            experiencePerLevel: [200, 300, 500, 800],
            releaseDate: Date(timeIntervalSince1970: 100000)
        )
    }()
    
    static let zeus: Recipe = {
        let abilities: [Ingredient] = [
            Ingredient(id: 0, name: "Lighting Bolt", damage: 100),
            Ingredient(id: 1, name: "Thundergod's Wrath", damage: 750)
        ]
        return Recipe(
            name: "Zeus",
            level: 25,
            hitPoints: 2300,
            attack: 120,
            armor: 1,
            isAvailable: false,
            mainAttribute: .intelligence,
            abilities: abilities,
            inventory: ["Boots", "Scepter"],
            talents: [1: "Teleportation", 2: "Blink"],
            experiencePerLevel: [220, 350, 600, 950],
            releaseDate: Date(timeIntervalSince1970: 110000)
        )
    }()
}
