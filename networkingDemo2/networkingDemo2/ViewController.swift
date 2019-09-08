//
//  ViewController.swift
//  networkingDemo2
//
//  Created by mic-student on 9/7/19.
//  Copyright © 2019 hmp. All rights reserved.
//

import UIKit
enum EndPoint {
    case getPostEndPoint
    case createPostEndPoint
    case deletePostEndPoint
    case updatePostEndPoint
    
    case commentEndPoint
    
    func url(id:String = "") -> String{
        let baseURLString = "http://127.0.0.1:3000/"
        switch self {
        case .getPostEndPoint,
             .createPostEndPoint: return baseURLString + "posts"
        case .updatePostEndPoint,
             .deletePostEndPoint: return baseURLString + "posts/\(id)"
        case .commentEndPoint : return baseURLString + "comments/\(id)"
        }
    }
    
    var method:String {
        switch self {
        case .getPostEndPoint: return "GET"
        case .createPostEndPoint: return "POST"
        case .deletePostEndPoint: return "DELETE"
        case .updatePostEndPoint: return "PUT"
        case .commentEndPoint: return "GET" //rarley used for this example
        }
    }
    
}

class ViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var textView: UITextView!
    @IBAction func getPosts(_ sender: UIButton) {
        
        let endPoint = EndPoint.getPostEndPoint.url()
        var request = URLRequest(url:URL(string:endPoint)!)
        request.httpMethod = EndPoint.getPostEndPoint.method
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request){
            (data, response, error) in
            
            
            if error == nil && data != nil {
                //codedable can be used to convert data to object (Not Dictionary!!)
                do {
                    if let postDicts = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [[String:Any]] {
                        print(postDicts)
                        
                        var str = ""
                        
                        for p in postDicts {
                            //let title = p["title"] as! String
                            //let author = p["author"] as! String
                            let title = p["title"] as? String
                            let author = p["author"] as? String
                            if let title = title , let author = author {
                                str += title + " " + author + "\n"
                            }
                            
                        }
                        OperationQueue.main.addOperation {
                            self.textView.text = str
                        }
                    }
                } catch let error { }
                
            }
        }
        task.resume()
    }
    
    @IBAction func postPosts(_ sender: UIButton) {
        let endPoint = EndPoint.getPostEndPoint.url()
        var request = URLRequest(url:URL(string:endPoint)!)
        request.httpMethod = EndPoint.getPostEndPoint.method
        
        let header = ["Content-type":"application/json", "token":"Bearer xyxyxyxy123123124"]
        
        request.allHTTPHeaderFields = header
        
        let postDict = ["title":"My Test Post " + "\(Date())" , "author": "Hein Myat Phone"]
        let postData = try! JSONSerialization.data(withJSONObject: postDict, options: .prettyPrinted)
        request.httpBody = postData
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data , error == nil {
                print(response)
            } else {
                print(error?.localizedDescription)
            }
        }
        task.resume()
    }
    
    
    @IBAction func putPosts(_ sender: UIButton) {
        let endPoint = EndPoint.updatePostEndPoint.url()
        var request = URLRequest(url:URL(string:endPoint)!)
        request.httpMethod = EndPoint.updatePostEndPoint.method
        
        let header = ["Content-type":"application/json", "token":"Bearer xyxyxyxy123123124"]
        
        request.allHTTPHeaderFields = header
        
        let postDict = ["title":"My Test PUT " + "\(Date())" , "author": "***Hein Myat Phone***"]
        let postData = try! JSONSerialization.data(withJSONObject: postDict, options: .prettyPrinted)
        request.httpBody = postData
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data , error == nil {
                print(response)
            } else {
                print(error?.localizedDescription)
            }
        }
        task.resume()
    }
    
    @IBAction func deletePosts(_ sender: UIButton) {
        let endPoint = EndPoint.deletePostEndPoint.url()
        let postID = 3
        var request = URLRequest(url:URL(string:endPoint + "/\(postID)")!)
        request.httpMethod = EndPoint.deletePostEndPoint.method
        
        let header = ["Content-type":"application/json", "token":"Bearer xyxyxyxy123123124"]
        
        request.allHTTPHeaderFields = header
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data , error == nil {
                print(response)
            } else {
                print(error?.localizedDescription)
            }
        }
        task.resume()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
}

