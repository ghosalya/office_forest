//
//  LoginViewController.swift
//  Occife Swamp
//
//  Created by student on 6/15/16.
//  Copyright © 2016 Zhejiang High. All rights reserved.
//

import Foundation
import UIKit

//-------- Login Check modules -------------

//1. saving login credts
func saveLogin(user: String, pass: String, userID: String) {
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.setValue(userID, forKey: "myUserID")
    defaults.setValue(user, forKey: "myUsername")
    defaults.setValue(pass, forKey: "myPassword")
    
    defaults.synchronize()
}

// 2. get saved login credts
func getSavedLogin() -> NSArray? {
    let defaults = NSUserDefaults.standardUserDefaults()
    
    if let myUser = defaults.stringForKey("myUsername"),
        let myPass = defaults.stringForKey("myPassword"),
        let myID = defaults.stringForKey("myUserID") {
        return [myUser, myPass, myID]
    } else {
        return nil
    }
    
}

//3. check IF logged in 

func isLoggedIn() -> Bool {
    if (getSavedLogin() == nil) {
        print("no saved login")
        return false
    }
    else if (true) { // place to check
        return true
    }
    
}
    
//4. bring to login screen
    
func toLoginScreen(view: UIViewController) -> Bool{
    if isLoggedIn() {
        print("Logged in as \(getSavedLogin()![0])")
        return false
    } else {
        print("Going to login page")
        view.performSegueWithIdentifier("loginSegue", sender: view)
        return true
    }
    
}

//5. check loggin credts with database

func getLoginData(username: String, password: String) -> NSDictionary? {
    //let queue = dispatch_get_glo
    let userMod = UserModel()
    userMod.downloadItems(username, password: password)
    while userMod.jsson == nil {
        _ = 70 //doing nothing and waiting
    }
    return(userMod.jsson)

}

//6. save userDict and plat data (in case of no connection, show saved data)

//func saveUserDict(userDict: NSDictionary) {
//    let defaults = NSUserDefaults.standardUserDefaults()
//    defaults.setObject(userDict, forKey: "myUserDict")
//    defaults.synchronize()
//}

func saveUserDict() {
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let url: NSURL = NSURL(string: "\(conIP)ViewProfile.php")!
    var session: NSURLSession
    var JSON: NSDictionary?
    session = NSURLSession.sharedSession()
    let request = NSMutableURLRequest(URL: url)
    request.HTTPMethod = "POST"
    print("getting user dict")
    let userID = getSavedLogin()![2]
    let paramString = "selectID=\(userID)"
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
            let refinedUserDict = ["userID":userID as! String,
                                   "name": getSavedLogin()![0] as! String,
                                   "contact":JSON!["contact"] as! String,
                                   "email":JSON!["email"] as! String,
                                   "votes":JSON!["votes"] as! Int,
                                   "profURL": JSON!["profileimage"] as! String,
                                   "plantURL": JSON!["plantimage"] as! String,
                                   "department":JSON!["dept"] as! String,
                                   "plantDescript":JSON!["plantcomment"] as! String,
                                   "plantType":JSON!["type"] as! String]
            
            defaults.setObject(refinedUserDict, forKey: "myUserDict")
            
        } catch let error {
            print("parsing error=\(error)")
        }
        
        
    }
    task.resume()
    
}

func getSavedUserDict() -> NSDictionary? {
    let defaults = NSUserDefaults.standardUserDefaults()
    if let savedUserDict = defaults.objectForKey("myUserDict") {
        return savedUserDict as? NSDictionary
    } else {
        return nil
    }
}

func savePlantData(plantObj: officePlant) {
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.setObject(plantObj, forKey: "mySavedPlantData")
    defaults.synchronize()
}

func getSavedPlantData() -> officePlant? {
    let defaults = NSUserDefaults.standardUserDefaults()
    if let savedPlantData = defaults.objectForKey("mySavedPlantData") {
        return savedPlantData as? officePlant
    } else {
        return nil
    }
}

func saveFeedData(feedList: NSDictionary) {
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.setObject(feedList, forKey: "mySavedFeed")
    defaults.synchronize()
}

func getSavedFeedData() -> NSDictionary? {
    let defaults = NSUserDefaults.standardUserDefaults()
    if let savedFeed = defaults.objectForKey("mySavedFeed") {
        return savedFeed as? NSDictionary
    } else {
        return nil
    }
}




//------------------------------------------



// class for login view controller

class LoginViewController: UIViewController, UserModelProtocol {

    @IBOutlet var loginTextField: UITextField!

    @IBOutlet var passwordTextField: UITextField!

    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var waitCursor: UIActivityIndicatorView!
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBAction func tapLogIn(sender: UIButton) {
        //self.waitCursor.startAnimating()
        if let typedUsername = loginTextField.text,
            let typedPass = passwordTextField.text {
            print("\(typedUsername) \(typedPass)")
            var gatheredLogin = NSDictionary?()
            gatheredLogin = getLoginData(typedUsername, password: typedPass)
            
            while gatheredLogin == nil {
                _ = 70
            }
            if gatheredLogin!["status"] as! String == "not found" {
                print("user not found")
                let noUserAlert = UIAlertController(title: "User not found", message:"Please check if you have entered the correct username and password.", preferredStyle: UIAlertControllerStyle.Alert)
                noUserAlert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler:nil))
                self.presentViewController(noUserAlert, animated: true, completion: nil)
                
            } else if gatheredLogin!["status"] as! String == "connection error" {
                print("connection error")
                let noUserAlert = UIAlertController(title: "Connection Error", message:"Please check if you are connected to your office network.", preferredStyle: UIAlertControllerStyle.Alert)
                noUserAlert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler:nil))
                self.presentViewController(noUserAlert, animated: true, completion: nil)
            } else {
                saveLogin(typedUsername, pass: typedPass, userID: gatheredLogin!["userID"] as! String)
                saveUserDict()
                self.performSegueWithIdentifier("toHomeSegue", sender: self)
            }

        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotification()
    }
    
    func registerKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardDidShow(_:)), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unregisterKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardDidShow(notif: NSNotification) {
        let userMeta: NSDictionary = notif.userInfo!
        let keyboardSize = userMeta.objectForKey(UIKeyboardFrameBeginUserInfoKey)!.CGRectValue().size
        let contentInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        view.frame.size.height += keyboardSize.height
        if CGRectContainsPoint(view.frame, loginTextField.frame.origin) {
            let scrollPoint = CGPointMake(0, loginTextField.frame.origin.y + keyboardSize.height/2 )
            scrollView.setContentOffset(scrollPoint, animated: true)
        }
    }
    
    func keyboardWillHide(notif: NSNotification) {
//        scrollView.contentInset = UIEdgeInsetsZero
//        scrollView.scrollIndicatorInsets = UIEdgeInsetsZero
    }
    
    
    
    func itemsDownloaded(items: NSArray) {
        print("protocol activated")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    @IBAction func showHello() {
        let helloalert = UIAlertController(title: "There's Nowhere to Go", message:"If you have forgotten your password, this app can't do anything for you. Go apologize to your boss and ask him for a password reset.", preferredStyle: UIAlertControllerStyle.Alert)
        helloalert.addAction(UIAlertAction(title: "OK then... bye...", style: UIAlertActionStyle.Default, handler:nil))
        self.presentViewController(helloalert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        var ovc = segue.destinationViewController as SecondViewController
//        
//    }

}