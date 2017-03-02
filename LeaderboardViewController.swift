//
//  LeaderboardViewController.swift
//  Office Forest App
//
//  Created by student on 7/22/16.
//  Copyright © 2016 SUTD-ZJU Collaboration. All rights reserved.
//

import UIKit

class LeaderCell: UITableViewCell {
    
    var imagePath: String?
    var name: String?
    var votes: String?
    var highlightID = "0"
    
    @IBOutlet var ImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var voteLabel: UILabel!
    
    func updateSelf() {
        ImageView.layer.cornerRadius = ImageView.frame.width / 2
        ImageView.clipsToBounds = true
        ImageView.layer.borderWidth = 1
        ImageView.layer.borderColor = UIColor.whiteColor().CGColor
        self.nameLabel.text = self.name!
        self.voteLabel.text = self.votes!
        print("myurl: \(imagePath)")
        if imagePath != nil {
            self.loadPictures(imagePath!)
        } else {
            print("nil imagepath")
        }
    }
    
    func loadPictures(location: String) {
        print("loading image from: \(location)")
        let imgURL: NSURL = NSURL(string: "\(conIP)\(location)")!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            if (error == nil && data != nil)
            {
                func display_image()
                {
                    self.ImageView.image = UIImage(data: data!)
                }
                if self.ImageView.image != UIImage(data: data!) {
                    print("updating img for \(self.nameLabel.text)")
                    dispatch_async(dispatch_get_main_queue(), display_image)
                }
                
            }
            
        }
        
        task.resume()
        
    }

}

class LeaderboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var leadingList = [["name":"Boxing","votes":"798","profile":""],
                       ["name":"Boxing","votes":"798","profile":""]]
    var winnerURL: String?
    var winnerName: String?
    var winnerID: String?
    var winnerVote: String?
        var data = ["name": "Coworker Name","email": "coworker@email.com", "number": "000000","Dept":"Ferret Hunter", "Level": "0", "Type": "Orichalcon", "Descript": "wowowowowowow", "profURL" : "la/so", "plantURL": "fa/mi"]
    var updated = false
    var selected = "0"
    
    @IBOutlet var winnerImageView: UIImageView!
    @IBOutlet var winnerNameLabel: UILabel!
    @IBOutlet var winnerVoteLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    @IBAction func tapBack(sender: AnyObject) {
        performSegueWithIdentifier("unwindToXoworkers", sender: self)
    }
    
    override func viewDidAppear(animated: Bool) {
        winnerImageView.layer.cornerRadius = winnerImageView.frame.width / 2
        winnerImageView.clipsToBounds = true
        winnerImageView.layer.borderColor = UIColor.whiteColor().CGColor
        winnerImageView.layer.borderWidth = 3
        reloadLeaderboardData()
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.reloadData()
        
        super.viewDidAppear(animated)
        
        while updated == false {
            _ = 988
        }
        self.updateSelf()
    }
    
    func updateSelf() {
        
        loadWinnerPictures(self.winnerURL!)
        self.tableView.reloadData()
        self.winnerNameLabel.text = self.winnerName!
        self.winnerVoteLabel.text = self.winnerVote!
        
    }
    
    @IBAction func tapWinner() {
        selected = winnerID!
        requestCoworkerInfo(selected)
        while data["Type"] == "Orichalcon" {
            _ = 0
        }
        performSegueWithIdentifier("leaderCoworkerSegue", sender: self)
    }
    
    func requestCoworkerInfo(selectedID: String) {
        let url: NSURL = NSURL(string: "\(conIP)ViewProfile.php")!
        var session: NSURLSession
        var JSON: NSDictionary?
        session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let paramString = "selectID=\(selectedID)"
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
                self.data["Dept"] = JSON!["dept"] as! String
                
                self.data["profURL"] = (JSON!["profileimage"] as! String)
                self.data["plantURL"] = (JSON!["plantimage"] as! String)
                self.data["Descript"] = (JSON!["plantcomment"] as! String)
                
                self.data["Type"] = (JSON!["type"] as! String)
                let votess = JSON!["votes"] as! Int
                self.data["Vote"] = "\(votess)"
                print("downloading data complete")
                
                
//                dispatch_async(dispatch_get_main_queue(), {self.performSegueWithIdentifier("selectHimSegue", sender: self)})
                
                //                self.performSegueWithIdentifier("selectHimSegue", sender: self)
                
            } catch let error {
                print("parsing error=\(error)")
            }
            
            
        }
        task.resume()
        //        dispatch_async(dispatch_get_main_queue(), self.updateSelf)
    }

    
    
    func loadWinnerPictures(location: String) {
        let imgURL: NSURL = NSURL(string: "\(conIP)\(location)")!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            if (error == nil && data != nil)
            {
                func display_image()
                {
                    self.winnerImageView.image = UIImage(data: data!)
                }
                if self.winnerImageView.image != UIImage(data: data!) {
                    print("updating img for \(self.winnerNameLabel.text)")
                    dispatch_async(dispatch_get_main_queue(), display_image)
                }
                
            }
            
        }
        
        task.resume()
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leadingList.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("selected \(indexPath.item)")
        self.selected = leadingList[indexPath.item]["userID"]!
        let selectID = leadingList[indexPath.item]["userID"]! //as! String
        requestCoworkerInfo(selectID)
        while data["Type"] == "Orichalcon" {
            _ = 0
        }
        performSegueWithIdentifier("leaderCoworkerSegue", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "leaderCoworkerSegue" {
            let datcow = segue.destinationViewController as! ThatCoworkerViewController
            datcow.selectedID = "\(selected)"
            datcow.data = self.data
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("leader") as! LeaderCell
        cell.name = leadingList[indexPath.item]["name"]
        cell.votes = leadingList[indexPath.item]["votes"]!
        cell.imagePath = leadingList[indexPath.item]["profile"]!
        cell.updateSelf()

        return cell
    }
    
    func reloadLeaderboardData() {
        let url: NSURL = NSURL(string: "\(conIP)Leaderboard.php")!
        var session: NSURLSession
        var JSON: NSArray?
        session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let paramString = ""
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
                let winnerName = JSON![0]["name"]
                self.leadingList = []
                for leader in JSON! {
                    if leader["name"] as! String != winnerName as! String {
                        let thisLeader = ["name":leader["name"] as! String,"userID": leader["userID"] as! String, "votes":leader["votes"]! as! String, "profile":leader["profile"] as! String]
                    
                        self.leadingList.append(thisLeader)
                    } else {
                        self.winnerName = winnerName as? String
                        self.winnerVote = leader["votes"] as? String
                        self.winnerURL = leader["profile"] as? String
                        self.winnerID = leader["userID"] as? String
                    }
                    
                }
                
                print ("leading: \(self.leadingList)")
//                self.updateSelf()
//                self.tableView.reloadData()
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
