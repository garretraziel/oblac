//
//  OblacButton.swift
//  oblac
//
//  Created by Radka Mokrá on 10.12.14.
//  Copyright (c) 2014 GVID. All rights reserved.
//

import UIKit

class OblacButton: UITextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func caretRectForPosition(position: UITextPosition!) -> CGRect {
        return CGRectZero
    }
}
