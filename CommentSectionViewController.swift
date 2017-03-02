//
//  CommentSectionViewController.swift
//  Office Forest App
//
//  Created by student on 7/17/16.
//  Copyright © 2016 SUTD-ZJU Collaboration. All rights reserved.
//

import UIKit

class CommentSectionViewController: UIViewController {
    
    var selectedID = "0"
    var plantImage: UIImage?

    
    @IBOutlet var commentTextView: UITextView!
    
    @IBOutlet var commentButton: UIButton!

    override func viewDidLoad() {
        commentButton.layer.cornerRadius = commentButton.frame.height / 2
        commentButton.clipsToBounds = true
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //--------------
    }
    
    
    @IBAction func tapComment(sender: AnyObject) {
        if self.commentTextView.text == "" {
            print("no comment")
        } else {
            let date = NSDate().toFullString()
            print(date)
            sendComment(self.commentTextView.text, timestamp: date)
            self.commentTextView.text = ""
            let messageAlert = UIAlertController(title: "Commented!", message:"This user will be able to see your comment.", preferredStyle: UIAlertControllerStyle.Alert)
            messageAlert.addAction(UIAlertAction(title: "Return", style: UIAlertActionStyle.Default, handler: {
                (action: UIAlertAction!) in
                self.performSegueWithIdentifier("unwindToThatCoworker", sender: self)}
                )
                )
//            messageAlert.addAction(UIAlertAction(title: "Close", style: .Default, handler: nil))
            self.presentViewController(messageAlert, animated: true, completion: nil )

        }
    }
    
    @IBAction func tapBack(sender: AnyObject) {
        self.performSegueWithIdentifier("unwindToThatCoworker", sender: self)
        
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
//        performSegueWithIdentifier("unwindToThatCoworker", sender: self)
    }
    
}
