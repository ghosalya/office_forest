//
//  WriteupViewController.swift
//  Office Forest App
//
//  Created by student on 7/6/16.
//  Copyright © 2016 SUTD-ZJU Collaboration. All rights reserved.
//

import UIKit

class WriteupViewController: UIViewController {
    
    @IBOutlet var myPlantView: UIImageView!
    @IBOutlet var myWriteupTextView: UITextView!
    
    weak var myImage: UIImage?
    var myWriteup = "Lorem Ipsum Stuff"
    
    func updateSelf() {
//        self.myPlantView.image = myImage
        self.myWriteupTextView.text = myWriteup
    }
    
    @IBAction func tapSubmit(sender: AnyObject) {
        myWriteup = myWriteupTextView.text
        sendWriteup(myWriteupTextView.text)
//        performSegueWithIdentifier("unwindToPlant", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwindToPlant" {
            let page = segue.destinationViewController as! SecondViewController
            page.plantTextView.text = myWriteupTextView.text
        }
    }
    
    @IBAction func tapBack(sender: AnyObject) {
        performSegueWithIdentifier("unwindToPlant", sender: self)
    }
    
//    func load_image(urlString: String) {
//        let imgURL: NSURL = NSURL(string: urlString)!
//        let request: NSURLRequest = NSURLRequest(URL: imgURL)
//        
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithRequest(request){
//            (data, response, error) -> Void in
//            
//            if (error == nil && data != nil)
//            {
//                func display_image()
//                {
//                    self.myPlantView.image = UIImage(data: data!)
//                }
//                
//                dispatch_async(dispatch_get_main_queue(), display_image)
//            }
//            
//        }
//        
//        task.resume()
//
//    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateSelf()
        
    }
    
    func sendWriteup(writeup: String) {
        let url: NSURL = NSURL(string: "\(conIP)UpdateComment.php")!
        var session: NSURLSession
        session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let userID = getSavedLogin()![2]
        let paramString = "userID=\(userID)&MyComment=\(writeup)"
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
                print("commenting")
                print(jsson)
            } catch let error {
                print("parsing error=\(error)")
            }
            
            
            
        }
        task.resume()
        self.performSegueWithIdentifier("unwindToPlant", sender: self)
    }

}
