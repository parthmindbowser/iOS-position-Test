//
//  PostDetailVC.swift
//  iOSPositionTest
//
//  Created by Parth Dumaswala on 02/09/21.
//

import UIKit

class PostDetailVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var lblPostTitle: UILabel!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblPostBody: UILabel!
    
    //MARK:- Variables
    private var arrUsers = [UsersModel]()
    private var arrComments = [CommentsModel]()
    var objPost:PostsModel?
    var objUser:UsersModel?
    
    //MARK:- Page Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.initialConfig()
    }
    
    //MARK:- Private Methods
    private func initialConfig() {
        
        if let isApplaunched = UserDefaultHelper.getBoolPREF(Constant.Keys.kApplaunchedFirstTime), !isApplaunched { ///Load data from offline Db from second onwards
            self.getUserListFromServer()
        } else {
            self.getPostDetailsFromOffline()
        }
    }
    
    private func onSetUserDetails() {
        
        self.lblPostTitle.text = self.objPost?.title
        self.lblPostBody.text = self.objPost?.body
        
        if let userId = self.objPost?.userId {
            OfflineDataManager.getUserDetailById(idIs: userId) { obj in
                self.objUser = obj
                self.lblUserName.text = obj?.name
            }
        }
    }
    
    private func getUserListFromServer() {
        
        UsersViewModel.getUsersFromServer { arr in
            if let _ = arr {
                self.arrUsers = arr!
                self.onSetUserDetails()
            }
            
            DispatchQueue.main.async {
                CommentsViewModel.getCommentsFromServer { arr in
                    if let _ = arr {
                        UserDefaultHelper.setBoolPREF(true, key: Constant.Keys.kApplaunchedFirstTime)
                        
                        DispatchQueue.main.async {
                            self.arrComments = arr?.filter({$0.postId == self.objPost?.id}) ?? []
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    private func getPostDetailsFromOffline() {
        
        if let postId = self.objPost?.id {
            OfflineDataManager.getPostCommentsById(postId: postId) { arrData in
                
                DispatchQueue.main.async {
                    self.arrComments = arrData
                    self.onSetUserDetails()
                    self.tableView.reloadData()
                }
            }
        }
    }
}

//MARK:- UITableView Delegate & DataSource
extension PostDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentListCell", for: indexPath) as? CommentListCell else {
            return UITableViewCell()
        }
        let objData = self.arrComments[indexPath.row]
        
        cell.lblUserName.text = objData.name
        cell.lblEmail.text = objData.email
        cell.lblComment.text = objData.body
        
        return cell
    }
}
