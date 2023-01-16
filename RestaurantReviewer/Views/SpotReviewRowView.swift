//
//  SpotReviewRowView.swift
//  RestaurantReviewer
//
//  Created by Gökhan Bozkurt on 16.01.2023.
//

import SwiftUI

struct SpotReviewRowView: View {
    @State var review: Review
    var body: some View {
        VStack(alignment: .leading) {
            Text(review.title)
                .font(.title2)
            HStack {
                StarSelectionView(rating: $review.rating,interactive: false,font: .callout)
                Text(review.body)
                    .font(.callout)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity,alignment: .leading)
    }
}

struct SpotReviewRowView_Previews: PreviewProvider {
    static var previews: some View {
            SpotReviewRowView(review: Review( title: "Amazing food", body: "I love it", rating: 2))
    }
}
