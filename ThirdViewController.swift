//
//  ThirdViewController.swift
//  Office Forest App
//
//  Created by student on 6/22/16.
//  Copyright © 2016 SUTD-ZJU Collaboration. All rights reserved.
//

import UIKit

//func saveProfilePic(image: UIImage) {
//    
//}

class ThirdViewController: UIViewController {
    
    
    var needRefreshPic = false
    var featureDict: NSDictionary?
    
    @IBOutlet var nameLabel: UILabel!

    @IBOutlet var voteLabel: UILabel!
    
    @IBOutlet var upgradeLabel: UILabel!
    @IBOutlet var upgradeField: UIView!
    
    @IBOutlet var levelLeft: UIImageView!
    @IBOutlet var levelRight: UIImageView!
    
    @IBAction func forceRefresh() {
        print("force refresh")
        refreshProfPic()
    }
    
    var refreshTimer = NSTimer()
    
    var vote = 0

    @IBOutlet var departmentLabel: UILabel!
    
    @IBAction func tapLogOut(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("myUsername")
        defaults.removeObjectForKey("myPassword")
        defaults.synchronize()
        toLoginScreen(self)
    }
    
    func loopCheckPic() {
        print("changing loop")
        self.refreshTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(self.refreshProfPic), userInfo: nil, repeats: true )
    }
    
    @IBAction func unwindToProfile(segue: UIStoryboardSegue) {
        
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "unwindToProfile" {
//            let page = segue.destinationViewController as! ThirdViewController
//            page.loadFeatureList()
//            page.updateSelf()
//        }
//    }
    
    @IBAction func tapMessages(sender: AnyObject) {
        performSegueWithIdentifier("messageSegue", sender: self)
    }

    @IBOutlet var profileImageView: UIImageView!
    
    func refreshProfPic() {
        self.profileImageView.image = nil
        let userURL = getSavedUserDict()!["profURL"]! as! String
        load_image("\(conIP)\(userURL)")
//        let param = "userID=\(getSavedLogin()![2])"
//        print(param)
//        let imgurl = getDownloadedImage("\(conIP)ProfileImageDisplay.php", param: param.dataUsingEncoding(NSUTF8StringEncoding)!)
//        print(imgurl)
//        if let prof = imgurl!["profile"] as? String {
//            let urlprof = "\(conIP)\(prof)"
//            load_image(urlprof)
//        }
    }
    
    func checkVoteCount() {
        
        self.vote = getSavedUserDict()!["votes"] as! Int
        self.updateSelf()
//        let url: NSURL = NSURL(string: "\(conIP)CheckVote.php")!
//        var session: NSURLSession
//        var JSON: NSDictionary?
//        session = NSURLSession.sharedSession()
//        let request = NSMutableURLRequest(URL: url)
//        request.HTTPMethod = "POST"
//        let userID = getSavedLogin()![2]
//        let paramString = "userID=\(userID)"
//        print(paramString)
//        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
//        let task = session.dataTaskWithRequest(request)
//        {data, response, error in
//            if error != nil {
//                print("error=\(error)")
//                return
//            }
//            
//            let httpStatus = response as? NSHTTPURLResponse
//            print("status code = \(httpStatus?.statusCode)") //should be 200
//            do { JSON = try (NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary)
//                print("rdict: \(JSON!)")
//                let newCount = JSON!["vote"] as! String
//                self.vote = Int(newCount)!
//                dispatch_async(dispatch_get_main_queue(), self.updateSelf)
//                
//            } catch let error {
//                print("parsing error=\(error)")
//            }
//            
//            
//        }
//        task.resume()

    }
    
    @IBAction func tapEditDetails(sender: AnyObject) {
        performSegueWithIdentifier("editDetailSegue", sender: self)
    }
    
//    @IBAction func tapRefreshImg(sender: AnyObject) {
//        self.refreshProfPic()
//
//    }
    
    @IBAction func changeProfPic(sender: AnyObject) {
        self.performSegueWithIdentifier("imageUpload", sender: self)
    }
    
    override func viewDidAppear(animation: Bool) {
        super.viewDidAppear(true)
//        if needRefreshPic {
            print("refreshing prof pic")
            refreshProfPic()
            needRefreshPic = false
//        }
//        loopCheckPic()
        if featureDict != nil {
            
            let count = featureDict!["Count"] as! Int
            let index = [1,15,25,50,80,100,999999,99999999]
            print("upgrade: \(index[count])  while  vote: \(self.vote)")
            if index[count] <= self.vote {
                animateFeatureList(true)
            } else {
                animateFeatureList(false)
            }
            
            
            
            
            
        }

        
    }
    
    func animateFeatureList(enable: Bool) {
        if enable {
            print("animating")
            self.levelLeft.alpha = 1
            self.levelRight.alpha = 1
            self.upgradeLabel.alpha = 1
            UIView.animateWithDuration(0.5, delay: 0.0, options: [.Repeat, .Autoreverse] , animations: {
                self.levelLeft.alpha = 0.3
                self.levelRight.alpha = 0.3
                self.upgradeLabel.alpha = 0.3
                self.view.layoutIfNeeded()
                }, completion: nil)
        } else {
            self.levelLeft.layer.removeAllAnimations()
            self.levelRight.layer.removeAllAnimations()
            self.upgradeLabel.layer.removeAllAnimations()
            self.levelLeft.alpha = 1
            self.levelRight.alpha = 1
            self.upgradeLabel.alpha = 1
        }
    }
    
    func loadFeatureList() {
        let url: NSURL = NSURL(string: "\(conIP)CheckFeature.php")!
        var session: NSURLSession
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
            
            var jsson: NSDictionary?
            do { try jsson = (NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary)
                print(jsson)
                var count: Int?
                count =  jsson!["featurecount"] as? Int
                
                if count == nil {
                    count = 0
                }
                
                let feature = ["Name": (jsson!["Name"] as! String), "Water": (jsson!["Water"] as! String), "Light": (jsson!["Light"] as! String) ,"Moisture": (jsson!["Moisture"] as! String), "Temperature": (jsson!["Temperature"] as! String) ,"GrowLight": (jsson!["GrowLight"] as! String),"BGLight": (jsson!["BGLight"] as! String),"PIR":(jsson!["PIR"] as! String),"Count": count! ]
                self.featureDict = feature
                dispatch_async(dispatch_get_main_queue(), self.updateSelf)
                
            } catch let error {
                print("parsing error=\(error)")
            }
        }
        task.resume()
    }
    
    @IBAction func seeUpgrades() {
        print("going upgrades")
        performSegueWithIdentifier("upgradeSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width/2
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.borderWidth = 3
        self.profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        print("checking login")
        if toLoginScreen(self) == false {
            print("getting data")
            if isLoggedIn() {
                let userDict = getLoginData(getSavedLogin()![0] as! String, password: getSavedLogin()![1] as! String)!
                if userDict["status"] as? String == "connection error" {
                    print("connection error")
                    handleConErr(self)
                    
                } else {
                    print("connection ok!")
                    refreshProfPic()
                    checkVoteCount()
                    loadFeatureList()
                    //                updateSelf()
                }
                
            } else {
                print("pass login")
            }
            
        }
    }
    
    func updateSelf() {
        let userDict = getSavedUserDict()
        print(userDict)
        self.nameLabel.text = getSavedUserDict()!["name"] as! String
        self.departmentLabel.text = userDict!["department"] as! String
        self.voteLabel.text = "\(self.vote)"
        if featureDict != nil {
                self.upgradeLabel.text = "\(featureDict!["Count"] as! Int)"
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
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
                    self.profileImageView.image = UIImage(data: data!)
                }
                
                dispatch_async(dispatch_get_main_queue(), display_image)
            }
            
        }
        
        task.resume()
    }
    
    
    
}

func getDownloadedImage(url: String, param: NSData) -> NSDictionary?{
    let imgDown = imageDownloadModel()
    imgDown.downloadItems(url, param: param)
    while imgDown.jsson == nil {
        _ = 70
    }
    return imgDown.jsson
}


