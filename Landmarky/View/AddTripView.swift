import SwiftUI

struct AddTripView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var notes = ""
    @State private var isMultiDay = false

    private var existingTrip: Trip?

    init(trip: Trip? = nil) {
        self.existingTrip = trip
        if let trip {
            _title = State(initialValue: trip.title)
            _startDate = State(initialValue: trip.startDate)
            _endDate = State(initialValue: trip.endDate ?? trip.startDate)
            _notes = State(initialValue: trip.notes ?? "")
            _isMultiDay = State(initialValue: trip.endDate != nil)
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
    }

    private func save() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }

        if let trip = existingTrip {
            trip.title = trimmedTitle
            trip.startDate = startDate
            trip.endDate = isMultiDay ? endDate : nil
            trip.notes = notes.isEmpty ? nil : notes
        } else {
            let trip = Trip(
                title: trimmedTitle,
                startDate: startDate,
                endDate: isMultiDay ? endDate : nil,
                notes: notes.isEmpty ? nil : notes
            )
            modelContext.insert(trip)
        }

        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    NavigationStack {
        AddTripView()
    }
    .modelContainer(for: [Trip.self])
}
