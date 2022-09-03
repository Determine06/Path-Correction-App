//
//  ContentView.swift
//  helloworld
//
//  Created by Nishchay Jaiswal on 7/7/22.
//

import SwiftUI
import MapKit

struct HomePage: View {
    @StateObject var viewModel = MapViewModel()
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.blue, Color(red:0.18, green: 0.79, blue: 0.91, opacity: 1.0)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
                NavigationLink {
                    MapView()
                }
            label: {
                ZStack {
                    Circle()
                        .trim(from: 0.5)
                        .frame(width: 450, height: 450)
                        .foregroundColor(Color(red: 1.0, green: 0.89, blue: 0.36, opacity: 1.0))
                    
                    Text("Navigate")
                        .foregroundColor(.white)
                        .font(.system(size:32, weight: .bold, design: .default))
                        .padding(.bottom, 280)
                }
                .position(x: 195, y: 900)
                .ignoresSafeArea(.all)
            }
            }
        }
        .environmentObject(viewModel)
    }
}

struct MapView: View {
    @EnvironmentObject var viewModel: MapViewModel
    var body: some View {
        Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
            .ignoresSafeArea()
            .accentColor(Color(.systemPink))
            .onAppear {
                print("\n----> in onAppear")
                viewModel.checkIfLocationServiceIsEnabled()
            }
    }
}

final class MapViewModel : NSObject, ObservableObject, CLLocationManagerDelegate {
    @ObservedObject var dataModel = DataModel()
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 33, longitude: -120), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    var locationManager: CLLocationManager?
    
    func checkIfLocationServiceIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.startUpdatingLocation()
            locationManager!.delegate = self
            locationManager!.startUpdatingLocation()
        }
        else {
            print("Print error message")
        }
    }
    
    func checkLocationAuthorization() {
        print("checking authorization")
        guard let locationManager = locationManager else { return }
        switch locationManager.authorizationStatus {
        case .notDetermined:
            print("requesting")
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location restricted")
        case .denied:
            print("You have denied location permission, go to settings")
        case .authorizedAlways, .authorizedWhenInUse:
            print("Inside")
            if locationManager.location?.coordinate != nil {
                region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            }
            else {
                print("Location not found")
            }
            
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last!
        let date = Date()
        let components = Calendar.current.dateComponents([.hour,.minute,.second], from: date)
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        let time = String(hour!) + ":" + String(minute!) + ":" + String(second!)
        dataModel.writeData(lat: String(lastLocation.coordinate.latitude), long: String(lastLocation.coordinate.longitude), time: time)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
