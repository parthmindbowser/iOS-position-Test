//
//  APIManager.swift
//  iOSPositionTest
//
//  Created by Parth Dumaswala on 03/09/21.
//

import UIKit
import Alamofire
import MBProgressHUD
import SystemConfiguration

private enum StatusCode: Int {
    case success = 200
    case unauthorized = 401
}

class APIManager: NSObject {
    
    static let shared = APIManager()
    let window: UIWindow = UIApplication.shared.windows.last!
    
    /**
     This method is used to make Alamofire request with or without parameters.
     - Parameters:
     - url: URL of request
     - method: HTTPMethod of request
     - parameter: Parameter of request
     - success: Success closure of method
     - response: Response object of request
     - failure: Failure closure of method
     - error: Failure error
     - connectionFailed: Network connection faild closure of method
     - error: Network error
     */
    class func makeRequest(_ URLString: String, method: Alamofire.HTTPMethod = .get, withRequest requestDict: [String: Any]?, withSuccess success: @escaping (_ responseDict: [[String: Any]]?) -> Void, failure: @escaping (_ error: String) -> Void) {
        
        if(Utilities.isConnectedToNetwork()) {
            
            guard let urlIs = URL(string: URLString) else {
                failure("")
                return
            }
            print(urlIs)
            
            MBProgressHUD.showAdded(to: APIManager.shared.window, animated: true)
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: requestDict ?? [:], options: JSONSerialization.WritingOptions.prettyPrinted)
                
                if let jsonString: String = String(data: jsonData, encoding: String.Encoding.utf8) {
                    print(jsonString)
                }
            } catch let error as NSError {
                print(error)
            }
            
            AF.request(urlIs, method: method, parameters: requestDict, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
                
                MBProgressHUD.hide(for: APIManager.shared.window, animated: true)
                
                switch response.result {
                case .success:
                    
                    guard let rsponseData = response.data else {
                        failure("")
                        return
                    }
                    
                    if let responseString: String = String(data: rsponseData, encoding: String.Encoding.utf8) {
                        print(responseString)
                    }
                    
                    //Success
                    if response.response?.statusCode == StatusCode.success.rawValue {
                        if let response = response.value as? [[String: Any]] {
                            success(response)
                        }
                    }
                    //Failure
                    else {
                        failure("")
                    }
                case .failure(let error):
                    print("Request failed with error: \(error.localizedDescription)")
                    failure("")
                }
            })
        }
        else {
            MBProgressHUD.hide(for: APIManager.shared.window, animated: true)
            failure("")
        }
    }
    
    //MARK: Check For Internet Connection
    class func checkInternetConnection() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
}
