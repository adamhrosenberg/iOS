//
//  PaintingView.swift
//  Painting
//
//  Created by Adam Rosenberg on 2/22/16.
//  Copyright © 2016 Adam Rosenberg. All rights reserved.
//

import UIKit

class CellView: UICollectionViewCell{
    //uicollectionviewcell is where the subview goes into
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
    var textLabel: UILabel!
    var imageView: UIImageView!

    var paintingView: PaintingShowView?
    
    //MARK: init
    override init(frame:CGRect){
        super.init(frame:frame)//add subviews
        paintingView = PaintingShowView()
        addSubview(paintingView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews()
    {
        paintingView!.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
    }
    
    override func prepareForReuse()
    {
        paintingView?.setPainting(Painting())
    }

    
}