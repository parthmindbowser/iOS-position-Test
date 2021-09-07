//
//  PostListVC.swift
//  iOSPositionTest
//
//  Created by Parth Dumaswala on 02/09/21.
//

import UIKit
import RxSwift
import RxCocoa
import CoreData

class PostListVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet var tblPosts: UITableView!
    
    //MARK:- Variables
    private var arrPosts = [PostsModel]()
    private let disposeBag = DisposeBag()
    
    let postsViewModelInstance = PostsViewModel()
    let postList = BehaviorRelay<[PostsModel]>(value: [])
    var detailController: PostDetailVC?
    
    //MARK:- Page Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.checkAndgetPostsFromOffline()
    }
    
    //MARK:- Private Methods
    private func bindUI(isUpdateData:Bool = true) {
        
        //Here we subscribe the subject in viewModel to get the value here
        postsViewModelInstance.postViewModelObserver.subscribe(onNext: { (value) in
            
            if isUpdateData {
                self.postList.accept(value)
            }
        },onError: { error in
            print(error)
        }).disposed(by: self.disposeBag)
        
        tblPosts.tableFooterView = UIView()
        
        //This binds the table datasource with tableview and also connects the cell to it.
        postList.asObservable().bind(to: tblPosts.rx.items(cellIdentifier: "PostListCell", cellType: PostListCell.self)) { row, model, cell in
            
            cell.lblPostTitle.text = model.title
            cell.lblPostBody.text = model.body
            cell.lblUser.text = ""
            
        }.disposed(by: disposeBag)
        
        self.tblPosts.reloadData()
        
        //Replacement to didSelectRowAt() of tableview delegate functions
        tblPosts.rx.itemSelected.subscribe(onNext: { (indexPath) in
            
            self.tblPosts.deselectRow(at: indexPath, animated: true)
            
            let objVC = AppStoryboard.Posts.getVC(viewController: PostDetailVC.self)
            objVC.objPost = self.postList.value[indexPath.row]
            self.navigationController?.pushViewController(objVC, animated: true)
            
        }).disposed(by: self.disposeBag)
    }
    
    private func checkAndgetPostsFromOffline() {
        
        OfflineDataManager.getAllPostsOffline { arr in
            
            if arr.count == 0 { //It means first launch. then Get from server
                
                DispatchQueue.main.async {
                    self.postsViewModelInstance.fetchPostsList()
                    self.bindUI()
                }
            } else {
                
                DispatchQueue.main.async {
                    self.postList.accept(arr)
                    self.bindUI(isUpdateData: false)
                }
            }
        }
    }
}

