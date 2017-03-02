//
//  EditDetailsViewController.swift
//  Office Forest App
//
//  Created by student on 7/7/16.
//  Copyright © 2016 SUTD-ZJU Collaboration. All rights reserved.
//

import UIKit

class EditDetailsViewController: UIViewController {
    
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var contactsTextField: UITextField!
    
    @IBOutlet var oldPassText: UITextField!
    
    @IBOutlet var newPassText: UITextField!
    
    @IBOutlet var confirmPassText: UITextField!
    
    @IBAction func tapBack(sender: AnyObject) {
        performSegueWithIdentifier("unwindToProfile", sender: self)
    }
    
    
    @IBAction func saveNewDetails(sender: AnyObject) {
        let newEmail = emailTextField.text
        let newContact = contactsTextField.text
        
        let url: NSURL = NSURL(string: "\(conIP)UpdateInfo.php")! //change php
        var session: NSURLSession
        session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let userID = getSavedLogin()![2]
        let paramString = "userID=\(userID)&email=\(newEmail)&contact=\(newContact)"
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
    

    @IBAction func tapChange(sender: AnyObject) {
        if newPassText.text! == confirmPassText.text! && oldPassText.text == getSavedLogin()![1] as! String {
            print("confirmed")
            
            let newPass = newPassText.text
            
            let url: NSURL = NSURL(string: "\(conIP)ChangePW.php")! // change address
            var session: NSURLSession
            session = NSURLSession.sharedSession()
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            let userID = getSavedLogin()![2]
            let paramString = "userID=\(userID)&newpw=\(newPass!)"
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
                    let userDict = getSavedLogin()
                    saveLogin(userDict![0] as! String, pass: self.newPassText.text!, userID: userDict![2] as! String)
                } catch let error {
                    print("parsing error=\(error)")
                }
                
                
                
            }
            task.resume()
            
            

        } else if newPassText.text! != confirmPassText.text! {
            let nomatchAlert = UIAlertController(title: "Error", message:"The password that you entered does not match your confirmed password. Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
            nomatchAlert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler:nil))
            self.presentViewController(nomatchAlert, animated: true, completion: nil)

        } else if oldPassText.text != getSavedLogin()![1] as! String {
            let nomatchAlert = UIAlertController(title: "Error", message:"Your old password does not match!", preferredStyle: UIAlertControllerStyle.Alert)
            nomatchAlert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler:nil))
            self.presentViewController(nomatchAlert, animated: true, completion: nil)
        }
        
        newPassText.text = ""
        confirmPassText.text = ""
        oldPassText.text = ""
        
        
    }
    
    
}
