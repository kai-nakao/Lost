//
//  StickPinViewController.swift
//  Lost
//
//  Created by 中尾開 on 2020/10/24.
//  Copyright © 2020 kai.nakao. All rights reserved.
//

import UIKit
import GoogleMaps

class StickPinViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var locationManager = CLLocationManager()
    var coordinate: CLLocationCoordinate2D!
    
    
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        let actionSheet = UIAlertController(title: "落とし物の写真", message: "全体が写っている写真にしましょう。", preferredStyle: UIAlertController.Style.actionSheet)
        
        let action1 = UIAlertAction(title: "写真を選ぶ", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let pickerController = UIImagePickerController()
                pickerController.delegate = self
                pickerController.sourceType = .photoLibrary
                self.present(pickerController, animated: true, completion: nil)
            }
            print("フォトライブラリが選択されました。")
        })
        let action2 = UIAlertAction(title: "カメラで撮る", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let pickerController = UIImagePickerController()
                pickerController.delegate = self
                pickerController.sourceType = .camera
                self.present(pickerController, animated: true, completion: nil)
            }
            print("カメラで撮るが選択されました。")
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: {
            (ation: UIAlertAction!) ->Void in
            self.presentingViewController?.dismiss(animated: true, completion: nil)
            print("キャンセル")
        })
        
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[.originalImage] != nil {
            let image = info[.originalImage] as! UIImage
            print("DEBUG_PRINT: image = \(image)")
            let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! PostViewController
            postViewController.image = image
            postViewController.coordinate = coordinate
            picker.present(postViewController, animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
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
