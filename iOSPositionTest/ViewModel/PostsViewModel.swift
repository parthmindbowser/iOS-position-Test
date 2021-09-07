//
//  PostsViewModel.swift
//  iOSPositionTest
//
//  Created by Parth Dumaswala on 03/09/21.
//

import UIKit
import RxSwift
import RxCocoa

class PostsViewModel {
    
    let request = APIRequest()
    var posts: Observable<[PostsModel]>?
    private let postsViewModel = BehaviorRelay<[PostsModel]>(value: [])
    var postViewModelObserver: Observable<[PostsModel]> {
        return postsViewModel.asObservable()
    }
    
    private let disposeBag = DisposeBag()
    
    func fetchPostsList() {
        posts = request.callAPIForPosts()
        posts?.subscribe(onNext: { (value) in
            
            ///Delete old data and replace with new.
            OfflineDataManager.truncateTable(Constant.TblEntities.kTblPosts)
            
            for (_, dict) in value.enumerated() {
                
                OfflineDataManager.insertDatainTblPost(objPostIs: dict)
            }
            self.postsViewModel.accept(value)
            
        }, onError: { (error) in
            _ = self.postsViewModel.catch { (error) in
                Observable.empty()
            }
            print("\(#function) \(error.localizedDescription)")
        }).disposed(by: disposeBag)
    }
}
