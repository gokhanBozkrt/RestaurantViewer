//
//  PlaceViewModel.swift
//  PlaceLookupDemo
//
//  Created by Gökhan Bozkurt on 8.01.2023.
//

import Foundation
import MapKit

@MainActor
class PlaceViewModel: ObservableObject {
    @Published var places: [Place] = []
    
    func search(text: String, region: MKCoordinateRegion) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = text
        searchRequest.region = region
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error  in
            guard let response = response else {
                print("😡ERORR: \(error?.localizedDescription ?? "UNKNOWN ERROR")")
                return
            }
            self.places = response.mapItems.map(Place.init)
        }
    }
}
