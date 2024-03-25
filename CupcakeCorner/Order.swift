//
//  Order.swift
//  CupcakeCorner
//
//  Created by Tony Sharples on 15/03/2024.
//

import Foundation

@Observable
class Order: Codable {
    // These are required so that our json has the correct keys when posting to the server.
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _city = "city"
        case _streetAddress = "streetAddress"
        case _zip = "zip"
    }
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    var extraFrosting = false
    var addSprinkles = false
    
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    
    var name = UserDefaults.standard.string(forKey: "Name") ?? "" {
        didSet {
            UserDefaults.standard.set(name, forKey: "Name")
        }
    }
    
    var streetAddress = UserDefaults.standard.string(forKey: "StreetAddress") ?? "" {
        didSet {
            UserDefaults.standard.set(streetAddress, forKey: "StreetAddress")
        }
    }
    
    var city = UserDefaults.standard.string(forKey: "City") ?? "" {
        didSet {
            UserDefaults.standard.set(city, forKey: "City")
        }
    }
    
    var zip = UserDefaults.standard.string(forKey: "Zip") ?? "" {
        didSet {
            UserDefaults.standard.set(zip, forKey: "Zip")
        }
    }
    
    var hasValidAddress: Bool {
        if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty {
            return false
        }
        
        if containsOnlyWhitespace(name) || containsOnlyWhitespace(streetAddress) || containsOnlyWhitespace(city) || containsOnlyWhitespace(zip) {
            return false
        }
        
        return true
    }
    
    var cost: Decimal {
        // $2 per cake
        var cost = Decimal(quantity) * 2
        
        // Complicated cakes cost more
        cost += Decimal(type) / 2
        
        // $1 per cake for extra frosting
        if extraFrosting {
            cost += Decimal(quantity)
        }
        
        // $0.50 per cake for sprinkles
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }
        
        return cost
    }
    
    func containsOnlyWhitespace(_ string: String) -> Bool {
        let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return trimmedString.isEmpty
    }
}
