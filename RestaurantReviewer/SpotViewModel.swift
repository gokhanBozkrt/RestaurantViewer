//
//  SpotViewModel.swift
//  RestaurantReviewer
//
//  Created by Gökhan Bozkurt on 6.01.2023.
//

import FirebaseFirestore
import Foundation

class SpotViewModel: ObservableObject {
    @Published var spot = Spot()
    
    func saveSpot(spot: Spot) async -> Bool {
        let db = Firestore.firestore()
        if let id = spot.id { // spot must already exist, so save
            do {
               try await db.collection("spots").document(id).setData(spot.dictionary)
                print("😎 Data update succesfully!")
                return true
            }
            catch {
                print("😡 ERROR: Could not update data in 'spots' \(error.localizedDescription)")
                return false
            }
        } else { // no id?  Then this must be a new spot to add
            do {
                try await db.collection("spots").addDocument(data: spot.dictionary)
                print("🐣  Data added succesfully!")
                return true
            } catch {
                print("😡 ERROR: Could not create a new spot in  'spots' \(error.localizedDescription)")
                return false
            }
        }
    }
    
}
