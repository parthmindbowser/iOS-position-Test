//
//  CommentsViewModel.swift
//  iOSPositionTest
//
//  Created by Parth Dumaswala on 03/09/21.
//

import UIKit

class CommentsViewModel {
    
    //MARK: Call API Get Comments lIst From the Endpoint.
    class func getCommentsFromServer(success withResponse: @escaping ([CommentsModel]?) -> ()) {
        
        APIManager.makeRequest(Constant.serverAPI.URL.kComments, withRequest: nil, withSuccess: { (response) in
            
            var arrComment = [CommentsModel]()
            
            if let arrData = response {
                ///Delete old data and replace with new.
                OfflineDataManager.truncateTable(Constant.TblEntities.kTblComments)
                
                for (_, dict) in arrData.enumerated() {
                    let obj = CommentsModel.init(dict)
                    arrComment.append(obj)
                    
                    //Insert Comment data in Offline.
                    OfflineDataManager.insertDatainTblComment(objCommentIs: obj)
                }
                withResponse(arrComment)
            }
        }, failure: { (error) in
            print(error)
        })
    }
}
