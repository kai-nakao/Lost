//
//  PostViewController.swift
//  Lost
//
//  Created by 中尾開 on 2020/10/16.
//  Copyright © 2020 kai.nakao. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import CoreLocation

class PostViewController: UIViewController {
    var image: UIImage!
    
    var coordinate: CLLocationCoordinate2D!
    
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBAction func handlePostButton(_ sender: Any) {
        
        let imageData = image.jpegData(compressionQuality: 0.75)
        
        let postRef = Firestore.firestore().collection(Const.PostPath).document()
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postRef.documentID + ".jpg")
        SVProgressHUD.show()
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(imageData!, metadata: metadata) { (metadata, error) in
            if error != nil {
                print(error!)
                SVProgressHUD.showError(withStatus: "画像のアップロードに失敗しました。")
                UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
                return
            }
            
            let postDic = [
                "caption": self.textField.text!,
                "date": FieldValue.serverTimestamp(),
                "location": self.locationTextField.text!,
                "latitude": self.coordinate.latitude,
                "longitude": self.coordinate.longitude
                ] as [String : Any]
            postRef.setData(postDic)
            
            SVProgressHUD.showSuccess(withStatus: "投稿しました。")
            UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController? .dismiss(animated: true, completion: nil)
            
            let navigationController = UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController as! UINavigationController
            navigationController.popViewController(animated: true)
        }
    }
    @IBAction func handleCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
                
        imageView.image = image

    }
    
}
