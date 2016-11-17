//
//  Painting.swift
//  Things
//
//  Created by Adam Rosenberg on 2/20/16.
//  Copyright © 2016 Adam Rosenberg. All rights reserved.
//

import Foundation



class Painting {

    var strokes: [Stroke] = []
    var aspectRatio:Double = 1.0
    var index:Int = 0
    init(_strokes:[Stroke]){
        strokes = _strokes
    }
    init()
    {
        
    }

}