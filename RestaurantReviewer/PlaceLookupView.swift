//
//  PlaceLookupView.swift
//  PlaceLookupDemo
//
//  Created by Gökhan Bozkurt on 8.01.2023.
//

import SwiftUI
import MapKit

struct PlaceLookupView: View {
    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var locationManager: LocationManager
    @StateObject var placeVM = PlaceViewModel()
    @Binding var returnedPlace: Place
    /*
     @StateObject here if this is the first or only place we will use this View Model
     */

    var body: some View {
        NavigationStack {
            List(placeVM.places) { place in
                VStack(alignment: .leading) {
                    Text(place.name)
                        .font(.title2)
                    Text(place.address)
                        .font(.callout)
                }
                .onTapGesture {
                    returnedPlace = place
                    dismiss()
                }
            }
            .listStyle(.plain)
            .searchable(text: $searchText)
            .onChange(of: searchText, perform: { text  in
                if !text.isEmpty {
                    placeVM.search(text: text, region: locationManager.region)
                } else {
                    placeVM.places = []
                }
            })
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        
    }
}

struct PlaceLookupView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceLookupView( returnedPlace: .constant(Place(mapItem: MKMapItem())))
            .environmentObject(LocationManager())
    }
}
