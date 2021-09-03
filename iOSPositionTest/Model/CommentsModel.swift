//
//  CommentsModel.swift
//  iOSPositionTest
//
//  Created by Parth Dumaswala on 03/09/21.
//

import UIKit

class CommentsModel {
    
    var postId: Int
    var id: Int
    var name: String
    var body: String
    var email: String
    
    init(_ dict: [String : Any]) {
        
        self.postId = dict["postId"] as? Int ?? 0
        self.id = dict["id"] as? Int ?? 0
        self.name = dict["name"] as? String ?? ""
        self.body = dict["body"] as? String ?? ""
        self.email = dict["email"] as? String ?? ""
    }
}
