//
//  SecondViewController.swift
//  Occife Swamp
//
//  Created by student on 6/12/16.
//  Copyright © 2016 Zhejiang High. All rights reserved.
//

import Foundation
import UIKit

class waterContainerView: UIView {
    
}

class plantContainerView: UIView {
    
}


class SecondViewController: UIViewController {
    
    
    weak var loadedPlant: officePlant?
        var featureDict: NSDictionary?
    var connectionerror = false
    
    var needRefreshPic = false
    
    var updateStatus = "0"
    var updateTimer = NSTimer()
    
    @IBOutlet var waterProgressLabel: UILabel!

    @IBOutlet var lightProgresslabel: UILabel!
    @IBOutlet var plantImageView: UIImageView!
    
    @IBOutlet var tempProgressLabel: UILabel!

    
    @IBOutlet var plantNameLabel: UILabel!
    
    @IBOutlet var plantTextView: UITextView!
    
    @IBOutlet var refreshWaitCursor: UIActivityIndicatorView!
    
    @IBOutlet var changeColorButton: UIButton!
    
    @IBOutlet var sunImage: UIImageView!
    @IBOutlet var waterImage: UIImageView!
    @IBOutlet var temperImage: UIImageView!
    lazy var userDict = NSDictionary()
    
    func updateScreen(plantObj: officePlant) {
//        self.waterProgressLabel.text = "\(plantObj.waterLevel)%"
//        self.plantLevelLabel.text = "Level \(plantObj.level)"
        self.plantNameLabel.text = "\(plantObj.plantType)"
        self.plantTextView.text = plantObj.Descript
//        self.plantTextView.font = UIFont(name: "Avenir Next Condensed", size: 14)
        
        
//        if plantObj.waterLevel < 25 {
//            waterImage.image = UIImage(named: "Water Red")
//        } else {
//            waterImage.image = UIImage(named: "Water")
//        }
//        
//        if plantObj.light < 25 {
//            sunImage.image = UIImage(named: "Sun Red")
//        } else {
//            sunImage.image = UIImage(named: "Sun Green")
//        }
        
        if featureDict != nil {
            if featureDict!["Light"] as! String == "0" {
                self.lightProgresslabel.alpha = 0
                self.sunImage.alpha = 0
            } else {
                self.lightProgresslabel.alpha = 1
                self.sunImage.alpha = 1
            }
            
            if featureDict!["Temperature"] as! String == "0" {
                self.tempProgressLabel.alpha = 0
                self.temperImage.alpha = 0
            } else {
                self.temperImage.alpha = 1
                self.tempProgressLabel.alpha = 1
            }
            
            if featureDict!["Moisture"] as! String == "0" {
                self.waterProgressLabel.alpha = 0
                self.waterImage.alpha = 0
            } else {
                self.waterProgressLabel.alpha = 1
                self.waterImage.alpha = 1
            }
            
        }
        
        self.lightProgresslabel.text = "\(plantObj.light)"
        self.waterProgressLabel.text = "\(plantObj.waterLevel)"
        self.tempProgressLabel.text = "\(plantObj.temperature)"

        
        
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
//                dispatch_async(dispatch_get_main_queue(), self.updateS)
                
            } catch let error {
                print("parsing error=\(error)")
            }
        }
        task.resume()
    }
    
    
    
    @IBAction func updatePlantImage(sender: AnyObject) {
        self.performSegueWithIdentifier("imageUpload", sender: self)
    }
    
//    @IBAction func tapChangeColor(sender: AnyObject) {
//        print("gg to color wheel")
//        self.performSegueWithIdentifier("colorPick", sender: sender)
//    }

    @IBAction func unwindToPlant(segue: UIStoryboardSegue) {
        refreshPlantPic()
        refreshPlantInfo()
    }
    
    @IBOutlet var updatePlantImage: UIButton!
    func refreshPlantPic() {
        let userID = getSavedLogin()![2]
        let param = "userID=\(userID)"
        print(param)
        let imgurl = getDownloadedImage("\(conIP)ProfileImageDisplay.php", param: param.dataUsingEncoding(NSUTF8StringEncoding)!)
        print(imgurl)
        if let prof = imgurl!["plant"] as? String {
            let urlprof = "http://192.168.168.7/\(prof)"
            load_image(urlprof)
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
                    self.plantImageView.image = UIImage(data: data!)
                }
                if self.plantImageView.image != UIImage(data: data!) {
                    dispatch_async(dispatch_get_main_queue(), display_image)
                }
                
            }
            
        }
        
        task.resume()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("checking login")
        if !isLoggedIn() {
            
        } else {
            print("getting data")
            let userDict = getLoginData(getSavedLogin()![0] as! String, password: getSavedLogin()![1] as! String)!
            //if var userDict = getSavedUserDict() {
            print("userdict: \(userDict)")
            if userDict["status"] as? String == "success" {
                
                print("building page \(userDict["name"])")
                let loadedPlant = officePlant(name: "Yet another plant", owner: userDict["name"] as? String, plantID: "90966")
                self.loadedPlant = officePlant(name: "Yet another plant", owner: userDict["name"] as? String, plantID: "90966")
                print(loadedPlant)
                loadFeatureList()
                while self.featureDict == nil {
                    _ = 0
                }
                updateScreen(loadedPlant)
                refreshPlantPic()
                refreshPlantInfo()
            } else {
                connectionerror = true
            }
        }
        
    }


    override func viewDidAppear(animation: Bool) {
        super.viewDidAppear(true)
        if connectionerror {
            handleConErr(self)
        }
        if !isLoggedIn() {
            toLoginScreen(self)
        }
        if needRefreshPic {
            refreshPlantPic()
            needRefreshPic = false
        }
        // Do any additional setup after loading the view, typically from a nib.
//        print("checking login")
//        if toLoginScreen(self) {
//            
//        } else {
//        print("getting data")
//        let userDict = getLoginData(getSavedLogin()![0] as! String, password: getSavedLogin()![1] as! String)!
//        //if var userDict = getSavedUserDict() {
//            print("userdict: \(userDict)")
//            if userDict["status"] as? String == "connection error" {
//                handleConErr(self)
//            } else {
//            print("building page \(userDict["name"])")
//            let loadedPlant = officePlant(name: "Yet another plant", owner: userDict["name"] as? String, plantID: "90966")
//            self.loadedPlant = officePlant(name: "Yet another plant", owner: userDict["name"] as? String, plantID: "90966")
//            print(loadedPlant)
//            updateScreen(loadedPlant)
//            refreshPlantPic()
//            refreshPlantInfo()
//            }
//        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func tapEditWriteup(sender: AnyObject) {
        performSegueWithIdentifier("writeupSegue", sender: self)
    }

    @IBAction func tapRefreshPlant(sender: AnyObject) {
        self.refreshWaitCursor.startAnimating()
        self.sendChangeCommand()
        self.loopCheckInfo()
    }
    
    func sendChangeCommand() {
        let url: NSURL = NSURL(string: "\(conIP)changecommand.php")!
        var session: NSURLSession
        session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let userID = getSavedLogin()![2]
        let paramString = "userID=\(userID)"
        print("Sending command for \(paramString)")
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
    
    func checkForInfoUpdate() {
        //call a php that uses while loop
        self.updateStatus = "1"
        
        let url: NSURL = NSURL(string: "\(conIP)CommandQuery.php")!
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
                    self.updateStatus = jsson!["Command"] as! String
                    print("command: \(self.updateStatus)")
                    
                    if self.updateStatus == "0" {
                        self.updateTimer.invalidate()
                        self.refreshPlantInfo()
                    }
                    
                } catch let error {
                    print("parsing error=\(error)")
                }
                
            }
            task.resume()


    }
    
    func loopCheckInfo() {
        print("changing loop")
        self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(self.checkForInfoUpdate), userInfo: nil, repeats: true )
    }
    
    @IBAction func tapUpgrades(sender: AnyObject) {
        print("go upgrade")
        performSegueWithIdentifier("upgradeSegue", sender: self)
    }
    
    
    func refreshPlantInfo() {
        let url: NSURL = NSURL(string: "\(conIP)PlantInfo.php")!
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
                print("my loaded plant: \(self.loadedPlant)")
                let userDict = getSavedUserDict()
                let loadedPlant = officePlant(name: "Yet another plant", owner: userDict!["name"] as? String, plantID: "90966")
                let light = jsson!["light"] as! String
                loadedPlant.light = Float(light)!
                print("light: \(loadedPlant.light)")
                loadedPlant.waterLevel = Float(jsson!["Humid"] as! String)!
                print("water: \(loadedPlant.waterLevel)")
                loadedPlant.LEDcolor = [(jsson!["r"] as! String), (jsson!["g"] as! String),(jsson!["b"] as! String)]
                loadedPlant.plantType = jsson!["type"] as! String
                loadedPlant.Descript = jsson!["comment"] as! String
                loadedPlant.temperature = Int(jsson!["Temp"] as! String)!

                dispatch_sync(dispatch_get_main_queue(), {self.updateScreen(loadedPlant)
                self.refreshWaitCursor.stopAnimating()
                })
                
            } catch let error {
                print("parsing error=\(error)")
            }            
        }
        task.resume()

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "writeupSegue" {
            let writeupscene = segue.destinationViewController as! WriteupViewController
            writeupscene.myImage = self.plantImageView.image
            writeupscene.myWriteup = self.plantTextView.text
        }
    }

    @IBAction func tapComment(sender: AnyObject) {
        performSegueWithIdentifier("messageSegue", sender: self)
    }

}

