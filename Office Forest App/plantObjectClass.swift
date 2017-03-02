//
//  plantObjectClass.swift
//  Occife Swamp
//
//  Created by student on 6/14/16.
//  Copyright © 2016 Zhejiang High. All rights reserved.
//

import Foundation
import UIKit

//class plantPage: UIStackView {
//    
//    var liveStatusView: UIStackView //status view on top, for showing current water level .Horizontal
//    var waterLabel: UILabel
//    var waterStatus: UILabel
//
//    var plantStatsView: UIStackView //plant view below, showing pic n data .Horizontal
//    var plantLeftBar: UIStackView //left side of plant view, showing pic, lv, exp and brown seed (?) .Vertical
//    var plantImgView: UIImageView
//    var plantLevelView: UILabel
//    //var plantEXPView: UILabel
//    var plantRightBar: UIStackView //right side, showing name, owner, id, and other descript .Vertical
//    var plantOwnerView: UILabel
//    var plantTextView: UITextView
//    
//    
//    init(plantObj: officePlant, frame: CGRect) {
//        
//        self.liveStatusView = UIStackView(frame: CGRectMake(0,25,frame.width, 50)) //Creating liveStatusView
//        self.liveStatusView.axis = .Horizontal
//        self.waterLabel = UILabel(frame: CGRectMake(0,25,frame.width * 0.5,50))
//        self.waterLabel.text = "Water: "
//        self.waterLabel.textAlignment = .Center
//        self.waterStatus = UILabel(frame: CGRectMake(frame.width * 0.5,25,frame.width * 0.5, 50))
//        self.waterStatus.text = "\(plantObj.waterLevel) %"
//        self.waterStatus.textAlignment = .Left
//        self.liveStatusView.addArrangedSubview(self.waterLabel)
//        self.liveStatusView.addArrangedSubview(self.waterStatus)
//        
//        self.plantStatsView = UIStackView(frame: CGRectMake(0,100,frame.width,frame.height - 50))
//        self.plantStatsView.axis = .Horizontal
//        
//        self.plantLeftBar = UIStackView(frame: CGRectMake(25,50, 150, frame.height - 50))
//        self.plantLeftBar.axis = .Vertical
//        self.plantImgView = UIImageView(frame: CGRectMake(25,50, 100, 100))
//        self.plantImgView.image = plantObj.plantImg
//        self.plantImgView.contentMode = .ScaleAspectFill
//        self.plantLeftBar.addSubview(self.plantImgView)
//        self.plantLevelView = UILabel(frame: CGRectMake(25,150, 100, 50))
//        self.plantLevelView.text = "Level \(plantObj.level)"
//        self.plantLevelView.textAlignment = .Center
//        self.plantLeftBar.addSubview(self.plantLevelView)
//        
//        self.plantRightBar = UIStackView(frame: CGRectMake(100,50, frame.width - 100, frame.height - 50))
//        self.plantRightBar.axis = .Horizontal
//        self.plantOwnerView = UILabel(frame: CGRectMake(100,50, frame.width - 100, 50))
//        self.plantOwnerView.text = plantObj.owner
//        self.plantRightBar.addSubview(self.plantOwnerView)
//        self.plantTextView = UITextView(frame: CGRectMake(100, 100, frame.width - 100, frame.height - 100))
//        self.plantTextView.text = "\(plantObj.name) \n Level \(plantObj.level) - \(plantObj.exp) EXP \n \(plantObj.brownSeed) Brown Seeds Available"
//        self.plantTextView.textColor = UIColor.grayColor()
//        self.plantRightBar.addSubview(self.plantTextView)
//        
//        self.plantStatsView.addSubview(self.plantLeftBar)
//        self.plantStatsView.addSubview(self.plantRightBar)
//        
//        super.init(frame: frame)
//        self.axis = .Vertical
//        self.backgroundColor = UIColor.darkGrayColor()
//        self.addSubview(self.liveStatusView)
//        self.addSubview(self.plantStatsView)
//    }
//    
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

class officePlant {
    var name: String
    var plantID: String
    var owner: String
    var level: Int
    var exp: Int
    var waterLevel: Float
    var brownSeed: Int
    var plantImg: UIImage
    var light: Float
    var temperature: Int
    var LEDcolor: [String]
    var plantType: String
    var Descript: String
    
    init(name: String?, owner: String?, plantID: String?){
        if let myname = name {
            self.name = myname
        } else {
            self.name = "Yet another plant in the office"
        }
        if let myowner = owner {
            self.owner = myowner
        } else {
            self.owner = "Mother Nature"
        }
        if let myplantid = plantID {
            self.plantID = myplantid
        } else {
            self.plantID = "00000000"
        }
        self.plantImg = UIImage(named: "defplant")!
        self.level = 1
        self.exp = 0
        self.waterLevel = 0
        self.brownSeed = 0
        self.light = 0
        self.temperature = 0
        self.LEDcolor = []
        self.plantType = "Your mom"
        self.Descript = "Nondescript"
    }
}