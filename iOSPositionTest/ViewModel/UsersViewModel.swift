//
//  UsersViewModel.swift
//  iOSPositionTest
//
//  Created by Parth Dumaswala on 03/09/21.
//

import UIKit
import RxSwift
import RxCocoa

class UsersViewModel {
    
    let request = APIRequest()
    var users: Observable<[UsersModel]>?
    private let userViewModel = BehaviorRelay<[UsersModel]>(value: [])
    var userViewModelObserver: Observable<[UsersModel]> {
        return userViewModel.asObservable()
    }
    
    private let disposeBag = DisposeBag()
    
    func fetchUserList() {
        
        users = request.callAPIForUsers()
        users?.subscribe(onNext: { (value) in
            
            ///Delete old data and replace with new.
            OfflineDataManager.truncateTable(Constant.TblEntities.kTblUsers)
            
            for (_, dict) in value.enumerated() {
                
                //Insert Users data in Offline.
                OfflineDataManager.insertDatainTblUser(objUserIs: dict)
            }
            
            self.userViewModel.accept(value)
            
        }, onError: { (error) in
            _ = self.userViewModel.catch { (error) in
                Observable.empty()
            }
            print("\(#function) \(error.localizedDescription)")
        }).disposed(by: disposeBag)
    }
}
