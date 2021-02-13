//
//  MapViewController.swift
//  food-places-ios
//
//  Created by Boris Sagan on 11.02.2021.
//

import UIKit
import GoogleMaps
import Combine
import SwiftUI

class MapViewController: UIViewController {
  @IBOutlet private weak var mapView: GMSMapView!
  var viewModel: PlacesViewModel?
  private var cancellables = Set<AnyCancellable>()
  private var isUserInteraction = false
  private var markers: [GMSMarker: Place] = [:]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupMapView()
    bindData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  private func setupNavigationBar() {
    navigationItem.title = "Food Places"
  }
  
  private func setupMapView() {
    mapView.delegate = self
    mapView.isMyLocationEnabled = true
  }
  
  private func bindData() {
    viewModel?.$places
      .receive(on: DispatchQueue.main)
      .sink { [weak self] (places) in
        guard let strongSelf = self else { return }
        strongSelf.addMarkers(places)
      }
      .store(in: &cancellables)
    
    viewModel?.$deviceLocation
      .receive(on: DispatchQueue.main)
      .sink { [weak self] (coordinate) in
        guard let strongSelf = self, let coordinate = coordinate else { return }
        let camera = GMSCameraPosition(latitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 14)
        strongSelf.mapView.camera = camera
        strongSelf.viewModel?.coordinate = coordinate
      }
      .store(in: &cancellables)
  }
  
  private func addMarkers(_ places: [Place]) {
    mapView.clear()
    markers.removeAll()
    var bounds = GMSCoordinateBounds()
    places.forEach { (place) in
      let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: place.lat, longitude: place.lon))
      marker.title = place.info.name
      marker.map = mapView
      markers[marker] = place
      bounds = bounds.includingCoordinate(marker.position)
    }
    let update = GMSCameraUpdate.fit(bounds, withPadding: 60)
    mapView.animate(with: update)
  }
}

extension MapViewController: GMSMapViewDelegate {
  func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
    guard isUserInteraction else { return }
    viewModel?.coordinate = position.target
  }
  
  func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
    isUserInteraction = gesture
  }
  
  func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
    guard let place = markers[marker] else { return }
    let detailsView = PlaceDetailsView(place: place)
    present(UIHostingController(rootView: detailsView), animated: true)
  }
}
