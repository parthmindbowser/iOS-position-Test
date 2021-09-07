//
//  PostDetailVC.swift
//  iOSPositionTest
//
//  Created by Parth Dumaswala on 02/09/21.
//

import UIKit
import RxSwift
import RxCocoa

class PostDetailVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var lblPostTitle: UILabel!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblPostBody: UILabel!
    
    //MARK:- Variables
    var objPost:PostsModel?
    
    private var objUser:UsersModel?
    private let usersViewModelInstance = UsersViewModel()
    private let userList = BehaviorRelay<[UsersModel]>(value: [])
    private let commentViewModelInstance = CommentsViewModel()
    private let commentList = BehaviorRelay<[CommentsModel]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    //MARK:- Page Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if let isApplaunched = UserDefaultHelper.getBoolPREF(Constant.Keys.kApplaunchedFirstTime), !isApplaunched { ///Load data from offline Db from second onwards
            
            self.commentViewModelInstance.fetchCommentList()
            self.usersViewModelInstance.fetchUserList()
            
            self.bindUsersData()
            self.bindCommentData()
            
            self.onSetDetails()
        } else {
            self.getPostDetailsFromOffline()
        }
    }
    
    //MARK:- Private Methods
    private func bindUsersData() {
        
        usersViewModelInstance.userViewModelObserver.subscribe(onNext: { (value) in
            
            self.objUser = value.first(where: {$0.id == self.objPost?.userId})
            self.userList.accept(value)
            UserDefaultHelper.setBoolPREF(true, key: Constant.Keys.kApplaunchedFirstTime)
            
            DispatchQueue.main.async {
                self.lblUserName.text = self.objUser?.name
            }
        },onError: { error in
            print(error)
        }).disposed(by: self.disposeBag)
    }
    
    private func bindCommentData() {
        
        commentViewModelInstance.commentViewModelObserver.subscribe(onNext: { (value) in
            
            self.commentList.accept(value.filter({$0.postId == self.objPost?.id}))
        },onError: { error in
            print(error)
        }).disposed(by: self.disposeBag)
        
        self.tableView.tableFooterView = UIView()
        
        commentList.asObservable().bind(to: tableView.rx.items(cellIdentifier: "CommentListCell", cellType: CommentListCell.self)) { row, objData, cell in
            
            cell.lblUserName.text = objData.name
            cell.lblEmail.text = objData.email
            cell.lblComment.text = objData.body
            
        }.disposed(by: disposeBag)
    }
    
    private func onSetDetails() {
        
        self.lblPostTitle.text = self.objPost?.title
        self.lblPostBody.text = self.objPost?.body
    }
    
    private func getPostDetailsFromOffline() {
        
        if let postId = self.objPost?.id {
            OfflineDataManager.getPostCommentsById(postId: postId) { arrData in
                
                DispatchQueue.main.async {
                    self.commentList.accept(arrData.filter({$0.postId == self.objPost?.id}))
                    
                    self.tableView.tableFooterView = UIView()
                    
                    self.commentList.asObservable().bind(to: self.tableView.rx.items(cellIdentifier: "CommentListCell", cellType: CommentListCell.self)) { row, objData, cell in
                        
                        cell.lblUserName.text = objData.name
                        cell.lblEmail.text = objData.email
                        cell.lblComment.text = objData.body
                        
                    }.disposed(by: self.disposeBag)
                    
                    self.tableView.reloadData()
                    
                    if let userId = self.objPost?.userId {
                        OfflineDataManager.getUserDetailById(idIs: userId) { obj in
                            self.objUser = obj
                            self.lblUserName.text = self.objUser?.name
                        }
                    }
                    self.onSetDetails()
                }
            }
        }
    }
}

