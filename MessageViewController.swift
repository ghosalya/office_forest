//
//  MessageViewController.swift
//  Office Forest App
//
//  Created by student on 7/6/16.
//  Copyright © 2016 SUTD-ZJU Collaboration. All rights reserved.
//

import UIKit

class messageCell: UITableViewCell {
    var name = "Missing Message"
    var message = "Not found"
    var imgURL = "404"
    weak var hisImage: UIImage?
    var timestamp = "-1"
    
    @IBOutlet var titleLabel: UILabel!
//    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var msgImg: UIImageView!
    
    func updateSelf() {
        self.msgImg.layer.cornerRadius = self.msgImg.frame.width/2
        self.msgImg.clipsToBounds = true
        self.titleLabel.text = "\(self.name) voted and commented: \(self.message)"
//        self.messageLabel.text = self.message
        self.timestampLabel.text = self.timestamp
        self.loadPictures(self.imgURL)
    }
    
    func loadPictures(location: String) {
        let imgURL: NSURL = NSURL(string: "\(conIP)\(location)")!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            if (error == nil && data != nil)
            {
                func display_image()
                {
                    self.msgImg.image = UIImage(data: data!)
                }
                if self.msgImg.image != UIImage(data: data!) {
                    print("updating img for \(self.name)")
                    dispatch_async(dispatch_get_main_queue(), display_image)
                }
                
            }
            
        }
        
        task.resume()

    }
}

class MessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var updated = false
    
    var messageList = [["name":"Occifer Forest","timestamp":"06/07/2016 18:00", "message":"Hello there!", "imgURL":"la/men"],
                       
                       
                       
                       
                       ]
    
    @IBOutlet var messageTableView: UITableView!
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("selected \(indexPath.item)")
        let messageAlert = UIAlertController(title: "Comment from \(self.messageList[indexPath.item]["name"]!)", message:self.messageList[indexPath.item]["message"], preferredStyle: UIAlertControllerStyle.Alert)
        messageAlert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler:nil))
        messageAlert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler:nil))
        self.presentViewController(messageAlert, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("message") as! messageCell
        cell.name = self.messageList[indexPath.item]["name"]!
        cell.message = self.messageList[indexPath.item]["message"]!
        cell.timestamp = self.messageList[indexPath.item]["timestamp"]!
        cell.imgURL = self.messageList[indexPath.item]["imgURL"]!
        
        if indexPath.item % 2 == 0 {
            cell.backgroundColor = UIColor.clearColor()
        }
        
        cell.updateSelf()
        return cell
    }
    
    @IBAction func tapBack(sender: AnyObject) {
        performSegueWithIdentifier("unwindToProfile", sender: self)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.messageTableView.dataSource = self
        self.messageTableView.delegate = self
        self.reloadCommentData()
        while updated == false {
            _ = 9
        }
        self.messageTableView.reloadData()
    }
    
    func reloadCommentData() {
        let url: NSURL = NSURL(string: "\(conIP)ViewComment.php")!
        var session: NSURLSession
        var JSON: NSArray?
        session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let userID = getSavedLogin()![2]
        let paramString = "userID=\(userID)"
        print(paramString)
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = session.dataTaskWithRequest(request)
        {data, response, error in
            if error != nil {
                print("error=\(error)")
                return
            }
            
            let httpStatus = response as? NSHTTPURLResponse
            print("status code = \(httpStatus?.statusCode)") //should be 200
            do { JSON = try (NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSArray)
                print("rdict: \(JSON!)")
                self.messageList = []
                for comments in JSON! {
                    let thisComment = ["name":comments["commentor"] as! String, "timestamp":comments["timestamp"] as! String, "message":comments["comment"] as! String, "imgURL":comments["commentorpic"] as! String]
                    
                    self.messageList.append(thisComment)
                    
                    
                }
                
                self.updated = true

                //                self.updateSelf()
//                self.messageTableView.reloadData()
                
            } catch let error {
                print("parsing error=\(error)")
            }
            
            
        }
        task.resume()

    }
}
