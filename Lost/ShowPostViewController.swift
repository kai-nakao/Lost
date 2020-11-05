//
//  ShowPostViewController.swift
//  Lost
//
//  Created by 中尾開 on 2020/10/23.
//  Copyright © 2020 kai.nakao. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseFirestore



class ShowPostViewController: UIViewController {
    var db: Firestore!
    var postData: PostData!
    
    
    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var showCaption: UILabel!
    @IBOutlet weak var showLocation: UILabel!
    @IBOutlet weak var showDateLabel: UILabel!
    @IBAction func completionReceive(_ sender: Any) {
        
        let db = Firestore.firestore()
        
        db.collection("posts").document(postData.id).delete() { err in
            print("postData.id\(self.postData.id)")
            
            
            
            self.dismiss(animated: true, completion: nil)
            
            
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    @IBAction func handleBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func setData(_ postData: PostData) {
        
        showImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        showImageView.sd_setImage(with: imageRef)
        
        self.showDateLabel.text = ""
        if let date = postData.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyy-MM-dd HH:mm"
            let dateString = formatter.string(from: date)
            self.showDateLabel.text = dateString
        }
        
        self.showCaption.text = ""
        if let caption = postData.caption {
            self.showCaption.text = caption
        }
        self.showLocation.text = ""
        if let location = postData.location {
            self.showLocation.text = location
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.setData(postData)
        // Do any additional setup after loading the view.
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
