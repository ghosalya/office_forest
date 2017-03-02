//
//  CoworkerViewController.swift
//  Office Forest App
//
//  Created by student on 7/5/16.
//  Copyright © 2016 SUTD-ZJU Collaboration. All rights reserved.
//

import UIKit

class coworkerView: UICollectionViewCell {
    var name: String?
    var ID: String?
    var imgURL: String?
    @IBOutlet weak var image: UIImageView!

    
    func updateSelf() {
        print("updating self")
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 1
        if (imgURL != "" && imgURL != nil) {
        self.load_image("\(conIP)\(imgURL!)")
        } else {
            self.image.image = UIImage(named: "defplant")
        }
    }
    
    
    func load_image(urlString:String)
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
                    self.image.image = UIImage(data: data!)
                }
                if self.image.image != UIImage(data: data!) {
                    print("updating img for \(self.name)")
                    dispatch_async(dispatch_get_main_queue(), display_image)
                }
                
            }
            
        }
        
        task.resume()
    }
}





class CoworkerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var feedList: [[String:AnyObject]] = [["name":"New Worker","URL":"ge/ma","ID":"-1"],
    
    ]
    
    var data = ["name": "Coworker Name","email": "coworker@email.com", "number": "000000","Dept":"Ferret Hunter", "Level": "0", "Type": "Orichalcon", "Descript": "wowowowowowow", "profURL" : "la/so", "plantURL": "fa/mi"]
    
    @IBOutlet var coworkerCollection: UICollectionView!
    
    var selectedID = "0"
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        if toLoginScreen(self) == false {
//            self.requestFeedList()
//            print(self.feedList)
//        }
    }
    
    override func viewDidLoad() {
        if toLoginScreen(self) == false {
            self.requestFeedList()
            print(self.feedList)
        }
    }
    
    @IBAction func tapChampion(sender: AnyObject) {
        performSegueWithIdentifier("leaderboardSegue", sender: self)
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //how many cells to make
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.feedList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! coworkerView
        cell.name = self.feedList[indexPath.item]["name"] as? String
        cell.ID = self.feedList[indexPath.item]["ID"] as? String
        cell.imgURL = self.feedList[indexPath.item]["URL"] as? String
        cell.updateSelf()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) { //handle taps
        print("selected \(feedList[indexPath.item]["name"]!)!")
        self.selectedID = feedList[indexPath.item]["ID"]! as! String
        requestCoworkerInfo()
    }
    
    //PHP Call
    
    func requestFeedList() {
        let url: NSURL = NSURL(string: "\(conIP)UserFeed.php")!
        var session: NSURLSession
        var JSON: NSArray?
        session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let seleID = getSavedLogin()![2]
        let paramString = "selectID=\(seleID)"
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
                self.feedList = []
                for worker in JSON! {
                    print("worker: \(worker)")
                    if worker["name"] as! String != getSavedUserDict()!["name"] as! String {
//                        
                    let theirDetails = ["name":worker["name"] as! String,"URL":worker["profile"] as! String, "ID":worker["userId"] as! String]
                    self.feedList.append(theirDetails)
                    }
                }
                dispatch_async(dispatch_get_main_queue(), self.coworkerCollection.reloadData)
            } catch let error {
                print("parsing error=\(error)")
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
                self.data["Dept"] = JSON!["dept"] as! String
                
                self.data["profURL"] = (JSON!["profileimage"] as! String)
                self.data["plantURL"] = (JSON!["plantimage"] as! String)
                self.data["Descript"] = (JSON!["plantcomment"] as! String)
                
                self.data["Type"] = (JSON!["type"] as! String)
                let votess = JSON!["votes"] as! Int
                self.data["Vote"] = "\(votess)"
                print("downloading data complete")
                
                
                dispatch_async(dispatch_get_main_queue(), {self.performSegueWithIdentifier("selectHimSegue", sender: self)})

//                self.performSegueWithIdentifier("selectHimSegue", sender: self)
                
            } catch let error {
                print("parsing error=\(error)")
            }
            
            
        }
        task.resume()
        //        dispatch_async(dispatch_get_main_queue(), self.updateSelf)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("preparing for segue")
        if segue.identifier == "selectHimSegue" {
            print("assigning")
            let nextscene = segue.destinationViewController as! ThatCoworkerViewController
            nextscene.selectedID = self.selectedID
            print("sending data: \(self.data)")
            nextscene.data = self.data
//            nextscene.pageView.data = self.data
//            nextscene.pageView.refreshPage()
        }
    }
    
    @IBAction func unwindToCoworkers(segue: UIStoryboardSegue) {
        
    }

    
}




