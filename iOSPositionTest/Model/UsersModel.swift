//
//  UsersModel.swift
//  iOSPositionTest
//
//  Created by Parth Dumaswala on 03/09/21.
//

import UIKit

import Foundation

struct UsersModel : Codable {
    
    var id : Int?
    var name : String?
    var username : String?
    var email : String?
    var address : Address?
    var phone : String?
    var website : String?
    var company : Company?
}

struct Company : Codable {
    
    let name : String?
    let catchPhrase : String?
    let bs : String?
}

struct Geo : Codable {
    
    let lat : String?
    let lng : String?
}

struct Address : Codable {
    
    let street : String?
    let suite : String?
    let city : String?
    let zipcode : String?
    let geo : Geo?
}
