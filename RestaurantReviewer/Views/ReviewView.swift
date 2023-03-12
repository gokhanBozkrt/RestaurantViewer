//
//  ReviewView.swift
//  RestaurantReviewer
//
//  Created by Gökhan Bozkurt on 10.01.2023.
//

import CoreHaptics
import Firebase
import SwiftUI

struct ReviewView: View {
    @State private var engine: CHHapticEngine?
    @State var spot: Spot
    @State var review: Review
    @State private var rateOrReviewerString = "Click to Rate:"
    @State private var showDeleteAlert = false
    @State private var deleteAlertMessage = "This review will be deleted permenantly."
   
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
            prepareHaptics()
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
                
                if review.id != nil {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Spacer()
                        Button {
                            showDeleteAlert.toggle()
                        } label: {
                            Image(systemName: "trash")
                        }

                    }
                }
            }
        }
        .alert("Are you deleting this review", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) { deleteReview() }
            Button("Cancel",role: .cancel) { }
            
        } message: {
            Text(deleteAlertMessage)
        }
    }
    
    func deleteReview() {
        Task {
            let success = await reviewVM.deleteReview(spot: spot, review: review)
            if success {
                dismiss()
                complexSucces()
            }
        }
    }

}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView(spot: Spot(name: "Kurucu Kazım",address: "18A,Karatay Eski Çarşı"), review: Review())
    }
}



extension ReviewView {
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error crating the engine:\(error.localizedDescription)")
        }
    }
    func complexSucces() {
    // Make sure that device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        
        // CREATE ONE INTENSE; SHARP TAP
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity,sharpness], relativeTime: 0)
        events.append(event)
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play patterns: \(error.localizedDescription)")
        }
        
    }
}
