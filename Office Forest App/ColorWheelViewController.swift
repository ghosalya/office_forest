//
//  ViewController.swift
//  ColorWheel
//
//  Created by Tommie N. Carter, Jr., MBA on 4/9/15.
//  Copyright (c) 2015 MING Technology. All rights reserved.
//

import UIKit

class ColorViewController: UIViewController {
    
    var updateTimer = NSTimer()
    var updateStatus: String = "0"
    
    @IBOutlet var activityIndic: UIActivityIndicatorView!
    @IBOutlet weak var colorOutput: UIView!
    @IBOutlet weak var colorWheel: ColorWheel!
    @IBAction func handleTapGesture(gesture: UITapGestureRecognizer) {
        
        let point = gesture.locationInView(colorWheel)
        let celColor = colorWheel.colorAtPoint(point)
        print("\(celColor)")
        print("\(point)")
        print(celColor.rgb())
        
        colorOutput.backgroundColor = colorWheel.colorAtPoint(point)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("color wheel incoming")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapBack(sender: AnyObject) {
        self.performSegueWithIdentifier("unwindToUpgrades", sender: self)
    }

    @IBAction func tapSelectColor(sender: AnyObject) {
        self.sendColor((colorOutput.backgroundColor?.rgb())!)
        self.activityIndic.startAnimating()
        loopCheckInfo()
//        self.performSegueWithIdentifier("unwindToUpgrades", sender: self)
    }
    
//    @IBAction func unwindToUpgrades(segue: UIStoryboardSegue) {
//
//    }
    
    func sendColor(hex: [Int]) {
        let url: NSURL = NSURL(string: "\(conIP)LEDColourChange.php")!
        var session: NSURLSession
        session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let userID = getSavedLogin()![2]
        let paramString = "userID=\(userID)&red=\(hex[0])&green=\(hex[1])&blue=\(hex[2])"
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
                self.updateStatus = (jsson!["Command"] as! String)
                print("command: \(self.updateStatus)")
                
                if self.updateStatus == "0" {
                    self.updateTimer.invalidate()
//                    self.refreshPlantInfo()
                    self.activityIndic.stopAnimating()
                    self.performSegueWithIdentifier("unwindToUpgrades", sender: self)
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

}

