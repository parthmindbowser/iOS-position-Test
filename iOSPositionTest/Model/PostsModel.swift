//
//  PostsModel.swift
//  iOSPositionTest
//
//  Created by Parth Dumaswala on 03/09/21.
//

import UIKit

class PostsModel {

    var userId: Int
    var id: Int
    var title: String
    var body: String
    
    init(_ dict: [String : Any]) {
        
        self.userId = dict["userId"] as? Int ?? 0
        self.id = dict["id"] as? Int ?? 0
        self.title = dict["title"] as? String ?? ""
        self.body = dict["body"] as? String ?? ""
    }
}
