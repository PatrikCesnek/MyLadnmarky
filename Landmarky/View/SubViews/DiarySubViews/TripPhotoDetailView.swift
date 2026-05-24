import SwiftUI

struct TripPhotoDetailView: View {
    let image: UIImage
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
                .ignoresSafeArea(edges: .bottom)
                .toolbar {
                    Button(Constants.Buttons.cancel) {
                        dismiss()
                    }
                }
        }
    }
}

#Preview {
    TripPhotoDetailView(image: UIImage())
}
