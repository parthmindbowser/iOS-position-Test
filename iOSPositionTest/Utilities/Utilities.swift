//
//  Utilities.swift
//  iOSPositionTest
//
//  Created by Parth Dumaswala on 03/09/21.
//

import UIKit

class Utilities: NSObject {

    //MARK: Check Internet Connection
    static func isConnectedToNetwork() -> Bool {
        
        if(APIManager.checkInternetConnection()) {
            return true
        } else {
            return false
        }
    }
}
