//
//  CommentsViewModel.swift
//  iOSPositionTest
//
//  Created by Parth Dumaswala on 03/09/21.
//

import UIKit
import RxSwift
import RxCocoa

class CommentsViewModel {
    
    let request = APIRequest()
    var comments: Observable<[CommentsModel]>?
    private let commentViewModel = BehaviorRelay<[CommentsModel]>(value: [])
    var commentViewModelObserver: Observable<[CommentsModel]> {
        return commentViewModel.asObservable()
    }
    
    private let disposeBag = DisposeBag()
    
    func fetchCommentList() {
        
        comments = request.callAPIForComments()
        comments?.subscribe(onNext: { (value) in
            
            ///Delete old data and replace with new.
            OfflineDataManager.truncateTable(Constant.TblEntities.kTblComments)
            
            for (_, dict) in value.enumerated() {
              
                //Insert Comment data in Offline.
                OfflineDataManager.insertDatainTblComment(objCommentIs: dict)
            }
            self.commentViewModel.accept(value)
            
        }, onError: { (error) in
            _ = self.commentViewModel.catch { (error) in
                Observable.empty()
            }
            print("\(#function) \(error.localizedDescription)")
        }).disposed(by: disposeBag)
    }
}
