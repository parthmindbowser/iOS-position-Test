//
//  UsersModel.swift
//  iOSPositionTest
//
//  Created by Parth Dumaswala on 03/09/21.
//

import UIKit

class UsersModel {
    
    var id: Int
    var name: String
    var username: String
    var email: String
    ///Address
    var street: String?
    var suite: String?
    var city: String?
    var zipcode: String?
    ///Geo
    var lat: String?
    var lng: String?
    var arrUserComments = [CommentsModel]()
    
    init(_ dict: [String : Any]) {
        
        self.id = dict["id"] as? Int ?? 0
        self.name = dict["name"] as? String ?? ""
        self.username = dict["username"] as? String ?? ""
        self.email = dict["email"] as? String ?? ""
        
        if let dictAddress = dict["address"] as? [String: Any] {
            self.street = dictAddress["street"] as? String ?? ""
            self.suite = dictAddress["suite"] as? String ?? ""
            self.city = dictAddress["city"] as? String ?? ""
            self.zipcode = dictAddress["zipcode"] as? String ?? ""
        }
        if let dictGeo = dict["geo"] as? [String: Any] {
            self.lat = dictGeo["lat"] as? String ?? ""
            self.lng = dictGeo["lng"] as? String ?? ""
        }
    }
}
