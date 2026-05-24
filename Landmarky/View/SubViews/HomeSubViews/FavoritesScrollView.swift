import SwiftUI

struct FavoritesScrollView: View {
    let landmarks: [Landmark]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(Constants.Strings.favorites, systemImage: "heart.fill")
                .font(.headline)
                .foregroundStyle(.red)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(landmarks) { landmark in
                        NavigationLink {
                            LandmarkDetailView(landmark: landmark)
                        } label: {
                            LandmarkCard(landmark: landmark)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    FavoritesScrollView(landmarks: Mock.MockLandmarks.data)
}
