//
//  ReviewView.swift
//  RestaurantReviewer
//
//  Created by Gökhan Bozkurt on 10.01.2023.
//

import SwiftUI

struct ReviewView: View {
    @State var spot: Spot
    @State var review: Review
    @Environment(\.dismiss) private var  dismiss
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
           
            
            Text("Click to Rate:")
                .font(.title2)
                .bold()
            HStack {
                StarSelectionView(rating: $review.rating)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5),lineWidth: 2)
                    }
            }
            .padding(.bottom)
            VStack(alignment: .leading) {
                Text("Review Title:")
                    .bold()
                TextField("title",text: $review.title)
                    .textFieldStyle(.roundedBorder)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5),lineWidth: 2)
                    }
                
                Text("Review")
                    .bold()
                TextField("review", text: $review.body,  axis: .vertical)
                    .padding(.horizontal,6)
                    .frame(maxHeight: .infinity,alignment: .topLeading)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5),lineWidth: 2)
                    }
            }
            .padding(.horizontal)
            
       
            Spacer()
        }
        .toolbar {
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

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView(spot: Spot(name: "Kurucu Kazım",address: "18A,Karatay Eski Çarşı"), review: Review())
    }
}
