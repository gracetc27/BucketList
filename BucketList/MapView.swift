//
//  MapView.swift
//  BucketList
//
//  Created by Grace couch on 12/11/2024.
//
import MapKit
import SwiftUI

struct MapView: View {
    let startingPosition = MapCameraPosition.region( MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 56.0, longitude: -3.0),
        span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )

    @State private var viewModel = ViewModel()
    @State private var isHybrid = false

    var mapStyle: MapStyle {
        if isHybrid {
            return .hybrid
        } else {
            return .standard
        }
    }


    var body: some View {
                if viewModel.isUnlocked {
        NavigationStack {
            MapReader { proxy in
                Map(initialPosition: startingPosition) {
                    ForEach(viewModel.locations) { location in
                        Annotation(location.name, coordinate: location.coordinate) {
                            Image(systemName: "figure.walk.circle")
                                .resizable()
                                .foregroundStyle(.blue)
                                .frame(width: 32, height: 32)
                                .background(.white)
                                .clipShape(.circle)
                                .onLongPressGesture(minimumDuration: .zero, maximumDistance: .zero) {
                                    viewModel.selectedPlace = location
                                }
                        }
                    }
                }
                .mapStyle(mapStyle)


                .onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                        viewModel.addNewLocation(at: coordinate)
                    }
                }
                .sheet(item: $viewModel.selectedPlace) { place in
                    EditView(location: place) { newLocation in
                        viewModel.updateLocation(location: newLocation)
                    }
                }
            }
            .toolbar {
                Toggle(isOn: $isHybrid) { }
                    .toggleStyle(.switch)
            }
            .toolbarBackgroundVisibility(.hidden)
        }
        } else {
            Button("Unlock Places", systemImage: "lock.fill", action: viewModel.authenticate)
                .padding()
                .foregroundStyle(.white)
                .background(.blue)
                .clipShape(.capsule)
                .alert("Authentication Failed", isPresented: $viewModel.authenticationFailed) {
                    Button("Try again") {
                        viewModel.authenticationFailed = false
                    }
                }
        }
    }
}

#Preview {
    MapView()
}
