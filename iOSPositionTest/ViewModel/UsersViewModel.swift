//
//  UsersViewModel.swift
//  iOSPositionTest
//
//  Created by Parth Dumaswala on 03/09/21.
//

import UIKit

class UsersViewModel {
    
    //MARK: Call API Get User lIst From the Endpoint.
    class func getUsersFromServer(success withResponse: @escaping ([UsersModel]?) -> ()) {
        
        APIManager.makeRequest(Constant.serverAPI.URL.kUsers, withRequest: nil, withSuccess: { (response) in
            
            var arrUser = [UsersModel]()
            
            if let arrData = response {
                ///Delete old data and replace with new.
                OfflineDataManager.truncateTable(Constant.TblEntities.kTblUsers)
                
                for (_, dict) in arrData.enumerated() {
                    let obj = UsersModel.init(dict)
                    arrUser.append(obj)
                    
                    //Insert Users data in Offline.
                    OfflineDataManager.insertDatainTblUser(objUserIs: obj)
                }
                withResponse(arrUser)
            }
        }, failure: { (error) in
            print(error)
        })
    }
}
