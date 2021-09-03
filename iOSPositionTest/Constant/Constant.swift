//
//  AppDelegate.swift
//  iOSPositionTest
//
//  Created by Parth Dumaswala on 02/09/21.
//

import Foundation
import CoreBluetooth

class Constant {
    
    //MARK:- API Constants
    struct serverAPI {
        
        struct URL {
            
            static let kBaseURL = "http://jsonplaceholder.typicode.com/"
            
            //Posts
            static let kPosts = kBaseURL + "posts"
            //Users
            static let kUsers = kBaseURL + "users"
            //Comments
            static let kComments = kBaseURL + "comments"
        }
        
        struct errorMessages {
            static let NoInternetConnectionMessage = "Please check your internet connection."
            static let ServerDownError = "The server might be down, please try again later."
            static let SomethingWentWrong = "Something went wrong, please try again later."
        }
    }
    
    struct TblEntities {
        static let kTblPosts = "TblPosts"
        static let kTblUsers = "TblUsers"
        static let kTblComments = "TblComments"
    }
    
    struct Keys {
        static let kApplaunchedFirstTime = "isAppLaunched"
    }
}
