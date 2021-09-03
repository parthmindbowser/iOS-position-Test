//
//  AppDelegate.swift
//  iOSPositionTest
//
//  Created by Parth Dumaswala on 02/09/21.
//

import UIKit
import Foundation

let PostStoryboard = AppStoryboard.Posts.instance

enum AppStoryboard : String {
    
    case Posts
    
    var instance : UIStoryboard {
      return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func getVC<T : UIViewController>(viewController: T.Type) -> T {
        
        let storyboardId = (viewController as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardId) as! T
    }
}
