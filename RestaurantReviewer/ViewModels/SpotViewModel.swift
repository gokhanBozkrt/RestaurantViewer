//
//  SpotViewModel.swift
//  RestaurantReviewer
//
//  Created by Gökhan Bozkurt on 6.01.2023.
//

import FirebaseFirestore
import Foundation
import UIKit
import FirebaseStorage

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
    func saveImage(spot: Spot, photo: Photo, image: UIImage) async -> Bool {
        guard let spotID = spot.id else {
            print("😡 ERROR: spot.id == nil")
            return false
        }
        
        var photoName = UUID().uuidString // name of image file
        if photo.id != nil {
            photoName = photo.id!
        }
        let storage = Storage.storage() // Create a firebase storage instance
        let storageRef = storage.reference().child("\(spotID)/\(photoName).jpeg")
        
        guard let resizedImage = image.jpegData(compressionQuality: 0.2) else {
            print("😡 ERROR: Could Not Resize image")
            return false
        }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg" // Setting metadata allows you to see console image in the web browser.This setting will work for png as well as jpeg
        
        var imageURLString = "" // We will set this after the image is successfully saved
        
        do {
            let _ = try await storageRef.putDataAsync(resizedImage,metadata: metaData)
            print("📸 Image Saved!")
            do {
                let imageURL = try await storageRef.downloadURL()
                imageURLString = "\(imageURL)" // We will save this to Cloud Firestore as part of document in 'photos' collection, below
            } catch {
                print("😡 ERROR: Could not get imageURL after saving image \(error.localizedDescription)")
                return false
            }
        } catch {
            print("😡 ERROR: Uploading image to FirebaseStorage")
            return false
        }
        // Now save to the photos collection of the spot document "spotID"
        let db = Firestore.firestore()
        let collecitonString = "spots/\(spotID)/photos"
        
        do {
            var newPhoto = photo
            newPhoto.imageURLString = imageURLString
            try await db.collection(collecitonString).document(photoName).setData(newPhoto.dictionary)
            print("😎 Data updated succesfully!")
            return true
        } catch {
            print("😡 ERROR: Could not update data in 'photos' for spotID \(spotID)")
            return false
        }
        
    }
}

