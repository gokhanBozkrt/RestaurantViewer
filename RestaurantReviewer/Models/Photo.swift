//
//  Photo.swift
//  RestaurantReviewer
//
//  Created by Gökhan Bozkurt on 17.02.2023.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Photo: Identifiable,Codable {
   @DocumentID var id: String?
    var imageURLString = ""
    var description = ""
    var reviewer = Auth.auth().currentUser?.email ?? ""
    var postedOn = Date()
    
    var dictionary: [String: Any] {
        return ["imageURLString": imageURLString,"description": description,"reviewer": reviewer, "postedOn": Timestamp(date: Date()) ]
    }
}
