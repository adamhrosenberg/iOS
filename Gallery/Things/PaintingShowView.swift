//
//  PaintingView.swift
//  Painting
//
//  Created by Adam Rosenberg on 2/22/16.
//  Copyright © 2016 Adam Rosenberg. All rights reserved.
//

import UIKit

class PaintingShowView:UIView{
    
    //MARK: class variables
    var redColor:CGFloat = 0.5
    var blueColor:CGFloat = 0.5
    var greenColor:CGFloat = 0.5
    var lineWidth:CGFloat = 25.0
    var painting:Painting = Painting()
    var lastPoint:CGPoint!
    var moves = [Int: [Stroke]]()
    var lineCap:String = "round"
    var lineJoin:String = "round"
    var count:Int=0
    
    //MARK: init
    override init(frame:CGRect){
        super.init(frame:frame)//add subviews
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        setNeedsDisplay()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setPainting(_ _painting:Painting){
        painting = _painting;
        setNeedsDisplay()
    }
    
    //MARK: draw Rect
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.beginPath()
        for stroke in painting.strokes{
            //i tried following the TA's advice to store the x and y points divided by frame width and height and multiply it out for the larger drawing but for some reason i never got it to work. This works pretty well in portrait mode - but my app does not have much functionality for landscape anyways.
            context?.move(to: CGPoint(x: stroke.start.x/(4), y: stroke.start.y/(4)))
            context?.addLine(to: CGPoint(x: stroke.end.x/(4), y: stroke.end.y/(4)))
            
            if(stroke.lineCap == "round"){
                context?.setLineCap(.round)
            }
            if(stroke.lineCap == "square"){
                context?.setLineCap(.square)
            }
            if(stroke.lineCap == "butt"){
                context?.setLineCap(.butt)
            }
            
            if(stroke.lineJoin == "round"){
                context?.setLineJoin(.round)
            }
            if(stroke.lineJoin == "bevel"){
                context?.setLineJoin(.bevel)
            }
            if(stroke.lineJoin == "miter"){
                context?.setLineJoin(.miter)
            }
        
            context?.setLineWidth(stroke.lineWidth/3)
            context?.setStrokeColor(red: stroke.color.r, green: stroke.color.g, blue: stroke.color.b, alpha: 1)
            context?.strokePath()
        }
    }
}
