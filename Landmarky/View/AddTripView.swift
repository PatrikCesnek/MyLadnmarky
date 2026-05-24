import PhotosUI
import SwiftUI
import UIKit

struct AddTripView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var notes = ""
    @State private var isMultiDay = false
    @State private var selectedImageData: [Data] = []
    @State private var selectedPhotoItems: [PhotosPickerItem] = []
    @State private var showPhotoSourceSheet = false
    @State private var showPhotoPicker = false
    @State private var showCamera = false

    private let galleryColumns = [
        GridItem(.adaptive(minimum: 80), spacing: 8)
    ]
    private var existingTrip: Trip?

    init(trip: Trip? = nil) {
        self.existingTrip = trip
        if let trip {
            _title = State(initialValue: trip.title)
            _startDate = State(initialValue: trip.startDate)
            _endDate = State(initialValue: trip.endDate ?? trip.startDate)
            _notes = State(initialValue: trip.notes ?? "")
            _isMultiDay = State(initialValue: trip.endDate != nil)
            _selectedImageData = State(initialValue: trip.photoData)
        }
    }

    var body: some View {
        Form {
            Section(Constants.Strings.title) {
                TextField(Constants.Strings.title, text: $title)
            }

            Section(Constants.Strings.dates) {
                DatePicker(
                    Constants.Strings.startDate,
                    selection: $startDate,
                    displayedComponents: .date
                )

                Toggle(Constants.Strings.multiDayTrip, isOn: $isMultiDay.animation())

                if isMultiDay {
                    DatePicker(
                        Constants.Strings.endDate,
                        selection: $endDate,
                        in: startDate...,
                        displayedComponents: .date
                    )
                }
            }

            Section(Constants.Strings.photo) {
                if !selectedImageData.isEmpty {
                    LazyVGrid(columns: galleryColumns, alignment: .leading, spacing: 8) {
                        ForEach(Array(selectedImageData.enumerated()), id: \.offset) { index, imageData in
                            galleryThumbnail(imageData: imageData, index: index)
                        }
                    }
                    .padding(.vertical, 4)
                }

                Button {
                    showPhotoSourceSheet = true
                } label: {
                    Label(Constants.Strings.addPhotos, systemImage: Constants.SystemImages.photo)
                }
            }

            Section(Constants.Strings.description) {
                TextEditor(text: $notes)
                    .frame(minHeight: 150)
            }

            if existingTrip != nil {
                Section {
                    CenterView {
                        Button(Constants.Buttons.delete) {
                            if let trip = existingTrip {
                                modelContext.delete(trip)
                                try? modelContext.save()
                            }
                            dismiss()
                        }
                        .foregroundStyle(.red)
                    }
                }
            }
        }
        .navigationTitle(existingTrip == nil ? Constants.Strings.newTrip : Constants.Strings.editTrip)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                save()
            } label: {
                Image(systemName: Constants.SystemImages.editSaveButtonImage)
                    .font(.headline)
            }
            .buttonStyle(.glassProminent)
            .tint(.green)
        }
        .confirmationDialog(
            Constants.Strings.choosePhotoSource,
            isPresented: $showPhotoSourceSheet
        ) {
            Button(Constants.Buttons.chooseFromGallery) {
                showPhotoPicker = true
            }
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Button(Constants.Buttons.takePhoto) {
                    showCamera = true
                }
            }
            Button(Constants.Buttons.cancel, role: .cancel) {}
        }
        .photosPicker(
            isPresented: $showPhotoPicker,
            selection: $selectedPhotoItems,
            matching: .images
        )
        .onChange(of: selectedPhotoItems) { _, newItems in
            Task { await loadPhotos(from: newItems) }
        }
        .sheet(isPresented: $showCamera) {
            ImagePickerView(sourceType: .camera) { image in
                handlePickedImage(image)
            }
        }
    }

    private func galleryThumbnail(imageData: Data, index: Int) -> some View {
        ZStack(alignment: .topTrailing) {
            if let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                Image(systemName: Constants.SystemImages.photo)
                    .font(.title2)
                    .foregroundStyle(.secondary)
                    .frame(width: 80, height: 80)
                    .background(Color.secondary.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            Button {
                selectedImageData.remove(at: index)
            } label: {
                Image(systemName: Constants.SystemImages.xmarkCircleFill)
                    .font(.title3)
                    .foregroundStyle(.white, .black.opacity(0.6))
            }
            .buttonStyle(.plain)
            .padding(4)
        }
        .frame(width: 80, height: 80)
    }

    private func save() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }

        if let trip = existingTrip {
            trip.title = trimmedTitle
            trip.startDate = startDate
            trip.endDate = isMultiDay ? endDate : nil
            trip.notes = notes.isEmpty ? nil : notes
            trip.image = nil
            trip.images = selectedImageData
        } else {
            let trip = Trip(
                title: trimmedTitle,
                startDate: startDate,
                endDate: isMultiDay ? endDate : nil,
                notes: notes.isEmpty ? nil : notes,
                images: selectedImageData
            )
            modelContext.insert(trip)
        }

        try? modelContext.save()
        dismiss()
    }

    private func handlePickedImage(_ image: UIImage?) {
        guard let image,
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            return
        }
        selectedImageData.append(imageData)
    }

    @MainActor
    private func loadPhotos(from items: [PhotosPickerItem]) async {
        guard !items.isEmpty else { return }

        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data),
               let imageData = image.jpegData(compressionQuality: 0.8) {
                selectedImageData.append(imageData)
            }
        }

        selectedPhotoItems.removeAll()
    }
}

#Preview {
    NavigationStack {
        AddTripView()
    }
    .modelContainer(for: [Trip.self])
}
