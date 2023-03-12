//
//  SpotDetailPhotoScrollView.swift
//  RestaurantReviewer
//
//  Created by Gökhan Bozkurt on 26.02.2023.
//

import SwiftUI

struct SpotDetailPhotoScrollView: View {
    
//    struct FakePhoto: Identifiable {
//        let id = UUID().uuidString
//        var imageURLString = "https://firebasestorage.googleapis.com:443/v0/b/restaurantreviewer-1b736.appspot.com/o/eYY5eJB12jnQ3Cwtmeqi%2F4DEA3D11-0A15-46F4-A086-8D31E705DD97.jpeg?alt=media&token=23952fab-3a6f-4940-84f5-a2c97fec10c6"
//    }
//    let photos = [FakePhoto(),FakePhoto(),FakePhoto(),FakePhoto(),FakePhoto(),FakePhoto(),FakePhoto(),FakePhoto(),FakePhoto()]
    @State private var showPhotoViewerView = false
    @State private var uiImage = UIImage()
    @State private var selectedPhoto = Photo()
    var photos: [Photo]
    var spot: Spot
    
    var body: some View {
        ScrollView(.horizontal,showsIndicators: true) {
            HStack(spacing: 4) {
                ForEach(photos) { photo in
                    let imageUrl = URL(string: photo.imageURLString) ?? URL(string: "")
                    AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80,height: 90)
                        .clipped()
                        .onTapGesture {
                          let renderer = ImageRenderer(content: image)
                            selectedPhoto = photo
                            uiImage = renderer.uiImage ?? UIImage()
                            showPhotoViewerView.toggle()
                        }
                    } placeholder: {
                        ProgressView()
                            .frame(width: 80,height: 90)
                    }

                }
            }
        }
        .frame(height: 80)
        .padding(.horizontal,4)
        .sheet(isPresented: $showPhotoViewerView) {
            PhotoView(uiImage: uiImage, spot: spot, photo: $selectedPhoto)
        }
    }
}

struct SpotDetailPhotoScrollView_Previews: PreviewProvider {
    static var previews: some View {
        SpotDetailPhotoScrollView(photos: [Photo(imageURLString: "https://firebasestorage.googleapis.com:443/v0/b/restaurantreviewer-1b736.appspot.com/o/eYY5eJB12jnQ3Cwtmeqi%2F4DEA3D11-0A15-46F4-A086-8D31E705DD97.jpeg?alt=media&token=23952fab-3a6f-4940-84f5-a2c97fec10c6")], spot: Spot(id: "eYY5eJB12jnQ3Cwtmeqi"))
    }
}
