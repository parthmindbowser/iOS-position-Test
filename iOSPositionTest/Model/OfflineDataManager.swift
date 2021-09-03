//
//  OfflineDataManager.swift
//  iOSPositionTest
//
//  Created by Parth Dumaswala on 03/09/21.
//

import UIKit
import CoreData

class TblPosts: NSManagedObject {
    
    @NSManaged public var body: String?
    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var userId: Int32
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TblPosts> {
        return NSFetchRequest<TblPosts>(entityName: Constant.TblEntities.kTblPosts)
    }
}

class TblUsers: NSManagedObject {
    
    @NSManaged public var city: String?
    @NSManaged public var email: String?
    @NSManaged public var id: Int32
    @NSManaged public var lat: String?
    @NSManaged public var lng: String?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var street: String?
    @NSManaged public var suite: String?
    @NSManaged public var username: String?
    @NSManaged public var website: String?
    @NSManaged public var zipcode: String?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TblUsers> {
        return NSFetchRequest<TblUsers>(entityName: Constant.TblEntities.kTblUsers)
    }
}

class TblComments: NSManagedObject {
    
    @NSManaged public var body: String?
    @NSManaged public var email: String?
    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var postId: Int32
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TblComments> {
        return NSFetchRequest<TblComments>(entityName: Constant.TblEntities.kTblComments)
    }
}

class OfflineDataManager: NSObject {
    
    class func insertDatainTblPost(objPostIs: PostsModel) {
        
        let context = AppDelegate.appDelegate().managedObjectContext
        if let objPost = NSEntityDescription.insertNewObject(forEntityName: Constant.TblEntities.kTblPosts, into: context) as? TblPosts {
            
            objPost.userId = Int32(objPostIs.userId)
            objPost.id = Int32(objPostIs.id)
            objPost.title = objPostIs.title
            objPost.body = objPostIs.body
            
            do {
                try context.save()
            } catch let error as NSError {
                print("\(#function)", error.localizedDescription)
            }
        }
    }
    
    class func insertDatainTblUser(objUserIs: UsersModel) {
        
        let context = AppDelegate.appDelegate().managedObjectContext
        if let objUser = NSEntityDescription.insertNewObject(forEntityName: Constant.TblEntities.kTblUsers, into: context) as? TblUsers {
            
            objUser.id = Int32(objUserIs.id)
            objUser.name = objUserIs.name
            objUser.username = objUserIs.username
            objUser.email = objUserIs.email
            
            objUser.street = objUserIs.street
            objUser.suite = objUserIs.suite
            objUser.city = objUserIs.city
            objUser.zipcode = objUserIs.zipcode
            
            objUser.lat = objUserIs.lat
            objUser.lng = objUserIs.lng
            
            do {
                try context.save()
            } catch let error as NSError {
                print("\(#function)", error.localizedDescription)
            }
        }
    }
    
    class func insertDatainTblComment(objCommentIs: CommentsModel) {
        
        let context = AppDelegate.appDelegate().managedObjectContext
        if let objComment = NSEntityDescription.insertNewObject(forEntityName: Constant.TblEntities.kTblComments, into: context) as? TblComments {
            
            objComment.postId = Int32(objCommentIs.postId)
            objComment.id = Int32(objCommentIs.id)
            objComment.name = objCommentIs.name
            objComment.email = objCommentIs.email
            objComment.body = objCommentIs.body
            
            do {
                try context.save()
            } catch let error as NSError {
                print("\(#function)", error.localizedDescription)
            }
        }
    }
    
    class func getAllPostsOffline(withResponse: (_ arr: [PostsModel])->()) {
        
        var arrData = [PostsModel]()
        
        let context = AppDelegate.appDelegate().managedObjectContext
        let fetchRequest: NSFetchRequest<TblPosts> = TblPosts.fetchRequest()
        
        do {
            let fetchResults = try context.fetch(fetchRequest)
            for obj in fetchResults {
                
                let objPost = PostsModel([:])
                
                objPost.userId = Int(obj.userId)
                objPost.id = Int(obj.id)
                objPost.title = obj.title ?? ""
                objPost.body = obj.body ?? ""
                
                arrData.append(objPost)
            }
            withResponse(arrData)
        } catch let error as NSError {
            print(error)
            withResponse(arrData)
        }
    }
    
    class func getUserDetailById(idIs: Int, withResponse: (_ objUser: UsersModel?)->()) {
        
        let context = AppDelegate.appDelegate().managedObjectContext
        let fetchRequest: NSFetchRequest<TblUsers> = TblUsers.fetchRequest()
        
        let predicate = NSPredicate(format: "id == %@", idIs as NSNumber)
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        
        do {
            let fetchResults = try context.fetch(fetchRequest)
            if let obj = fetchResults.first{
                
                let objUser = UsersModel([:])
                
                objUser.id = Int(obj.id)
                objUser.name = obj.name ?? ""
                objUser.username = obj.username ?? ""
                objUser.city = obj.city ?? ""
                objUser.email = obj.email ?? ""
                
                withResponse(objUser)
            }
        } catch let error as NSError {
            print(error)
            withResponse(nil)
        }
    }
    
    class func getPostCommentsById(postId:Int, withResponse: (_ arr: [CommentsModel])->()) {
        
        var arrData = [CommentsModel]()
        
        let context = AppDelegate.appDelegate().managedObjectContext
        let fetchRequest: NSFetchRequest<TblComments> = TblComments.fetchRequest()
        let predicate = NSPredicate(format: "postId == %@", postId as NSNumber)
        fetchRequest.predicate = predicate
        
        do {
            let fetchResults = try context.fetch(fetchRequest)
            for obj in fetchResults {
                
                let objComment = CommentsModel([:])
                
                objComment.postId = Int(obj.postId)
                objComment.id = Int(obj.id)
                objComment.body = obj.body ?? ""
                objComment.email = obj.email ?? ""
                objComment.name = obj.name ?? ""
               
                arrData.append(objComment)
            }
            
            withResponse(arrData)
        } catch let error as NSError {
            print(error)
            withResponse(arrData)
        }
    }
    
    ///Truncate tbl by passing table name
    class func truncateTable(_ tblName: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: tblName)
        
        let request = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedContext.execute(request)
            try managedContext.save()
        } catch let error as NSError {
            print("LOG: Truncate \(tblName) \(error.userInfo)")
        }
    }
}
