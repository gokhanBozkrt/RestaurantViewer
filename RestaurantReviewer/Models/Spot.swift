//
//  Spot.swift
//  RestaurantReviewer
//
//  Created by Gökhan Bozkurt on 6.01.2023.
//
import CoreLocation
import FirebaseFirestoreSwift
import Foundation

struct Spot: Identifiable,Codable,Equatable {
    @DocumentID var id: String?
    var name = ""
    var address = ""
    var latitude = 0.0
    var longitude = 0.0
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var dictionary: [String: Any] {
        return ["name": name,"address": address, "latitude": latitude,"longitude": longitude ]
    }
}
