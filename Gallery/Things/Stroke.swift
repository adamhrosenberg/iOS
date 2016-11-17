//
//  Stroke.swift
//  Things
//
//  Created by Adam Rosenberg on 2/20/16.
//  Copyright © 2016 Adam Rosenberg. All rights reserved.
//

import UIKit

class Stroke{
    
    var color:Color = Color(_r: 0.0, _g: 0.0,_b:0.0)
    var lineWidth: CGFloat = 0.0
    var lineCap: String = ""
    var lineJoin: String = ""
    var start:CGPoint
    var end:CGPoint
    
    init(start _start:CGPoint, end _end:CGPoint){
        start = _start
        end = _end
    }

}
