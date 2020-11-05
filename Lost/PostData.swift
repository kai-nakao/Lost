//
//  PostData.swift
//  Lost
//
//  Created by 中尾開 on 2020/10/23.
//  Copyright © 2020 kai.nakao. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class PostData: NSObject {
    var id: String
    var name: String?
    var location: String?
    var caption: String?
    var date: Date?
    var longitude: Double?
    var latitude: Double?
    
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        
        let postDic = document.data()
        
        self.name = postDic["name"] as? String
        
        self.location = postDic["location"] as? String
        
        self.caption = postDic["caption"] as? String
        
        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
        
        self.latitude = postDic["latitude"] as? Double
        self.longitude = postDic["longitude"] as? Double
        
        
    }
    
}
