//
//  FirstViewController.swift
//  Occife Swamp
//
//  Created by student on 6/12/16.
//  Copyright © 2016 Zhejiang High. All rights reserved.
//

import UIKit

//class FirstViewController: UIViewController {//, HomeModelProtocol {
//    
//    let screenSize: CGRect = UIScreen.mainScreen().bounds
//    
//    var defaultImage: UIImage? = UIImage(named: "defplant")
//    
//// DUMMY LIST
//    
//    var feedList = [["name": "Fok Jun Yi","descript": "This level 45 plant has gone through meticulous grooming"],
//                    ["name": "Samuel Low","descript": "A level 38 plant that might as well be an occifer"],
//                    ["name": "Samuel Low","descript": "A level 38 plant that is thick and hard"],
//                    ["name": "Chen Jing","descript": "The plant that stayed at level 3 for almost 7 years"],
//                    
//                    // Lel, did you discover this Gede?
//                    ["name": "Basil","descript": "This level 35 plant leafs behind a message"],
//                    ["name": "Michael","descript": "This level owl plant does not sleep"],
//                    ["name": "eBot","descript": "This level -1 plant may as well not exist for the sake of humanity"],
//                    ["name": "eBot","descript": "This level -1 plant saps the life out of its peers"],
//                    ["name": "Vincent","descript": "This level 9999 plant has not left the occife for a while"],
//                    ["name": "Stella","descript":"Level 1 plant is doing stellar"],
//                    ["name": "Tenpai","descript": "Worry not, for this level 29 plant has noticed you"],
//                    ["name": "Gede","descript": "This level 278 plant is... hey, that's racist!"]
//    
//                    //and the dictionary goes on
//                    //but life does not :(
//                    ]
////
////    
////    
////    DUMMY LIST END
//    
//    
//// server list generator
//    //
////    var feedList: NSArray = NSArray()
////    
////    func itemsDownloaded(items: NSArray) {
////        feedList = items
////    }
//    
//    var feedViewList: [feedItemView] = []
//    @IBOutlet var feedScrollView: UIScrollView!
////    @IBOutlet var feedScrollStack: UIStackView!
////    
////    class feedItemView: UIStackView{ //Class of feed items to scroll down
//        var image: UIImage?
//        var imageView: UIImageView
//        var framebox: CGRect
//        var name: UILabel
//        var descript: UITextView
////        var textView: UIStackView
//        var ID: String = "00000000"
//        
//        init(image: UIImage?, name: String?, descript: String?, frame: CGRect) { //Init takes name and descript as string, but image as UIImage, and frame CGRect
//            self.image = image
//            self.framebox = frame
//            self.imageView = UIImageView(image: self.image)
//            self.imageView.image = self.image
//            self.imageView.frame = CGRectMake(0, 0, 75, frame.height)
//            self.imageView.contentMode = .ScaleAspectFit
//            self.name = UILabel(frame: CGRectMake(0,0, frame.width * 0.8, frame.height * 0.3))
//            self.name.text = name
//            self.descript = UITextView(frame: CGRectMake(0, frame.height * 0.3, frame.width * 0.8, frame.height * 0.7))
//            self.descript.text = descript
//            self.descript.textColor = UIColor.grayColor()
//            self.descript.textAlignment = NSTextAlignment.Left
//            self.descript.editable = false
////            self.textView = UIStackView(frame: CGRectMake(0.3 * frame.width, 0, frame.width - 75, frame.height))
//            self.textView.axis = .Vertical
//            
//            super.init(frame: self.framebox)
//            self.axis = .Horizontal
//            self.updateSelf()
//        }
//        
//        required init?(coder aDecoder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//        
//        func clearSelf() {
//            self.imageView.removeFromSuperview()
//            self.textView.removeFromSuperview()
//        }
//        
//        func updateSelf() {
//
//            self.addSubview(self.imageView)
//            self.textView.addSubview(self.name)
//            self.textView.addSubview(self.descript)
//            self.addSubview(self.textView)
//        }
//    }
//    
//    @IBAction func updateFeed() {
//        self.feedViewList = [] //purge everything inside to refresh
//        var indx = 0
//        var indc: CGFloat = 0
//        for feeds in self.feedList {
//            self.feedViewList.append(feedItemView(image: self.defaultImage, name: feeds["name"], descript: feeds["descript"], frame: CGRectMake(0, 25 + (75 * indc), 350, 70)))
//            self.feedScrollStack.addSubview(self.feedViewList[indx])
//            //self.feedScrollView.frame = self.feedScrollStack.frame
//            indx += 1
//            indc += 1
//        }
//        self.feedScrollView.directionalLockEnabled = true
//        print("stackviewheight=\(self.feedScrollStack.frame.height)")
//        self.feedScrollView.contentSize.height = self.feedScrollStack.frame.height
//    }
//    
////    @IBAction func tapLogOut(sender: AnyObject) {
////        let defaults = NSUserDefaults.standardUserDefaults()
////        defaults.removeObjectForKey("myUsername")
////        defaults.removeObjectForKey("myPassword")
////        //defaults.setValue(user, forKey: "myUsername")
////        //defaults.setValue(pass, forKey: "myPassword")
////        defaults.synchronize()
////        toLoginScreen(self)
////    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        self.updateFeed()
//    }
//    
//    override func viewDidAppear(animated: Bool) {
//        toLoginScreen(self)
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//
//}
//
