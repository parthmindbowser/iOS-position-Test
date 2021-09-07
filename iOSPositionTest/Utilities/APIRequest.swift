//
//  APIRequest.swift
//  iOSPositionTest
//
//  Created by Parth Dumaswala on 06/09/21.
//

import Foundation
import RxCocoa
import RxSwift

protocol APIRequestProtocol {
    func callAPIForPosts<T: Codable>() -> Observable<T>
    func callAPIForUsers<T: Codable>() -> Observable<T>
    func callAPIForComments<T: Codable>() -> Observable<T>
}

class APIRequest: APIRequestProtocol {
    
    let postsURL = URL(string: Constant.serverAPI.URL.kPosts)!
    let usersURL = URL(string: Constant.serverAPI.URL.kUsers)!
    let commentsURL = URL(string: Constant.serverAPI.URL.kComments)!
    
    let session = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask? = nil
    
    //MARK:- Get Posts From Endpoint
    func callAPIForPosts<T: Codable>() -> Observable<T> {
        
        //create an observable and emit the state as per response.
        return Observable<T>.create { observer in
            self.dataTask = self.session.dataTask(with: self.postsURL, completionHandler: { (data, response, error) in
                do {
                    let postsModel: [PostsModel] = try JSONDecoder().decode([PostsModel].self, from: data ?? Data())
                    observer.onNext(postsModel as! T)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            })
            self.dataTask?.resume()
            return Disposables.create {
                self.dataTask?.cancel()
            }
        }
    }
    
    //MARK:- Get Users From Endpoint
    func callAPIForUsers<T: Codable>() -> Observable<T> {
        
        //create an observable and emit the state as per response.
        return Observable<T>.create { observer in
            self.dataTask = self.session.dataTask(with: self.usersURL, completionHandler: { (data, response, error) in
                do {
                    let usersModel: [UsersModel] = try JSONDecoder().decode([UsersModel].self, from: data ?? Data())
                    observer.onNext(usersModel as! T)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            })
            self.dataTask?.resume()
            return Disposables.create {
                self.dataTask?.cancel()
            }
        }
    }
    
    //MARK:- Get Comments From Endpoint
    func callAPIForComments<T: Codable>() -> Observable<T> {
        
        //create an observable and emit the state as per response.
        return Observable<T>.create { observer in
            self.dataTask = self.session.dataTask(with: self.commentsURL, completionHandler: { (data, response, error) in
                do {
                    let usersModel: [CommentsModel] = try JSONDecoder().decode([CommentsModel].self, from: data ?? Data())
                    observer.onNext(usersModel as! T)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            })
            self.dataTask?.resume()
            return Disposables.create {
                self.dataTask?.cancel()
            }
        }
    }
}
