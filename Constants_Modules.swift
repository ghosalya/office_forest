//
//  Constants&Modules.swift
//  Office Forest App
//
//  Created by student on 7/11/16.
//  Copyright © 2016 SUTD-ZJU Collaboration. All rights reserved.
//

import UIKit

class imgButton: UIButton {
    var myImageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        myImageView = UIImageView(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

