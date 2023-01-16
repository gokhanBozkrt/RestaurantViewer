//
//  ReviewView.swift
//  RestaurantReviewer
//
//  Created by Gökhan Bozkurt on 10.01.2023.
//

import Firebase
import SwiftUI

struct ReviewView: View {
    
    @State var spot: Spot
    @State var review: Review
    @State private var rateOrReviewerString = "Click to Rate:"
    @Environment(\.dismiss) private var  dismiss
    @State private var postedByThisUser = false
    @StateObject var reviewVM = ReviewViewModel()
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(spot.name)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                Text(spot.address)
                    .padding(.bottom)
            }
            .padding()
            .frame(maxWidth: .infinity,alignment: .leading)
           
            
            Text(rateOrReviewerString)
                .font(postedByThisUser ? .title2 : .subheadline)
                .bold(postedByThisUser)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .padding(.horizontal)
            HStack {
                StarSelectionView(rating: $review.rating)
                    .disabled(!postedByThisUser)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5),lineWidth: postedByThisUser ? 2 : 0)
                    }
            }
            .padding(.bottom)
            VStack(alignment: .leading) {
                Text("Review Title:")
                    .bold()
                TextField("title",text: $review.title)
                    .padding(.horizontal,6)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5),lineWidth: postedByThisUser ? 2 : 0.3)
                    }
                
                Text("Review")
                    .bold()
                TextField("review", text: $review.body,  axis: .vertical)
                    .padding(.horizontal,6)
                    .frame(maxHeight: .infinity,alignment: .topLeading)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5),lineWidth: postedByThisUser ? 2 : 0.3)
                    }
            }
            .disabled(!postedByThisUser)
            .padding(.horizontal)
            .font(.title2)
            
       
            Spacer()
        }
        .navigationBarBackButtonHidden(postedByThisUser) // Hide back button if posted by this user
        .onAppear {
            if review.reviewer == Auth.auth().currentUser?.email {
                postedByThisUser = true
            } else {
                let reviewPostedOn = review.postedOn.formatted(date: .numeric, time: .omitted)
                rateOrReviewerString = "by: \(review.reviewer) on: \(reviewPostedOn)"
            }
        }
        .toolbar {
            if postedByThisUser {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task {
                          let success = await reviewVM.saveReview(spot:spot,review:review)
                            if success {
                                dismiss()
                            } else {
                                print("😡")
                            }
                        }
                       
                    }
                }
            }
        }
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView(spot: Spot(name: "Kurucu Kazım",address: "18A,Karatay Eski Çarşı"), review: Review())
    }
}
