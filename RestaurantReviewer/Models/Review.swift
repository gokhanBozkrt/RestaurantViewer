//
//  Review.swift
//  RestaurantReviewer
//
//  Created by Gökhan Bozkurt on 10.01.2023.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation

struct Review: Identifiable,Codable {
    @DocumentID var id: String?
    var title = ""
    var body = ""
    var rating = 0
    var reviewer = Auth.auth().currentUser?.email ?? ""
    var postedOn = Date()
    
    var dictionary: [String: Any] {
        return ["title": title,"body": body,"rating": rating,"reviewer": reviewer ,"postedOn": Timestamp(date: Date())]
    }
}
