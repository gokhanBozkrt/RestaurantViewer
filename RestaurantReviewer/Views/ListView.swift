//
//  ListView.swift
//  RestaurantReviewer
//
//  Created by Gökhan Bozkurt on 5.01.2023.
//

import Firebase
import FirebaseFirestoreSwift
import SwiftUI


struct ListView: View {
    @FirestoreQuery(collectionPath: "spots",predicates: [.orderBy("name", false)]) var spots: [Spot]
    @Environment(\.dismiss) private var dismiss
    @State private var sheetIsPresented = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(spots) { spot in
                    NavigationLink {
                        SpotDetailView(spot: spot)
                    } label: {
                        Text(spot.name)
                            .font(.title2)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Restaurants")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Sign Out") {
                        do {
                            try Auth.auth().signOut()
                            print("▶️Log out Successful")
                            dismiss()
                        } catch {
                            print("😡 Could not sign out")
                        }
                         
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        sheetIsPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $sheetIsPresented) {
                NavigationStack {
                    SpotDetailView(spot: Spot())
                }
        }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ListView()
        }
      
    }
}
