//
//  ThatCoworkerViewController.swift
//  Office Forest App
//
//  Created by student on 7/12/16.
//  Copyright © 2016 SUTD-ZJU Collaboration. All rights reserved.
//

import UIKit

class ThatCoworkerViewController: UIViewController {//, UIPageViewControllerDataSource {
    
    var selectedID = "1"
    var voted = false
    var data : [String: String]?//["name": "Coworker Name","email": "coworker@email.com", "number": "000000", "Level": "0", "Type": "Orichalcon", "Descript": "wowowowowowow", "profURL" : "la/so", "plantURL": "fa/mi"]
    var profileImage: UIImage?
    var plantImage: UIImage?
    

    
    @IBOutlet var myNameView: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        self.pageView.data = self.data
//        updateSelf()
        
    }
    
    override func viewDidLoad() {
        updateSelf()
        loadPlantPicture(data!["plantURL"]!)
    }
    
    @IBAction func tapBack(sender: AnyObject) {
        performSegueWithIdentifier("unwindToCoworkers", sender: self)
    }

    func updateSelf() {
        self.myNameView.text = data!["name"]
//        self.pageView.refreshPage()

        
    }
    
    @IBAction func tapVote(sender: AnyObject) {
        if !voted {
            sendVote(1)
            let messageAlert = UIAlertController(title: "Voted!", message:"You have given your vote to this plant.", preferredStyle: UIAlertControllerStyle.Alert)
            messageAlert.addAction(UIAlertAction(title: "Comment", style: UIAlertActionStyle.Default, handler:{ (action: UIAlertAction!) in
                self.performSegueWithIdentifier("commentSegue", sender: self)}))
            messageAlert.addAction(UIAlertAction(title: "Close", style: .Default, handler: nil))
            self.presentViewController(messageAlert, animated: true, completion: nil )
            voted = true
            
        } else {
            //            sendVote(0)
            //            let messageAlert = UIAlertController(title: "Vote Taken!", message:"You have taken your vote from this plant.", preferredStyle: UIAlertControllerStyle.Alert)
            //            messageAlert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler:nil))
            //            self.presentViewController(messageAlert, animated: true, completion: nil)
            //            voted = false
            //            updateSelf()
        }
    }
    
    //PHP Functions

    @IBAction func tapComment(sender: AnyObject) {
        performSegueWithIdentifier("commentSegue", sender: self)
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
                 print("parsing error=\(error)")
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
                    self.plantImage = UIImage(data: data!)
                    print("plant image updated")
                }
                if self.plantImage != nil {
                    if self.plantImage != UIImage(data: data!) {
                        dispatch_async(dispatch_get_main_queue(), display_image)
                    }
                }
            }
            
        }
        
        task.resume()
    }


    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embededSegue" {
            print("passing to embedded")
            let child = segue.destinationViewController as! ThatCoworkerPageController
            child.data = self.data
            child.selectedID = self.selectedID
            child.plantImage = self.plantImage
            print("childdata:\(child.data)")
        } else if segue.identifier == "commentSegue" {
            print("going to comment")
            let destination = segue.destinationViewController as! CommentSectionViewController
            destination.selectedID = self.selectedID
            destination.plantImage = self.plantImage
        }
    }

    
}

//-----------------------------------------------------------------










//------------------------------------------------------------------

class ThatCoworkerPageController: UIPageViewController , UIPageViewControllerDataSource {
    
    private(set) lazy var orderedViewControllers: [UIViewController] = { return [self.newViewController("Profile"), self.newViewController("Plant")]}()
    var selectedID = "1"
    var profileImage: UIImage?
    var plantImage: UIImage?
    var data: [String: String]?
//    var data = ["name": "Coworker Name","email": "coworker@email.com", "number": "000000", "Level": "0", "Type": "Orichalcon", "Descript": "wowowowowowow", "profURL" : "la/so", "plantURL": "fa/mi"]
//    var parentPage = UIStoryboard(name: "Main",bundle: nil).instantiateViewControllerWithIdentifier("ThatCoworker") as! ThatCoworkerViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.data = parentPage.data
        refreshPage()
        dataSource = self
    }
    
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : AnyObject]?) {
        super.init(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: options)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    }
    
    func refreshPage()  {
        print("refreshing page")
        orderedViewControllers = [self.newViewController("Profile"), self.newViewController("Plant")]
        if let FirstViewController = orderedViewControllers.first {
            setViewControllers([FirstViewController], direction: .Forward, animated: true, completion: nil)
        }
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("mypagedata: \(self.data)")
        
    }
    
    private func newViewController(id: String) -> UIViewController {
        if id == "Profile" {
            let thisPage = UIStoryboard(name: "Main", bundle: nil) .instantiateViewControllerWithIdentifier("That\(id)") as! ThatProfileController
            thisPage.myURL = data!["profURL"]
            thisPage.myVote = data!["Vote"]
            thisPage.myDept = data!["Dept"]
            thisPage.selectedID = self.selectedID
            return thisPage
        } else {// if id == "Plant" {
            let thisPage = UIStoryboard(name: "Main", bundle: nil) .instantiateViewControllerWithIdentifier("That\(id)") as! ThatPlantController
            thisPage.myName = data!["Type"]
            thisPage.myDescript = data!["Descript"]
            thisPage.myPlantURL = data!["plantURL"]
            thisPage.myImage = self.plantImage
            
            return thisPage
        }

    }
    
    //MARK: Datasource module
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        print("previous page")
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {return nil}
        let previousIndex = viewControllerIndex - 1
        if previousIndex < 0 {
            print("no page before")
            return nil
        } else if orderedViewControllers.count < previousIndex {
            return nil
        } else {
//            return orderedViewControllers[previousIndex]
            return self.newViewController("Profile")
        }
        
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        print("next page")
        guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {return nil}
        let nexIndex = viewControllerIndex + 1
        if nexIndex >= orderedViewControllers.count {
            print("no page after")
            return nil
        }  else {
//            return orderedViewControllers[nexIndex]
            return self.newViewController("Plant")
        }
        
        
    }

    
    
}

//=========================================================






//=========================================================

class ThatPlantController: UIViewController {
    //passed from parent view controllers
    var myImage: UIImage?
    var myName: String?
    var myDescript: String?
    var myLight: Float?
    var myWater: Float?
    var myPlantURL: String?
    
//    var parentPage = UIStoryboard(name: "Main",bundle: nil).instantiateViewControllerWithIdentifier("ThatCoworker") as! ThatCoworkerViewController
    
    
    @IBOutlet var plantImageView: UIImageView!
    
    @IBOutlet var plantNameLabel: UILabel!
    
    @IBOutlet var plantTextView: UITextView!
    
    @IBOutlet var plantLightView: UIImageView!
    
    @IBOutlet var plantWaterView: UIImageView!
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("plantviewdidappear")
        updateSelf()
//        self.plantImageView.image = self.myImage
        if myPlantURL != "fa/mi" {
            loadPlantPicture("\(conIP)\(myPlantURL!)")
        } else {
            self.plantImageView.image = UIImage(named: "defplant")
        }
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
                    self.plantImageView.image = UIImage(data: data!)
                    print("plant image updated")
                }
                if self.plantImageView != nil {
                if self.plantImageView.image != UIImage(data: data!) {
                    dispatch_async(dispatch_get_main_queue(), display_image)
                }
                }
            }
            
        }
        
        task.resume()
    }

    
    func updateSelf() {
        plantNameLabel.text = myName
        plantTextView.text = myDescript

        if myLight != nil{
            if myLight < 25 {
                plantLightView.image = UIImage(named: "Sun Red")
            } else {
                plantLightView.image = UIImage(named: "Sun Green")
            }
        }
        
        if myWater != nil {
            if myWater < 25 {
                plantWaterView.image = UIImage(named: "Water Red")
            } else {
                plantWaterView.image = UIImage(named: "Water")
            }
        }
        
    }
}

class ThatProfileController: UIViewController {
    //passed from parent view controllers
    var myImage: UIImage?
    var myVote: String?
    var myDept: String?
    var myLevel: Int?
    var myURL: String?
    var myFeatureCount: Int?
    var selectedID = "1"
    
//    var parentPage = UIStoryboard(name: "Main",bundle: nil).instantiateViewControllerWithIdentifier("ThatCoworker") as! ThatCoworkerViewController
    
    @IBOutlet var myImageView: UIImageView!
    
    @IBOutlet var myDeptLabel: UILabel!
    
    @IBOutlet var voteLabel: UILabel!
    
    @IBOutlet var upgradeLabel: UILabel!
    
    func loadFeatureList() {
        let url: NSURL = NSURL(string: "\(conIP)CheckFeature.php")!
        var session: NSURLSession
        session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
//        let userID = getSavedLogin()![2]
        let paramString = "userID=\(self.selectedID)"
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
                if let featureCount = jsson!["featurecount"] as? Int {
                    self.myFeatureCount = featureCount
                } else {
                    self.myFeatureCount = 0
                }
                func setUpgrade() {
                    self.upgradeLabel.text = "\(self.myFeatureCount!)"
                }
                dispatch_async(dispatch_get_main_queue(), setUpgrade)
                
            } catch let error {
                print("parsing error=\(error)")
            }
        }
        task.resume()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myImageView.layer.cornerRadius = myImageView.frame.width / 2
        myImageView.clipsToBounds = true
        myImageView.layer.borderColor = UIColor.whiteColor().CGColor
        myImageView.layer.borderWidth = 3
        loadFeatureList()
        if myURL != "la/so" {
            loadProfilePicture("\(conIP)\(myURL!)")
        } else {
            self.myImageView.image = UIImage(named: "swift icon")
        }
        updateSelf()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("profileviewdidappear")
//        print(data)
//        myURL = data!["profURL"]
//        if myURL != "la/so" {
//            loadProfilePicture("\(conIP)\(myURL!)")
//        } else {
//            self.myImageView.image = UIImage(named: "swift icon")
//        }
//        updateSelf()
    }
    
    func updateSelf() {
//        myImageView.image = myImage
        voteLabel.text = myVote!
        myDeptLabel.text = myDept!
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
                    self.myImageView.image = UIImage(data: data!)
                    print("profile image updated")
                }
                if self.myImageView.image != UIImage(data: data!) {
                    dispatch_async(dispatch_get_main_queue(), display_image)
                }
                
            }
            
        }
        
        task.resume()
    }
    
    @IBAction func unwindToThatCoworker(segue: UIStoryboardSegue) {
        
    }

    
}