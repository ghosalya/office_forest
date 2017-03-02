//
//  UpgradeViewController.swift
//  Office Forest App
//
//  Created by student on 7/22/16.
//  Copyright © 2016 SUTD-ZJU Collaboration. All rights reserved.
//

import UIKit

class UpgradeViewController: UIViewController {
    
    var featureDict: NSDictionary?
    var votes: Int?
    
    //hexaforest
    @IBOutlet var hexa: UILabel!
    @IBOutlet var forest: UILabel!
    @IBOutlet var hexaforest: UIImageView!
    
    //growlight
    @IBOutlet var grow: UILabel!
    @IBOutlet var glight: UILabel!
    @IBOutlet var growlight: UIImageView!
    
    //light sensor
    @IBOutlet var lights: UILabel!
    @IBOutlet var lsensor: UILabel!
    @IBOutlet var lightsensor: UIImageView!
    
    //temp sensor
    @IBOutlet var tempp: UILabel!
    @IBOutlet var tsensor: UILabel!
    @IBOutlet var tempsensor: UIImageView!
    
    //water sensor
    @IBOutlet var water: UILabel!
    @IBOutlet var wsensor: UILabel!
    @IBOutlet var watersensor: UIImageView!
    
    //humidity sensor
    @IBOutlet var humidity: UILabel!
    @IBOutlet var hsensor: UILabel!
    @IBOutlet var humiditysensor: UIImageView!
    
    //backlight
    @IBOutlet var backl: UILabel!
    @IBOutlet var blight: UILabel!
    @IBOutlet var backlight: UIImageView!
    
    //motion sensor
    @IBOutlet var motion: UILabel!
    @IBOutlet var msensor: UILabel!
    @IBOutlet var motionsensor: UIImageView!
    
    
    @IBOutlet var vote1: UILabel!
    @IBOutlet var vote15: UILabel!
    @IBOutlet var vote25: UILabel!
    @IBOutlet var vote50: UILabel!
    @IBOutlet var vote100: UILabel!
    @IBOutlet var vote80: UILabel!
    
    
    func updateSelf() {
        updateVoteNumber()
        loadFeatureList()
        while featureDict == nil {
            _ = 0
        }
        let feat = featureDict! as! [String: String]
        
        EnableHexaForest(feat["Name"]!.toBool()!)
        enableBackLight(feat["BGLight"]!.toBool()!)
        enableWaterSensor(feat["Water"]!.toBool()!)
        enableMotionSensor(feat["PIR"]!.toBool()!)
        enableHumiditySensor(feat["Moisture"]!.toBool()!)
        enableTemperatureSensor(feat["Temperature"]!.toBool()!)
        EnableGrowLight(feat["GrowLight"]!.toBool()!)
        EnableLightSensor(feat["Light"]!.toBool()!)
        
        
    }
    
    override func viewDidLoad() {
        print("view loading")
        super.viewDidLoad()
        updateSelf()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        updateSelf()
        startAnime()
        
    }
    
    @IBAction func tapBack(sender: AnyObject) {
        performSegueWithIdentifier("unwindToProfile", sender: self)
    }
    
    
    /// ANIMATION :9
    func startAnime() {
        let feat = featureDict! as! [String: String]
        animateHexaForest(votes! >= 1 && !feat["Name"]!.toBool()!)
        animateGrowLight(votes! >= 15 && !feat["GrowLight"]!.toBool()!)
        animateLightTemp(votes! >= 25 && !feat["Light"]!.toBool()! && !feat["Temperature"]!.toBool()!)
        animateWaterHumid(votes! >= 50 && !feat["Water"]!.toBool()! && !feat["Moisture"]!.toBool()!)
        animateBackLight(votes! >= 80 && !feat["BGLight"]!.toBool()!)
        animateMotionSensor(votes! >= 100 && !feat["PIR"]!.toBool()!)

    }
    
    @IBAction func tapColor(sender: AnyObject) {
        let feat = featureDict as! [String: String]
        if feat["BGLight"]!.toBool()! {
            performSegueWithIdentifier("changeColorSegue", sender: self)
        } else {
            let messageAlert = UIAlertController(title: "Feature Locked", message:"Hexapot's back light is not available for you yet.", preferredStyle: UIAlertControllerStyle.Alert)
            messageAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil))
            self.presentViewController(messageAlert, animated: true, completion: nil)
        }
    }
    
    func animateHexaForest(enable: Bool) {
        if enable {
            print("animating")
            UIView.animateWithDuration(0.5, delay: 0.0, options: [.Repeat, .Autoreverse] , animations: {
                self.hexa.alpha = 1
                self.hexaforest.alpha = 1
                self.forest.alpha = 1
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    func animateGrowLight(enable: Bool) {
        if enable {
            print("animating")
            UIView.animateWithDuration(0.5, delay: 0.0, options: [.Repeat, .Autoreverse] , animations: {
                self.grow.alpha = 1
                self.growlight.alpha = 1
                self.glight.alpha = 1
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    func animateLightTemp(enable: Bool) {
        if enable {
            print("animating")
            UIView.animateWithDuration(0.5, delay: 0.0, options: [.Repeat, .Autoreverse] , animations: {
                self.lights.alpha = 1
                self.lightsensor.alpha = 1
                self.lsensor.alpha = 1
                self.tempp.alpha = 1
                self.tempsensor.alpha = 1
                self.tsensor.alpha = 1
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    func animateWaterHumid(enable: Bool) {
        if enable {
            print("animating")
            UIView.animateWithDuration(0.5, delay: 0.0, options: [.Repeat, .Autoreverse] , animations: {
                self.water.alpha = 1
                self.watersensor.alpha = 1
                self.wsensor.alpha = 1
                self.humidity.alpha = 1
                self.hsensor.alpha = 1
                self.humiditysensor.alpha = 1
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    func animateBackLight(enable: Bool) {
        if enable {
            print("animating")
            UIView.animateWithDuration(0.5, delay: 0.0, options: [.Repeat, .Autoreverse] , animations: {
                self.backl.alpha = 1
                self.backlight.alpha = 1
                self.blight.alpha = 1
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    func animateMotionSensor(enable: Bool) {
        if enable {
            print("animating")
            UIView.animateWithDuration(0.5, delay: 0.0, options: [.Repeat, .Autoreverse] , animations: {
                self.motion.alpha = 1
                self.motionsensor.alpha = 1
                self.msensor.alpha = 1
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    
    /// DISPLAY ALPHA
    func updateVoteNumber() {
        votes = getSavedUserDict()!["votes"] as? Int
        
        if votes! >= 1 {
            vote1.alpha = 1
        }
        
        if votes! >= 15 {
            vote15.alpha = 1
        }
        
        if votes! >= 25 {
            vote25.alpha = 1
        }
        
        if votes! >= 50 {
            vote50.alpha = 1
        }
        
        if votes! >= 80 {
            vote80.alpha = 1
        }
        
        if votes! >= 100 {
            vote100.alpha = 1
        }
    }
    
    func EnableHexaForest(enable: Bool) {
        if enable {
            hexa.alpha = 1
            forest.alpha = 1
            hexaforest.alpha = 1
        } else {
            hexaforest.alpha = 0.3
            hexa.alpha = 0.3
            forest.alpha = 0.3
        }
    }
    
    func EnableGrowLight(enable: Bool) {
        if enable {
            grow.alpha = 1
            growlight.alpha = 1
            glight.alpha = 1
        } else {
            grow.alpha = 0.3
            growlight.alpha = 0.3
            glight.alpha = 0.3
        }
    }
    
    func EnableLightSensor(enable: Bool) {
        if enable {
            lights.alpha = 1
            lsensor.alpha = 1
            lightsensor.alpha = 1
        } else {
            lights.alpha = 0.3
            lsensor.alpha = 0.3
            lightsensor.alpha = 0.3
        }
    }
    
    func enableTemperatureSensor(enable: Bool) {
        if enable {
            tempp.alpha = 1
            tsensor.alpha = 1
            tempsensor.alpha = 1
        } else {
            tempsensor.alpha = 0.3
            tsensor.alpha = 0.3
            tempp.alpha = 0.3
        }
    }
    
    func enableWaterSensor(enable: Bool) {
        if enable {
            water.alpha = 1
            wsensor.alpha = 1
            watersensor.alpha = 1
        } else {
            watersensor.alpha = 0.3
            water.alpha = 0.3
            wsensor.alpha = 0.3
        }
    }
    
    func enableHumiditySensor(enable: Bool) {
        if enable {
            humidity.alpha = 1
            hsensor.alpha = 1
            humiditysensor.alpha = 1
        } else {
            humiditysensor.alpha = 0.3
            humidity.alpha = 0.3
            hsensor.alpha = 0.3
        }
    }
    
    func enableBackLight(enable: Bool) {
        if enable {
            backl.alpha = 1
            blight.alpha = 1
            backlight.alpha = 1
        } else {
            backl.alpha = 0.3
            blight.alpha = 0.3
            backlight.alpha = 0.3
        }
    }
    
    func enableMotionSensor(enable: Bool) {
        if enable {
            motion.alpha = 1
            msensor.alpha = 1
            motionsensor.alpha = 1
        } else {
            motionsensor.alpha = 0.3
            msensor.alpha = 0.3
            motion.alpha = 0.3
        }
    }
    
    /// TAP HANDLER
    @IBAction func tapHexaForest(recog: UITapGestureRecognizer) {
        let feat = featureDict! as! [String: String]
        if votes! >= 1 && !feat["Name"]!.toBool()! {
            upgradeFeature("Name")
            self.hexaforest.layer.removeAllAnimations()
            self.hexa.layer.removeAllAnimations()
            self.forest.layer.removeAllAnimations()
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwindToProfile" {
            let page = segue.destinationViewController as! ThirdViewController
            page.loadFeatureList()
            page.updateSelf()
        }
    }
    
    @IBAction func tapGrowLight(recog: UITapGestureRecognizer) {
        let feat = featureDict! as! [String: String]
        if votes! >= 15 && !feat["GrowLight"]!.toBool()! {
            upgradeFeature("GrowLight")
            self.growlight.layer.removeAllAnimations()
            self.grow.layer.removeAllAnimations()
            self.glight.layer.removeAllAnimations()
        }
    }
    
    @IBAction func tapLightSensor(recog: UITapGestureRecognizer) {
        let feat = featureDict! as! [String: String]
        if votes! >= 25 && !feat["Light"]!.toBool()! && !feat["Temperature"]!.toBool()! {
            upgradeFeature("Light")
            self.lights.layer.removeAllAnimations()
            self.lsensor.layer.removeAllAnimations()
            self.lightsensor.layer.removeAllAnimations()
            self.tempsensor.layer.removeAllAnimations()
            self.tempp.layer.removeAllAnimations()
            self.tsensor.layer.removeAllAnimations()
            self.tempp.alpha = 0.3
            self.tempsensor.alpha = 0.3
            self.tsensor.alpha = 0.3
        }
        
    }
    
    @IBAction func tapTempSensor(recog: UITapGestureRecognizer) {
        let feat = featureDict! as! [String: String]
        if votes! >= 25 && !feat["Light"]!.toBool()! && !feat["Temperature"]!.toBool()! {
            upgradeFeature("Temperature")
            self.lights.layer.removeAllAnimations()
            self.lsensor.layer.removeAllAnimations()
            self.lightsensor.layer.removeAllAnimations()
            self.tempsensor.layer.removeAllAnimations()
            self.tempp.layer.removeAllAnimations()
            self.tsensor.layer.removeAllAnimations()
            self.lights.alpha = 0.3
            self.lightsensor.alpha = 0.3
            self.lsensor.alpha = 0.3
        }
        
    }
    
    @IBAction func tapWaterSensor(recog: UITapGestureRecognizer) {
        let feat = featureDict! as! [String: String]
        if votes! >= 50 && !feat["Water"]!.toBool()! && !feat["Moisture"]!.toBool()! {
            upgradeFeature("Water")
            self.water.layer.removeAllAnimations()
            self.wsensor.layer.removeAllAnimations()
            self.watersensor.layer.removeAllAnimations()
            self.humiditysensor.layer.removeAllAnimations()
            self.humidity.layer.removeAllAnimations()
            self.hsensor.layer.removeAllAnimations()
            self.humidity.alpha = 0.3
            self.humiditysensor.alpha = 0.3
            self.hsensor.alpha = 0.3
        }
        
    }
    
    @IBAction func tapHumiditySensor(recog: UITapGestureRecognizer) {
        let feat = featureDict! as! [String: String]
        if votes! >= 50 && !feat["Water"]!.toBool()! && !feat["Moisture"]!.toBool()! {
            upgradeFeature("Moisture")
            self.water.layer.removeAllAnimations()
            self.wsensor.layer.removeAllAnimations()
            self.watersensor.layer.removeAllAnimations()
            self.humiditysensor.layer.removeAllAnimations()
            self.humidity.layer.removeAllAnimations()
            self.hsensor.layer.removeAllAnimations()
            self.water.alpha = 0.3
            self.watersensor.alpha = 0.3
            self.wsensor.alpha = 0.3
        }
        
    }
    
    @IBAction func tapBackLight(recog: UITapGestureRecognizer) {
        let feat = featureDict! as! [String: String]
        if votes! >= 80 && !feat["BGLight"]!.toBool()! {
            upgradeFeature("BGLight")
            self.backl.layer.removeAllAnimations()
            self.blight.layer.removeAllAnimations()
            self.backlight.layer.removeAllAnimations()
        }
        
    }
    
    @IBAction func tapMotionSensor(recog: UITapGestureRecognizer) {
        let feat = featureDict! as! [String: String]
        if votes! >= 100 && !feat["PIR"]!.toBool()! {
            upgradeFeature("PIR")
            self.motion.layer.removeAllAnimations()
            self.msensor.layer.removeAllAnimations()
            self.motionsensor.layer.removeAllAnimations()
        }
        
    }
    
    @IBAction func unwindToUpgrades(segue: UIStoryboardSegue) {
        
    }
    
    
    
    func upgradeFeature(feature: String) {
        let url: NSURL = NSURL(string: "\(conIP)ActivateFeature.php")!
        var session: NSURLSession
        session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let userID = getSavedLogin()![2]
        let paramString = "userID=\(userID)&feature=\(feature)"
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
                
            } catch let error {
                print("parsing error=\(error)")
            }
        }
        task.resume()
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
                let feature = ["Name": (jsson!["Name"] as! String), "Water": (jsson!["Water"] as! String), "Light": (jsson!["Light"] as! String) ,"Moisture": (jsson!["Moisture"] as! String), "Temperature": (jsson!["Temperature"] as! String) ,"GrowLight": (jsson!["GrowLight"] as! String),"BGLight": (jsson!["BGLight"] as! String),"PIR":(jsson!["PIR"] as! String) ]
                self.featureDict = feature
                
                
            } catch let error {
                print("parsing error=\(error)")
            }
        }
        task.resume()
    }
    
    
    
}

extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}
