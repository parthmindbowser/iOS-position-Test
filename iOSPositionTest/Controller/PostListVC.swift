//
//  PostListVC.swift
//  iOSPositionTest
//
//  Created by Parth Dumaswala on 02/09/21.
//

import UIKit

class PostListVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet var tblPosts: UITableView!
    
    //MARK:- Variables
    private var arrPosts = [PostsModel]()
    
    //MARK:- Page Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.initialConfig()
    }
    
    //MARK:- Private Methods
    private func initialConfig() {
        
        self.checkAndgetPostsFromOffline()
    }
    
    private func getPostsFromServer() {
        
        PostsViewModel.getPostLists { arrData in
            if let _ = arrData {
                self.arrPosts = arrData!
                self.tblPosts.reloadData()
            }
        }
    }
    
    private func checkAndgetPostsFromOffline() {
        
        OfflineDataManager.getAllPostsOffline { arr in
            
            if arr.count == 0 { //It means first launch. then Get from server
                
                DispatchQueue.main.async {
                    self.getPostsFromServer()
                }
            } else {
                DispatchQueue.main.async {
                    self.arrPosts = arr
                    self.tblPosts.reloadData()
                }
            }
        }
    }
}

//MARK:- UITableView Delegate & DataSource
extension PostListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostListCell", for: indexPath) as? PostListCell else {
            return UITableViewCell()
        }
        let objData = self.arrPosts[indexPath.row]
        
        cell.lblPostTitle.text = objData.title
        cell.lblPostBody.text = objData.body
        cell.lblUser.text = ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let objPostDetailVC = AppStoryboard.Posts.getVC(viewController: PostDetailVC.self)
        objPostDetailVC.objPost = self.arrPosts[indexPath.row]
        self.navigationController?.pushViewController(objPostDetailVC, animated: true)
    }
}
