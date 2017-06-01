//
//  UIColor+Extension.swift
//  DYZB
//
//  Created by lhq on 2017/5/19.
//  Copyright © 2017年 LhqHelianthus. All rights reserved.
//

import UIKit

extension UIColor{
    
    convenience init(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) {
      
        self.init(red: r/255.0 , green:g/255.0 , blue: b/255.0 , alpha: a)
    }
}
