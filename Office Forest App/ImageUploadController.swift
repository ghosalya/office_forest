//
//  ViewController.swift
//  Office Forest App
//
//  Created by student on 6/22/16.
//  Copyright © 2016 SUTD-ZJU Collaboration. All rights reserved.
//

import UIKit

class ImageUploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imageViewer: UIImageView!
    
    //var urlString = "http://192.168.168.7/ProfileImageUpload.php"
    
    func urlString() -> String {
        return "\(conIP)ProfileImageUpload.php"
    }
    
    @IBOutlet var uploadType: UISegmentedControl!
    
    @IBAction func tapSelectImg(sender: AnyObject) {
        var myPickController = UIImagePickerController()
        myPickController.delegate = self
        myPickController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(myPickController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("photo selected")
        imageViewer.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    @IBAction func tapBack(sender: AnyObject) {
        unwindReturn()
    }
    
    @IBAction func uploadTapped(sender: AnyObject) {
        if imageViewer.image != nil {
            imageUploadRequest()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwindToPlant" {
            let plantscene = segue.destinationViewController as! SecondViewController
            plantscene.needRefreshPic = true
            
        } else if segue.identifier == "unwindToProfile" {
            let profscene = segue.destinationViewController as! ThirdViewController
            profscene.needRefreshPic = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imageUploadRequest () {



        let imgUploadURL = NSURL(string: self.urlString())
        let request = NSMutableURLRequest(URL:imgUploadURL!)
        request.HTTPMethod = "POST"
        let userID = getSavedLogin()![2]
        //let paramString = "userID=\(userID)"
        print("ID: \(userID)")
        let param = [

                    "userID": userID as! String
        ]
        print(param)
        
        // boundary and request setvalue?
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        if let imageData = UIImageJPEGRepresentation(imageViewer.image!, 0.5) {
            request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData, boundary: boundary)
            
            //start the connection 
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                data, response, error in
                
                if error != nil {
                    print("error=\(error)")
                    return
                }
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("responsestring=\(responseString!)")
                
                let httpStatus = response as? NSHTTPURLResponse
                print("status code = \(httpStatus?.statusCode)") //should be 200
                
                print(data)
                
                //var err:NSError?
                var jsson: NSDictionary?
                do { try jsson = (NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary)
                } catch let error {
                    print("parsing error=\(error)")
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.imageViewer.image = nil
                    })
                
                print(jsson)
                
                
            }
        task.resume()
        self.unwindReturn()
            
        } else {
            //no image selected
            return
        }
    }
    
    func unwindReturn() {
        self.performSegueWithIdentifier("unwindToProfile", sender: self)
    }
    
    func createBodyWithParameters(param: NSDictionary, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        var body = NSMutableData()
        for (key, value) in param {
            let userr = "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"
            let userv = "\(value)\r\n"
            body.appendString("--\(boundary)\r\n")
//            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//            body.appendString("\(value)\r\n")
            body.appendString(userr)
            body.appendString(userv)
        }
        
        let filename = "user-profile.jpg"
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        //body.appendString("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"user-profile.jpg\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        body.appendString("--\(boundary)--\r\n")
        return body
        
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
}

class imageUploaderPlantVC: ImageUploadViewController {
    override func urlString() -> String {
        return "\(conIP)PlantImageUpload.php"
    }
    
    override func unwindReturn() {
        self.performSegueWithIdentifier("unwindToPlant", sender: self)
    }
}

extension NSMutableData {
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}

