//
//  Utilities.swift
//  iOSPositionTest
//
//  Created by Parth Dumaswala on 03/09/21.
//

import CoreLocation
import Foundation
import UIKit

class UserDefaultHelper: NSObject {
    typealias JSON = [String: Any]
    
    // MARK: - set and get preferences for String
    
    /*!
     method getPreferenceValueForKey
     abstract To get the preference value for the key that has been passed
     */
    class func getPREF(_ key: String) -> String? {
        return Foundation.UserDefaults.standard.value(forKey: key) as? String
    }
    
    /*!
     method setPreferenceValueForKey for int value
     abstract To set the preference value for the key that has been passed
     */
    
    class func setPREF(_ sValue: String, key: String) {
        Foundation.UserDefaults.standard.setValue(sValue, forKey: key)
        Foundation.UserDefaults.standard.synchronize()
    }
    
    /*!
     method delPREF for string
     abstract To delete the preference value for the key that has been passed
     */
    
    class func delPREF(_ key: String) {
        Foundation.UserDefaults.standard.removeObject(forKey: key)
        Foundation.UserDefaults.standard.synchronize()
    }
    
    // MARK: - set and get preferences for Integer
    
    /*!
     method getPreferenceValueForKey for array for int value
     abstract To get the preference value for the key that has been passed
     */
    class func getIntPREF(_ key: String) -> Int? {
        return Foundation.UserDefaults.standard.object(forKey: key) as? Int
    }
    
    /*!
     method setPreferenceValueForKey
     abstract To set the preference value for the key that has been passed
     */
    
    class func setIntPREF(_ sValue: Int, key: String) {
        Foundation.UserDefaults.standard.setValue(sValue, forKey: key)
        Foundation.UserDefaults.standard.synchronize()
    }
    
    /*!
     method delPREF for integer
     abstract To delete the preference value for the key that has been passed
     */
    
    class func delIntPREF(_ key: String) {
        Foundation.UserDefaults.standard.removeObject(forKey: key)
        Foundation.UserDefaults.standard.synchronize()
    }
    
    // MARK: - set and get preferences for Double
    
    /*!
     method getPreferenceValueForKey for array for int value
     abstract To get the preference value for the key that has been passed
     */
    class func getDoublePREF(_ key: String) -> Double? {
        return Foundation.UserDefaults.standard.object(forKey: key) as? Double
    }
    
    /*!
     method setPreferenceValueForKey
     abstract To set the preference value for the key that has been passed
     */
    
    class func setDoublePREF(_ sValue: Double, key: String) {
        Foundation.UserDefaults.standard.setValue(sValue, forKey: key)
        Foundation.UserDefaults.standard.synchronize()
    }
    
    // MARK: - set and get preferences for Array
    
    /*!
     method getPreferenceValueForKey for array
     abstract To get the preference value for the key that has been passed
     */
    class func getIntArrPREF(_ key: String) -> [Int]? {
        return Foundation.UserDefaults.standard.object(forKey: key) as? [Int]
    }
    
    class func getArrPREF(_ key: String) -> [String]? {
        return Foundation.UserDefaults.standard.object(forKey: key) as? [String]
    }
    
    /*!
     method setPreferenceValueForKey for array
     abstract To set the preference value for the key that has been passed
     */
    
    class func setArrIntPREF(_ sValue: [Int], key: String) {
        Foundation.UserDefaults.standard.set(sValue, forKey: key)
        Foundation.UserDefaults.standard.synchronize()
    }
    
    class func setArrPREF(_ sValue: [String], key: String) {
        Foundation.UserDefaults.standard.set(sValue, forKey: key)
        Foundation.UserDefaults.standard.synchronize()
    }
    
    /*!
     method delPREF
     abstract To delete the preference value for the key that has been passed
     */
    
    class func delArrPREF(_ key: String) {
        Foundation.UserDefaults.standard.removeObject(forKey: key)
        Foundation.UserDefaults.standard.synchronize()
    }
    
    // MARK: - set and get preferences for Boolean
    
    /*!
     method getPreferenceValueForKey for boolean
     abstract To get the preference value for the key that has been passed
     */
    class func getBoolPREF(_ key: String) -> Bool? {
        return Foundation.UserDefaults.standard.bool(forKey: key)
    }
    
    /*!
     method setBoolPreferenceValueForKey
     abstract To set the preference value for the key that has been passed
     */
    
    class func setBoolPREF(_ sValue: Bool, key: String) {
        Foundation.UserDefaults.standard.set(sValue, forKey: key)
        Foundation.UserDefaults.standard.synchronize()
    }
    
    /*!
     method delPREF for boolean
     abstract To delete the preference value for the key that has been passed
     */
    
    class func delBoolPREF(_ key: String) {
        Foundation.UserDefaults.standard.removeObject(forKey: key)
        Foundation.UserDefaults.standard.synchronize()
    }
}

extension Foundation.UserDefaults {
    func decode<T: Codable>(for type: T.Type, using key: String) -> T? {
        let defaults = Foundation.UserDefaults.standard
        guard let data = defaults.object(forKey: key) as? Data else { return nil }
        let decodedObject = try? PropertyListDecoder().decode(type, from: data)
        return decodedObject
    }
    
    func encode<T: Codable>(for type: T, using key: String) {
        let defaults = Foundation.UserDefaults.standard
        let encodedData = try? PropertyListEncoder().encode(type)
        defaults.set(encodedData, forKey: key)
        defaults.synchronize()
    }
}
