//
//  CommentsModel.swift
//  iOSPositionTest
//
//  Created by Parth Dumaswala on 03/09/21.
//

import UIKit

struct CommentsModel : Codable {
    
    var postId : Int?
    var id : Int?
    var name : String?
    var email : String?
    var body : String?
}
