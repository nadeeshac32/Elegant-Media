//
//  Map_VC.swift
//  Elegant Media
//
//  Created by Nadeesha Chandrapala on 2022-05-19.
//

import UIKit
import MapKit

class MapVC: BaseVC<MapVM> {
    
    @IBOutlet weak var mapView: MKMapView!
    
    deinit { print("deinit MapVC") }
        
    override func customiseView() {
        super.customiseView()
        self.title                                          = "Map"
        
        guard let latitude = viewModel?.item.latitudeCGFloat, let longitude = viewModel?.item.longitudeCGFloat else { return }
        
        let annotations = MKPointAnnotation()
        annotations.title = viewModel?.item.title ?? ""
        annotations.subtitle = viewModel?.item.address ?? ""
        annotations.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        
        let coordinateRegion = MKCoordinateRegion(center: annotations.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.addAnnotation(annotations)
    }
}
