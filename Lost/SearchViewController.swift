//
//  SearchViewController.swift
//  Lost
//
//  Created by 中尾開 on 2020/10/16.
//  Copyright © 2020 kai.nakao. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import Firebase
import FloatingPanel

class SearchViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, CAAnimationDelegate, FloatingPanelControllerDelegate {
    
    @IBAction func settingButton(_ sender: Any) {
        let settingViewController = self.storyboard?.instantiateViewController(withIdentifier: "Setting")
        self.navigationController?.pushViewController(settingViewController!, animated: true)
    }
    @IBOutlet weak var outletsettingButton: UIButton!
    
    @IBOutlet weak var outletpostButton: UIButton!
    @IBAction func postButton(_ sender: Any) {
        let stickPinViewController = self.storyboard?.instantiateViewController(withIdentifier: "StickPin")
        self.navigationController?.pushViewController(stickPinViewController!, animated: true)
        
    }
    var locationManager = CLLocationManager()
    lazy var mapView = GMSMapView()
    
    var postArray: [PostData] = []
    var listener: ListenerRegistration!
    var marker: GMSMarker!
    var fpc: FloatingPanelController!
    var selected_marker: GMSMarker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.outletpostButton.layer.cornerRadius = 10.0
        let picture = UIImage(named: "camera")
        self.outletpostButton.setImage(picture, for: .normal)
        self.outletpostButton.layer.masksToBounds = true
        
        self.outletsettingButton.layer.cornerRadius = 10.0
        let pictures = UIImage(named: "mypage")
        self.outletsettingButton.setImage(pictures, for: .normal)
        self.outletsettingButton.layer.masksToBounds = true
        
        
        if Auth.auth().currentUser == nil {
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(loginViewController!, animated: true, completion: nil)
        }
        
        
        let camera = GMSCameraPosition.camera(withLatitude: 37.3318, longitude: -122.0312, zoom: 17.0)
        mapView = GMSMapView.map(withFrame: CGRect(origin: .zero, size: view.bounds.size), camera: camera)
        mapView.settings.myLocationButton = true //右下のボタン追加する
        mapView.isMyLocationEnabled = true
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        
        
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        
        self.view.addSubview(mapView)
        self.view.bringSubviewToFront(mapView)
        self.view.bringSubviewToFront(outletpostButton)
        self.view.bringSubviewToFront(outletsettingButton)
        
        // Creates a marker in the center of the map.
        // Do any additional setup after loading the view.
    }
    func setPostData(_ postData:PostData) {
        
        
      if ( postData.latitude! != nil && postData.longitude! != nil ) {
        let marker = GMSMarker()
        
        marker.userData = postData
        marker.position = CLLocationCoordinate2D(latitude: postData.latitude!, longitude: postData.longitude!)
        marker.title = "Lost Thing"
        marker.icon = UIImage(named: "pin")
        
        marker.map = mapView
      }
      else {
        print("no latitude & longitude")
      }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        
        print("DEBUG_PRINT: viewWillAppear")
        
        if Auth.auth().currentUser != nil {
            if listener == nil {
                let postRef = Firestore.firestore().collection(Const.PostPath)
                listener = postRef.addSnapshotListener() { (querySnapshot, error) in
                    if let error = error {
                        print("DEBUG_PRINT: snapshotの取得に失敗しました。\(error)")
                        return
                    }
                    self.mapView.clear()
                    self.postArray = querySnapshot!.documents.map { document in
                        
                        
                        print("DEBUG_PRINT: document取得 \(document.documentID)")

                        let postData = PostData(document: document)
                        self.setPostData(postData)
                        return postData
                    }
                }
            } else {
                if listener != nil {
                    listener.remove()
                    listener = nil
                    postArray = []
                }
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        let postData = marker.userData as! PostData
        
        
        
        if ( selected_marker != nil) {
            selected_marker.icon = self.imageWithImage(image: UIImage(named: "pin")!, scaledToSize: CGSize(width: 32.0, height: 50.0))
            selected_marker = marker
        }
        else {
            selected_marker = marker
        }

        marker.icon = self.imageWithImage(image: UIImage(named: "pin")!, scaledToSize: CGSize(width: 50.0, height: 68.0))
        
        
        
        let showPostVC = ShowPostViewController()
        
        marker.tracksViewChanges = true
        
        let showPostViewController = storyboard!.instantiateViewController(withIdentifier: "ShowPost") as! ShowPostViewController
        showPostViewController.postData = postData
        
        if fpc != nil {
            fpc.removePanelFromParent(animated: true)
        }
        fpc = FloatingPanelController(delegate: self)
        
        fpc.layout = MyFloatingPanelLayout()
        fpc.set(contentViewController: showPostViewController)
        
        fpc.surfaceView.layer.cornerRadius = 24.0
        fpc.surfaceView.layer.masksToBounds = true
        fpc.isRemovalInteractionEnabled = true
        fpc.addPanel(toParent: self)
        
        return true
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser == nil {
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(loginViewController!, animated: true, completion: nil)
        }
    }
    func imageWithImage(image: UIImage, scaledToSize newSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        image.draw(in: CGRect(x: 0, y:0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    func floatingPanelDidRemove(_ fpc: FloatingPanelController) {
        selected_marker.icon = self.imageWithImage(image: UIImage(named: "pin")!, scaledToSize: CGSize(width: 32.0, height: 50.0))
    }
}
class MyFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip
    var anchors: [FloatingPanelState : FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 350.0, edge: .top, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(absoluteInset: 200.0, edge: .bottom, referenceGuide: .safeArea),
            .tip:FloatingPanelLayoutAnchor(absoluteInset: 199, edge: .bottom, referenceGuide: .safeArea),
        ]
    }
}
