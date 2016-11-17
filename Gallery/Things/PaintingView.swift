//
//  PaintingView.swift
//  Painting
//
//  Created by Adam Rosenberg on 2/22/16.
//  Copyright © 2016 Adam Rosenberg. All rights reserved.
//

import UIKit

protocol PaintingDelegate:class{
    func updatePainting(_ painting:Painting, index:Int)
}

class PaintingView:UIView{
    
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
    weak var delegate: PaintingDelegate? = nil
    
    //MARK: init
    override init(frame:CGRect){
        super.init(frame:frame)//add subviews
        self.backgroundColor = UIColor.white
        setNeedsDisplay()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: touch targets
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastPoint = touches.first?.location(in: self)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let newPoint = touches.first?.location(in: self)
        //TODO: convert the x and y into screen independent points
//        x/frame.width y/frame.height
        let temp:Stroke = Stroke(start: lastPoint, end: newPoint!)
        temp.color.r = redColor
        temp.color.g = greenColor
        temp.color.b = blueColor
        temp.lineWidth = lineWidth
        temp.lineCap = lineCap
        temp.lineJoin = lineJoin
        painting.strokes.append(temp)
        lastPoint = newPoint
        self.setNeedsDisplay()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.updatePainting(painting, index: painting.index)
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
            context?.move(to: CGPoint(x: stroke.start.x, y: stroke.start.y))
            context?.addLine(to: CGPoint(x: stroke.end.x, y: stroke.end.y))
            
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
            
            context?.setLineWidth(stroke.lineWidth)
            context?.setStrokeColor(red: stroke.color.r, green: stroke.color.g, blue: stroke.color.b, alpha: 1)
            context?.strokePath()
        }
    }
}
