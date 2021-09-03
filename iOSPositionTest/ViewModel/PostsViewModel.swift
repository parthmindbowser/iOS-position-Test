//
//  PostsViewModel.swift
//  iOSPositionTest
//
//  Created by Parth Dumaswala on 03/09/21.
//

import UIKit

class PostsViewModel: NSObject {

    //MARK: Call API Get Post lIst From the Endpoint.
    class func getPostLists(success withResponse: @escaping ([PostsModel]?) -> ()) {
        
        APIManager.makeRequest(Constant.serverAPI.URL.kPosts, withRequest: nil, withSuccess: { (response) in
            
            var arrPost = [PostsModel]()
            
            if let arrData = response {
                
                ///Delete old data and replace with new.
                OfflineDataManager.truncateTable(Constant.TblEntities.kTblPosts)
                
                for (_, dict) in arrData.enumerated() {
                    let obj = PostsModel.init(dict)
                    arrPost.append(obj)
                    
                    //Insert Posts data in Offline.
                    OfflineDataManager.insertDatainTblPost(objPostIs: obj)
                }
                withResponse(arrPost)
            }
        }, failure: { (error) in
            print(error)
        })
    }
}
