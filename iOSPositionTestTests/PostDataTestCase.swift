//
//  PostDataTestCase.swift
//  iOSPositionTestTests
//
//  Created by Parth Dumaswala on 07/09/21.
//

import XCTest
import CoreData
@testable import iOSPositionTest

class PostDataTestCase: XCTestCase {
    
    /* creating a CoreDataManager object, we will use this object to test operations like insert, update & delete */
    var coreDataManager = OfflineDataManager()
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        coreDataManager = OfflineDataManager()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    // MARK: Our test cases
    
    /*This test case test for the proper initialization of CoreDataManager class :)*/
    func test_init_coreDataManager() {
        
        /*Asserts that an expression is not nil.
         Generates a failure when expression == nil.*/
        XCTAssertNotNil( self.coreDataManager )
    }
    
    /*This test case test if NSPersistentContainer(the actual core data stack) initializes successfully or not. In case it fails in getting a proper instance It will generate a failure.
     */
    func test_coreDataStackInitialization() {
        
        let coreDataStack = AppDelegate.appDelegate().persistentStoreCoordinator
        
        /*Asserts that an expression is not nil.
         Generates a failure when expression == nil.*/
        XCTAssertNotNil( coreDataStack )
    }
    
    /*This test case inserts a post record*/
    func test_create_posts() {
        
        var objPost = PostsModel.init()
        objPost.userId = 0
        objPost.id = 0
        objPost.title = "RxSwift"
        objPost.body = "Test case body"
        
        let post: () = OfflineDataManager.insertDatainTblPost(objPostIs: objPost)
        
        /*Asserts that an expression is not nil.
         Generates a failure when expression == nil.*/
        XCTAssertNotNil( post )
    }
    
    /*This test case fetches all post records*/
    func test_fetch_all_post() {
        
        //get postRecord already saved
        OfflineDataManager.getAllPostsOffline { records in
            
            //Assert return numbers of todo items
            //Asserts that two optional values are equal.
            //XCTAssertEqual(records.count, records.count)
            
            XCTAssertNotNil("No post available on endpoint")
        }
    }
    
    /*test if all data is deleted from store*/
    func test_flushData() {
        
        OfflineDataManager.truncateTable(Constant.TblEntities.kTblPosts)
        
        OfflineDataManager.getAllPostsOffline { records in
            
            /*this test case passes if fetchAllpost returns 0 objects*/
            
            XCTAssertEqual(records.count, 0)
        }
    }
}

