//
//  ColorWheel.swift
//  ColorWheel
//
//  Created by Tommie N. Carter, Jr., MBA on 4/9/15.
//  Copyright (c) 2015 MING Technology. All rights reserved.
//

import UIKit


struct ColorPath {
    var Path:UIBezierPath
    var Color:UIColor
}


@IBDesignable
class ColorWheel: UIView {
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
        center = super.center
//        self.layer.cornerRadius = self.frame.width/2
//        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    private var image:UIImage?=nil
    var imageView:UIImageView?=nil
    var paths=[ColorPath]()

    
    @IBInspectable var size:CGSize=CGSizeZero { didSet { setNeedsDisplay()} }
    @IBInspectable var sectors:Int = 360 { didSet { setNeedsDisplay()} }
    
    func colorAtPoint ( point: CGPoint) -> UIColor {
        for colorPath in 0..<paths.count {
            if paths[colorPath].Path.containsPoint(point) {
                return paths[colorPath].Color
            }
        }
        return UIColor.clearColor()
    }
    
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        
        let radius = CGFloat ( min(bounds.size.width, bounds.size.height) / 2.0 ) * 0.90
        let angle:CGFloat = CGFloat(2.0) * CGFloat (M_PI) / CGFloat(sectors)
        var colorPath:ColorPath = ColorPath(Path: UIBezierPath(), Color: UIColor.clearColor())
        
        self.center = CGPointMake( self.bounds.width - (self.bounds.width / 2.0), self.bounds.height - (self.bounds.height / 2.0) )
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(bounds.size.width, bounds.size.height),true, 0)
        UIColor.whiteColor().setFill()
        UIRectFill(frame)
        
        for sector in 0..<sectors {
            
            let center = self.center
            
            colorPath.Path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(sector) * angle, endAngle: (CGFloat(sector) + CGFloat(1)) * angle, clockwise: true)
            colorPath.Path.addLineToPoint(center)
            colorPath.Path.closePath()
            
            let color = UIColor(hue: CGFloat(sector)/CGFloat(sectors), saturation: CGFloat(1), brightness: CGFloat(1), alpha: CGFloat(1))
            color.setFill()
            color.setStroke()
        
            colorPath.Path.fill()
            colorPath.Path.stroke()
            colorPath.Color = color

            paths.append(colorPath)
        }
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        imageView = UIImageView (image: image)
        
        self.addSubview(imageView!)
        
        imageView!.layer.cornerRadius = self.frame.width/2
        imageView!.clipsToBounds = true
        
    }
}


extension UIColor {
    
    func rgb() -> [Int]? {//String? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
//            let iAlpha = Int(fAlpha * 255.0)
            let hRed = iRed.hex()
            let hGreen = iGreen.hex()
            let hBlue = iBlue.hex()
            let hexString = "0x\(hRed)\(hGreen)\(hBlue)"//"#\(hRed)\(hGreen)\(hBlue)"
            hexToUIColor(hexString)
            let returnArray: [Int] = [iRed, iGreen,iBlue]//,iAlpha]
            
            
            //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
            //let rgb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
            return returnArray
        } else {
            // Could not extract RGBA components:
            return nil
        } 
    }
}

extension Int {
    func hex() -> String {
        var index = 1
        let hexRef = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"]
        var divself = self
        var hexself: String = ""
        while divself >= 16 {
            //            print(divself)
            divself = divself / 16
            //            print("d:\(divself)")
            let newdigit = divself % 16
            //            print("n:\(newdigit)")
            hexself = "\(hexself)\(hexRef[newdigit])"
            index += 1
        }
        hexself = "\(hexself)\(hexRef[divself])"
        if hexself.characters.count < 2 {
            hexself = "0\(hexself)"
        }
        return hexself
    }
}

func hexToUIColor(hex: String) {
//    var in1 = hex.startIndex.advancedBy(1)
//    var in2 = hex.startIndex.advancedBy(3)
//    let sRed = hex.substringWithRange(Range<String.Index>(start: in1, end: in2))
    let sRed = hex.getSubs(1, end: 3)
    print(sRed)
//    in1 = hex.startIndex.advancedBy(3)
//    in2 = hex.startIndex.advancedBy(5)
//    let sGreen = hex.substringWithRange(Range<String.Index>(start: in1, end: in2))
    let sGreen = hex.getSubs(3, end: 5)
    print(sGreen)
//    in1 = hex.endIndex.advancedBy(-2)
//    in2 = hex.endIndex
//    let sBlue = hex.substringFromIndex(in1)
    let sBlue = hex.getSubs(5, end: 7)
    print(sBlue)
    
//    let hexInd = ["0": 0, "1" :1, "2": 2,"3": 3,"4": 4,"]
}

extension String {
    func getSubs(start: Int, end: Int) {
        var in1 = self.startIndex.advancedBy(start)
        var in2 = self.startIndex.advancedBy(start)
        let sRed = self.substringWithRange(Range<String.Index>(start: in1, end: in2))
    }
}

