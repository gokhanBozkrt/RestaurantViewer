//
//  SpotViewModel.swift
//  RestaurantReviewer
//
//  Created by Gökhan Bozkurt on 6.01.2023.
//

import FirebaseFirestore
import Foundation

@MainActor
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
              let documentRef = try await db.collection("spots").addDocument(data: spot.dictionary)
                self.spot = spot
                self.spot.id = documentRef.documentID
                print("🐣  Data added succesfully!")
                return true
            } catch {
                print("😡 ERROR: Could not create a new spot in  'spots' \(error.localizedDescription)")
                return false
            }
        }
    }
    /*
    func deleteSpot(spot: Spot) async -> Bool {
        let db = Firestore.firestore()
        guard let spotID = spot.id else {
            print("😡 ERROR: spot.id: \(spot.id ?? "nil").This should not have happened.")
            return false
        }
        do {
            let _ = try await db.collection("spots").document(spotID).delete()
            print("🗑️ Document successfully deleted.")
            return true
        } catch {
            print("😡 ERROR: Removing dovument: \(error.localizedDescription)")
            return false
        }
    }
    */
}

