//
//  ThisCoworkerViewController.swift
//  Office Forest App
//
//  Created by student on 7/5/16.
//  Copyright © 2016 SUTD-ZJU Collaboration. All rights reserved.
//

import UIKit

let conIP = "http://192.168.168.7/"

class ThisCoworkerViewController: UIViewController {
    
    var selectedID = "1"
    var voted = false
    var data = ["name": "Coworker Name","email": "coworker@email.com", "number": "000000", "Level": "0", "Type": "Orichalcon", "Descript": "wowowowowowow", "profURL" : "la/so", "plantURL": "fa/mi"]
    
    @IBOutlet var profileImgView: UIImageView!
    @IBOutlet var profileNameLabel: UILabel!
    @IBOutlet var profileEmailLabel: UILabel!
    @IBOutlet var profileNumberLabel: UILabel!
    
    @IBOutlet var plantImgView: UIImageView!
    @IBOutlet var plantLevelLabel: UILabel!
    @IBOutlet var plantNameLabel: UILabel!
    @IBOutlet var plantDescriptTextView: UITextView!
    
    
    @IBOutlet var commentTextField: UITextView!
    
    @IBOutlet var commentButton: UIButton!
    
    @IBOutlet var voteButton: UIButton!
    
    @IBAction func tapBackButton(sender: AnyObject) {
        performSegueWithIdentifier("unwindToCoworkers", sender: self)
    }
    
    func updateSelf() {
        profileNameLabel.text = data["name"]
        profileEmailLabel.text = data["email"]
        profileNumberLabel.text = data["number"]
        plantLevelLabel.text = "Level \(data["Level"]!)"
        plantNameLabel.text = data["Type"]
        plantDescriptTextView.text = data["Descript"]
        if voted {
            self.voteButton.backgroundColor = UIColor.grayColor()
            self.voteButton.setTitle("Voted", forState: self.voteButton.state)
//            self.voteButton.titleLabel?.text = "Unvote"

        } else {
            self.voteButton.backgroundColor = UIColor.greenColor()
            self.voteButton.setTitle("Vote", forState: self.voteButton.state)
//            self.voteButton.titleLabel?.text = "Vote"
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("selected \(selectedID)")
        requestCoworkerInfo()
        checkVote()
        while data["Type"] == "Orichalcon" {
            _ = 0
        }
        updateSelf()
    }
    
    func loadProfilePicture(urlString:String)
    {
        let imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            if (error == nil && data != nil)
            {
                func display_image()
                {
                    self.profileImgView.image = UIImage(data: data!)
                }
                if self.profileImgView.image != UIImage(data: data!) {
                    dispatch_async(dispatch_get_main_queue(), display_image)
                }
                
            }
            
        }
        
        task.resume()
    }
    
    func loadPlantPicture(urlString:String)
    {
        let imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            if (error == nil && data != nil)
            {
                func display_image()
                {
                    self.plantImgView.image = UIImage(data: data!)
                }
                if self.plantImgView.image != UIImage(data: data!) {
                    dispatch_async(dispatch_get_main_queue(), display_image)
                }
                
            }
            
        }
        
        task.resume()
    }
    
    func requestCoworkerInfo() {
        let url: NSURL = NSURL(string: "\(conIP)ViewProfile.php")!
        var session: NSURLSession
        var JSON: NSDictionary?
        session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let paramString = "selectID=\(self.selectedID)"
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
            do { JSON = try (NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary)
                print("rdict: \(JSON!)")
                self.data["name"] = (JSON!["name"] as! String)
                self.data["number"] = (JSON!["contact"] as! String)
                self.data["email"] = (JSON!["email"] as! String)
                
                self.data["profURL"] = (JSON!["profileimage"] as! String)
                self.data["plantURL"] = (JSON!["plantimage"] as! String)
                self.data["Descript"] = (JSON!["plantcomment"] as! String)
                
                self.data["Type"] = (JSON!["type"] as! String)
                self.loadPlantPicture("\(conIP)\(self.data["plantURL"]!)")
                self.loadProfilePicture("\(conIP)\(self.data["profURL"]!)")
//                self.updateSelf()

            } catch let error {
                print("parsing error=\(error)")
            }
            
            
        }
        task.resume()
    }
    
    
    @IBAction func tapComment(sender: AnyObject) {
        if self.commentTextField.text == "" {
            print("no comment")
        } else if self.commentButton.backgroundColor != UIColor.grayColor() {
            let date = NSDate().toFullString()
            print(date)
            sendComment(self.commentTextField.text, timestamp: date)
            
            self.commentTextField.text = ""
//            self.commentButton.backgroundColor = UIColor.grayColor()
        }
    }
    
    @IBAction func tapVote(sender: AnyObject) {
        if !voted {
            sendVote(1)
            let messageAlert = UIAlertController(title: "Voted!", message:"You have given your vote to this plant.", preferredStyle: UIAlertControllerStyle.Alert)
            messageAlert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler:nil))
            self.presentViewController(messageAlert, animated: true, completion: nil)
            voted = true
            updateSelf()

        } else {
//            sendVote(0)
//            let messageAlert = UIAlertController(title: "Vote Taken!", message:"You have taken your vote from this plant.", preferredStyle: UIAlertControllerStyle.Alert)
//            messageAlert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler:nil))
//            self.presentViewController(messageAlert, animated: true, completion: nil)
//            voted = false
//            updateSelf()
        }
        
    }
    
    func sendComment(writeup: String, timestamp: String) {
        let url: NSURL = NSURL(string: "\(conIP)LeaveComment.php")!
        var session: NSURLSession
        session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let userID = getSavedLogin()![2]
        let paramString = "userID=\(userID)&selectedID=\(self.selectedID)&timestamp=\(timestamp)&comment=\(writeup)"
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
            
//            var jsson: NSDictionary?
//            do { try jsson = (NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary)
//                print(jsson)
//            } catch let error {
//                print("parsing error=\(error)")
//            }
            
            
            
        }
        task.resume()
    }
    
    func sendVote(newvote: Int) {
        let url: NSURL = NSURL(string: "\(conIP)Vote.php")! //Change Address pls
        var session: NSURLSession
        session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let userID = getSavedLogin()![2]
        let paramString = "userID=\(userID)&selectedID=\(self.selectedID)&vote=\(newvote)"
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
            
            var jsson: NSDictionary?
            do { try jsson = (NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary)
                print(jsson)
            } catch let error {
               // print("parsing error=\(error)")
            }
            
            
            
        }
        task.resume()
    }
    
    func checkVote() {
        
        let url: NSURL = NSURL(string: "\(conIP)CheckVote.php")! //Change Address pls
        var session: NSURLSession
        session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let userID = getSavedLogin()![2]
        let paramString = "userID=\(userID)&selectedID=\(self.selectedID)"
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
            
            var jsson: NSDictionary?
            do { try jsson = (NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary)
                print(jsson)
                if jsson!["vote"] as! String == "1" {
                    print("unvoted")
                    self.voted = true
                }
            } catch let error {
                print("parsing error=\(error)")
            }
            
            
            
        }
        task.resume()
        
    }
    
}