//
//  Spot.swift
//  RestaurantReviewer
//
//  Created by Gökhan Bozkurt on 6.01.2023.
//

import FirebaseFirestoreSwift
import Foundation

struct Spot: Identifiable,Codable {
    @DocumentID var id: String?
    var name = ""
    var address = ""
    
    var dictionary: [String: Any] {
        return ["name": name,"address": address]
    }
}
