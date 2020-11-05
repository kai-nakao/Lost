//
//  StickPinViewController.swift
//  Lost
//
//  Created by 中尾開 on 2020/10/24.
//  Copyright © 2020 kai.nakao. All rights reserved.
//

import UIKit
import GoogleMaps

class StickPinViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    
    var locationManager = CLLocationManager()
    
    
    
    lazy var mapView = GMSMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        
        
        let camera = GMSCameraPosition.camera(withLatitude: 37.3318, longitude: -122.0312, zoom: 17.0)
        mapView = GMSMapView.map(withFrame: CGRect(origin: .zero, size: view.bounds.size), camera: camera)
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        self.view.addSubview(mapView)
        self.view.bringSubviewToFront(mapView)
        
        
    }
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager, didUpdateLocations location: [CLLocation]) {
        let userLocation = location.last
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.latitude, zoom: 17.0)
        self.mapView.animate(to: camera)
    }
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        
        let imageSelectViewController = self.storyboard?.instantiateViewController(withIdentifier: "ImageSelect") as! ImageSelectViewController
        imageSelectViewController.coordinate = coordinate
        self.present(imageSelectViewController, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
