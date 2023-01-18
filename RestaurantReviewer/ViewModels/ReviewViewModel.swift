//
//  ReviewViewModel.swift
//  RestaurantReviewer
//
//  Created by Gökhan Bozkurt on 14.01.2023.
//

import FirebaseFirestore
import Foundation

@MainActor
class ReviewViewModel: ObservableObject {
    @Published var review = Review()
    
    func saveReview(spot: Spot, review: Review) async -> Bool {
        let db = Firestore.firestore()
        guard let spotID = spot.id else {
         print("ERROR SPOT ID IA NIL")
            return false
        }
        let collectionString = "spots/\(spotID)/reviews"
        if let id = review.id { // spot must already exist, so save
            do {
               try await db.collection(collectionString).document(id).setData(review.dictionary)
                print("😎 Data update succesfully!")
                return true
            }
            catch {
                print("😡 ERROR: Could not update data in 'reviews' \(error.localizedDescription)")
                return false
            }
        } else { // no id?  Then this must be a new spot to add
            do {
              _ = try await db.collection(collectionString).addDocument(data: review.dictionary)
                print("🐣  Data added succesfully!")
                return true
            } catch {
                print("😡 ERROR: Could not create a new review in  'reviews' \(error.localizedDescription)")
                return false
            }
        }
    }
    func deleteReview(spot: Spot, review: Review) async -> Bool {
        let db = Firestore.firestore()
        guard let spotID = spot.id, let reviewID = review.id else {
            print("😡 ERROR: spot.id: \(spot.id ?? "nil"), review.id: \(review.id ?? "nil").This should not have happened.")
            return false
        }
        do {
            let _ = try await db.collection("spots").document(spotID).collection("reviews").document(reviewID).delete()
            print("🗑️ Document successfully deleted.")
            return true
        } catch {
            print("😡 ERROR: Removing dovument: \(error.localizedDescription)")
            return false
        }
    }
}
