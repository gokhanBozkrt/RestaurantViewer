//
//  Place.swift
//  PlaceLookupDemo
//
//  Created by Gökhan Bozkurt on 8.01.2023.
//

import Foundation
import MapKit

struct Place: Identifiable {
    let id = UUID().uuidString
    private var mapItem: MKMapItem
    
    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
    }
    
    var name: String {
        self.mapItem.name ?? ""
    }
    
    var address: String {
        let placeMark = self.mapItem.placemark
        
        var cityAndState = ""
        var address = ""
        
        cityAndState = placeMark.locality ?? ""
        if let state = placeMark.administrativeArea {
            // Show either state or city,state
            cityAndState = cityAndState.isEmpty ? state : "\(cityAndState), \(state)"
        }
        address = placeMark.subThoroughfare ?? "" // address #
        if let street = placeMark.thoroughfare {
            // Just show the street unless there is a street # then add space + street
            address = address.isEmpty ? street : "\(address), \(street)"
        }
        
        if address.trimmingCharacters(in: .whitespaces).isEmpty && !cityAndState.isEmpty {
            // NO address Then just cityAndState with no space
            address = cityAndState
        } else {
            address = cityAndState.isEmpty ? address : "\(address), \(cityAndState)"
        }
        return address
    }
    
    var latitude: CLLocationDegrees {
        self.mapItem.placemark.coordinate.latitude
    }
    
    var longitude: CLLocationDegrees {
        self.mapItem.placemark.coordinate.longitude
    }
    
    
}
