//
//  PhotoView.swift
//  RestaurantReviewer
//
//  Created by Gökhan Bozkurt on 19.02.2023.
//

import Firebase
import SwiftUI

struct PhotoView: View {
    var uiImage: UIImage
    var spot: Spot
    @EnvironmentObject var spotVM: SpotViewModel
    @Binding var photo: Photo
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                Spacer()
                
                TextField("Description", text: $photo.description)
                    .textFieldStyle(.roundedBorder)
                    .disabled(Auth.auth().currentUser?.email != photo.reviewer)
                Text("by: \(photo.reviewer) on: \(photo.postedOn.formatted(date: .numeric, time: .omitted))")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            .padding()
            .toolbar {
                if Auth.auth().currentUser?.email == photo.reviewer {
                    // Image posted by current user
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .automatic) {
                        Button("Save") {
                            Task {
                                let success = await spotVM.saveImage(spot: spot, photo: photo, image: uiImage)
                                if success {
                                   dismiss()
                                }
                            }
                        }
                    }
                } else {
                    // Image is not posted by current user
                    ToolbarItem(placement: .automatic) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
               
            }
        }
    }
}

//struct PhotoView_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoView(uiImage: <#T##UIImage#>)
//    }
//}
