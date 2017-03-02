//
//  databaseModel.swift
//  Occife Swamp
//
//  Created by student on 6/14/16.
//  Copyright © 2016 Zhejiang High. All rights reserved.
//

import Foundation
import UIKit

// trying to have a function for all php interaction

func sendPHPRequest(address: String, param: NSData) -> NSDictionary? { //function returns data - still in json format
    let url: NSURL = NSURL(string: address)!
    var session: NSURLSession
    var JSON: NSDictionary?
    var returnJSON: NSDictionary?
    session = NSURLSession.sharedSession()
    let request = NSMutableURLRequest(URL: url)
    request.HTTPMethod = "POST"
    request.HTTPBody = param
    let task = session.dataTaskWithRequest(request)
    {data, response, error in
             if error != nil {
            print("error=\(error)")
            return
        }

        let httpStatus = response as? NSHTTPURLResponse
        print("status code = \(httpStatus?.statusCode)") //should be 200
        do { JSON = try (NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary)
            print("rdict: \(JSON)")
            returnJSON = JSON
        } catch let error {
            print("parsing error=\(error)")
        }
        

    }
    print("mdict: \(returnJSON)")
    task.resume()
    return JSON
}

//handling connection error
func handleConErr(selfview: UIViewController) {
    let noUserAlert = UIAlertController(title: "Connection Error", message:"Please check if you are connected to your office network.", preferredStyle: UIAlertControllerStyle.Alert)
    noUserAlert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.removeObjectForKey("myUsername")
            defaults.removeObjectForKey("myPassword")
            defaults.synchronize()
            toLoginScreen(selfview)
        }
        
        ))
    selfview.presentViewController(noUserAlert, animated: true, completion: nil)

}


/// Set up location model class
//

class feedModel: NSObject {
    
    var imgURL: String?
    var name: String?
    var descript: String?
    
    override init() {
        
    }
    
    init(name: String, descript: String, imgURL: String) {
        self.name = name
        self.imgURL = imgURL
        self.descript = descript
    }
    
    //print object's current state - not sure for what
    
    override var description: String {
        return "name: \(name), URL: \(imgURL), desc: \(descript)"
    }
}

class userInfoModel: NSObject {
    
    //var userID: Int
    var username: String?
    var Name: String?
    var ContactNo: String?
    var email: String?
    var profpic: String?
    var plantpic: String?
    var status: String?
    
    override init() {
        
    }
    
    init(username: String) {
        self.username = username
        self.Name = nil
        self.ContactNo = nil
        self.email = nil
        self.profpic = nil
        self.plantpic = nil
    }
    
    //print object's current state - not sure for what
    
    override var description: String {
        return "username: \(username)"
    }
}

/// set up home model and its protocol
//..

protocol UserModelProtocol: class {
    func itemsDownloaded(items: NSArray)
}

class UserModel: NSObject, NSURLSessionDataDelegate {
    weak var delegate: UserModelProtocol!
    
    var data: NSMutableData = NSMutableData()
    var jsson: NSDictionary?
    
    let urlPath: String = "\(conIP)Login.php" ///change to server php location
    
    func downloadItems(username: String, password: String) {
        let url: NSURL = NSURL(string: urlPath)!
        var session: NSURLSession
        session = NSURLSession.sharedSession()
        if NSURL(string: urlPath) == nil {print("OMG nil url!!")}
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let paramString = "username=\(username)&password=\(password)"
        print(paramString)
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = session.dataTaskWithRequest(request)
        {data, response, error in
            if error != nil {
                print("error=\(error)")
                let mason = ["status":"connection error"]
                self.jsson = mason
                return
            }
            
            //let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            //print("responsestring=\(responseString!)")
            
            let httpStatus = response as? NSHTTPURLResponse
            print("status code = \(httpStatus?.statusCode)") //should be 200
            
            //print(data)
            
            //var err:NSError?
            //var jsson: NSDictionary?
            do { try self.jsson = (NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary)
            } catch let error {
                print("login parsing error=\(error)")
                let mason = ["status":"connection error"]
                self.jsson = mason
            }
 
            //print(self.jsson)
            
            //self.parseJSON()

            
        }
        task.resume()
    }

    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if error != nil {
            print("Download error")
        }else {
            print("Download success!")
            self.parseJSON()
        }
    }
    
    func parseJSON() {
        var jsonResult: NSMutableArray = NSMutableArray()
        
        do{
            jsonResult = try NSJSONSerialization.JSONObjectWithData(self.data, options: NSJSONReadingOptions.AllowFragments) as! NSMutableArray
        } catch let error as NSError {
            print(error)
        }
        
        var jsonElement: NSDictionary = NSDictionary()
        let userCol: NSMutableArray = NSMutableArray() //Make sure to not make this an array anymore, we only have one user per session!!
        
        for i in 0 ..< jsonResult.count {
            jsonElement = jsonResult[i] as! NSDictionary
            let User = userInfoModel()
            
            //insures none of the jsonelement are nil
            if let username = jsonElement["Username"] as? String
            {
            User.username = username
            User.status = jsonElement["status"] as? String
            User.email = jsonElement["Email"] as? String
            print(User.email)
            }
            userCol.addObject(User)
        }
        dispatch_async(dispatch_get_main_queue(), { () -> Void in self.delegate.itemsDownloaded(userCol)})
        
    }
    
}

// set up image model and protocol

protocol imageDownloadProtocol: class {
    func itemsDownloaded(item: NSArray)
}

class imageDownloadModel: NSObject, NSURLSessionDataDelegate {
    weak var delegate: imageDownloadProtocol!
    var data: NSMutableData = NSMutableData()
    var jsson: NSDictionary?
    //let urlPath: String = "http://192.168.168.7/ProfileImageDisplay.php" ///change to server php location
    
    func downloadItems(urlPath: String, param: NSData) {
        let url: NSURL = NSURL(string: urlPath)!
        var session: NSURLSession
        session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
//        let paramString = "username=\(username)&password=\(password)"
//        print(paramString)
        request.HTTPBody = param
        let task = session.dataTaskWithRequest(request)
        {data, response, error in
            if error != nil {
                print("error=\(error)")
                return
            }
            let httpStatus = response as? NSHTTPURLResponse
            print("status code = \(httpStatus?.statusCode)") //should be 200

            do { try self.jsson = (NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary)
            } catch let error {
                print("login parsing error=\(error)")
            }
            
        }
        task.resume()
    }

}