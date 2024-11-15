//
//  EditView.swift
//  BucketList
//
//  Created by Grace couch on 12/11/2024.
//

import SwiftUI

struct EditView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var viewModel: ViewModel

    init(location: Location, onSave: @escaping (Location) -> Void) {
        _viewModel = State(initialValue: ViewModel(location: location, onSave: onSave))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Location Name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }

                Section("Nearby...") {
                    switch viewModel.loadingState {
                    case .loading:
                        Text("Loading...")

                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text(page.description)
                                .italic()
                        }

                    case .failed:
                        Text("Please try again later!")
                    }
                }
            }
            .navigationTitle("Location Details")
            .toolbar {
                Button("Save") {
                    var newLocation = viewModel.location
                    newLocation.id = UUID()
                    newLocation.name = viewModel.name
                    newLocation.description = viewModel.description

                    viewModel.onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces()
            }
        }
    }
}

#Preview {
    EditView(location: .example) { _ in
    }
}
