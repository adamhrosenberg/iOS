//
//  Vector.swift
//  Asteroids
//
//  Created by Adam Rosenberg on 4/29/16.
//  Copyright © 2016 Adam Rosenberg. All rights reserved.
//

import Foundation


class Vector{
    var x:Float = 0.0
    var y:Float = 0.0
    
    convenience init(){
        self.init(0.0,0.0)
    }
    
    init(_ px: Float, _ py: Float){
        x = px
        y = py
    }
}

func add(v1:Vector, v2:Vector)->Vector{
    return Vector(v1.x+v2.x, v1.y+v2.y)
}

func sub(v1:Vector, v2:Vector)->Vector{
    return Vector(v2.x-v1.x, v2.y-v1.y)
}

func scalarMultiply(v: Vector, s: Float)->Vector{
    return Vector(v.x*s, v.y*s)
}

func normalize(v: Vector)->Vector{
    //v(x,y) is vn(x/Length(v), y/length(v))
    let temp:Float = v.x*v.x + v.y*v.y
    let length = sqrt(temp)
    return Vector(v.x/(length), v.y/(length))
}