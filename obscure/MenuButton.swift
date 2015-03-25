//
//  MenuButton.swift
//  Obscure
//
//  Created by nick barr on 10/22/14.
//  Copyright (c) 2014 poemsio. All rights reserved.
//

import Foundation
import UIKit

class MenuButton: UIButton {
    override init(frame: CGRect)  {
        super.init(frame: frame)
        
        self.titleLabel!.font = UIFont(name: "ArialRoundedMTBold", size: 18.0)
        self.titleLabel!.textAlignment = .Center
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal | .Highlighted)
        self.setTitleColor(UIColor.blackColor(), forState: .Selected)
        self.setTitleColor(UIColor.blackColor(), forState: .Selected | .Highlighted)
        self.titleLabel!.sizeToFit()
        
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.cornerRadius = 6
        
        
        let bgColor = UIColor(red: 24/255, green: 18/255, blue: 28/255, alpha: 1)
        self.backgroundColor = bgColor
        self.contentVerticalAlignment = .Center
        self.contentHorizontalAlignment = .Center
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}