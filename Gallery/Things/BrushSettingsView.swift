//
//  BrushSettingsView.swift
//  Painting
//
//  Created by Adam Rosenberg on 2/20/16.
//  Copyright © 2016 Adam Rosenberg. All rights reserved.


//TO USE ERASER:
//tap eraser in settings, and then press back. did not have time to make it fully functional.
//but i wanted to add it just as something extra.
import UIKit

//MARK: Delegate Protocol
protocol BrushDelegate: class{
    func settingsViewUpdate(_ stroke:Stroke)
}


class BrushSettingsView:UIView{
    
    weak var delegate: BrushDelegate? = nil
    
    //MARK: class variables.
    
    //color and width sliders
    fileprivate var _rSlider:UISlider!
    fileprivate var _gSlider:UISlider!
    fileprivate var _bSlider:UISlider!
    fileprivate var _widthSlider:UISlider!
    
    //color variables
    var redColor:CGFloat = 0.5
    var greenColor:CGFloat = 0.5
    var blueColor:CGFloat = 0.5
    
    //linewidth
    fileprivate var lineWidth:CGFloat = 25.0
    
    //line cap and join
    fileprivate var lineCap:String = ""
    fileprivate var lineJoin:String = ""
    
    //eraser button
    fileprivate var eraserButton = UIButton()
    
    //line cap button
    fileprivate var roundButton = UIButton()
    fileprivate var squareButton = UIButton()
    fileprivate var buttButton = UIButton()
    
    //line join button
    fileprivate var bevelButton = UIButton()
    fileprivate var miterButton = UIButton()
    fileprivate var roundJoinButton = UIButton()
    
    //top and bottom labels
    fileprivate var topLabel: UILabel = UILabel()
    fileprivate var bottomLabel: UILabel = UILabel()
    
    //MARK: Constructor
    override init(frame:CGRect){
        
        super.init(frame:frame)//add subviews
        
        //draw RGB sliders and line width sliders + top label
        drawRGBWSliders()
        
        //line cap and joint options + bottom label
        drawCapsJoints()
        
    }
    
    //@drawrect method to overpaint to paint the line and dynamically change it based on paramters
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        //set context on the bounds.
        let context: CGContext? = UIGraphicsGetCurrentContext()
        
        context?.clear(bounds)
        
        //drawing line.
        context?.move(to: CGPoint(x: 20, y: 300)) //lower left corner
        context?.addLine(to: CGPoint(x: 70, y: 380))
        context?.addLine(to: CGPoint(x: 150, y: 350))
        context?.addLine(to: CGPoint(x: 170, y: 300))
        context?.addLine(to: CGPoint(x: 210, y: 378))
        context?.addLine(to: CGPoint(x: 250, y: 400))
        
        //set width
        context?.setLineWidth(lineWidth) //lineWidth
        
        //setting line join
        if(lineJoin == "bevel"){
            context?.setLineJoin(.bevel)
        }
        else if(lineJoin=="miter"){
            context?.setLineJoin(.miter)
        }else if(lineJoin=="round"){
            context?.setLineJoin(.round)
        }
        
        //settings line cap
        if(lineCap == "round"){
            context?.setLineCap(.round)
        }
        else if(lineCap=="square"){
            context?.setLineCap(.square)
        }else if(lineCap=="butt"){
            context?.setLineCap(.butt)
        }
        context?.setStrokeColor(red: redColor, green: greenColor, blue: blueColor, alpha: 1.0)
        context?.drawPath(using: .stroke)
        
    }
    
    //MARK: line cap target functions
    
    //calls RGBSlidersChanged because that's where the delegate is. Instead of re doing part of project 1 this was easier and did keep everything 100% in sync.
    func roundButtonPressed(_ sender: UIButton){
        lineCap = "round"
        RGBSliderChanged()
        setNeedsDisplay()
    }
    func squareButtonPressed(_ sender: UIButton){
        lineCap = "square"
        RGBSliderChanged()
        setNeedsDisplay()
    }
    func buttButtonPressed(_ sender: UIButton){
        lineCap = "butt"
        RGBSliderChanged()
        setNeedsDisplay()
    }
    
    //MARK: eraser target
    func eraserButtonPressed(_ sender: UIButton){
        let stroke:Stroke = Stroke(start: CGPoint(), end:CGPoint())
        let color:Color = Color(_r: 1.0, _g: 1.0, _b: 1.0)
        stroke.color = color
        stroke.lineCap = lineCap
        stroke.lineJoin = lineJoin
        stroke.lineWidth = self.lineWidth
        delegate?.settingsViewUpdate(stroke)
        
    }
    //MARK: line join target functions
    func bevelButtonPressed(_ sender: UIButton){
        lineJoin = "bevel"
        RGBSliderChanged()
        setNeedsDisplay()
    }
    func miterButtonPressed(_ sender: UIButton){
        lineJoin = "miter"
        RGBSliderChanged()
        setNeedsDisplay()
    }
    func roundJoinButtonPressed(_ sender: UIButton){
        lineJoin = "round"
        RGBSliderChanged()
        setNeedsDisplay()
    }
    
    //MARK: draws the RGB and line width sliders
    func drawRGBWSliders(){
        //setting up top label
        topLabel.frame = CGRect(x: 20, y: 25, width: 300, height: 21)
        topLabel.textColor = UIColor.white
        topLabel.text = "Red, green, blue, line width:"
        addSubview(topLabel)
        
        //setting up RGB sliders
        _rSlider = UISlider(frame: CGRect(x: 25,y: 70,width: 50,height: 30))
        _rSlider?.addTarget(self, action: #selector(BrushSettingsView.RGBSliderChanged), for: UIControlEvents.valueChanged)
        _rSlider.value = 0.5
        _rSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        _rSlider.thumbTintColor = UIColor(red: redColor, green: 0.0, blue: 0.0, alpha: 1.0)
        addSubview(_rSlider)
        
        _gSlider = UISlider(frame: CGRect(x: 55,y: 70,width: 50,height: 30))
        _gSlider?.addTarget(self, action: #selector(BrushSettingsView.RGBSliderChanged), for: UIControlEvents.valueChanged)
        _gSlider.thumbTintColor = UIColor(red: 0.0, green: greenColor, blue: 0.0, alpha: 1.0)
        _gSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        _gSlider.value = 0.5
        addSubview(_gSlider)
        
        _bSlider = UISlider(frame: CGRect(x: 85,y: 70,width: 50,height: 30))
        _bSlider?.addTarget(self, action: #selector(BrushSettingsView.RGBSliderChanged), for: UIControlEvents.valueChanged)
        _bSlider.thumbTintColor = UIColor(red: 0.0, green: 0.0, blue: blueColor, alpha: 1.0)
        _bSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        _bSlider.value = 0.5
        addSubview(_bSlider)
        
        //setting up width slider and labels
        _widthSlider = UISlider(frame: CGRect(x: 115,y: 70,width: 50,height: 30))
        _widthSlider.addTarget(self, action: #selector(BrushSettingsView.RGBSliderChanged), for: UIControlEvents.valueChanged)
        _widthSlider?.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        _widthSlider.value = 0.5
        addSubview(_widthSlider)
        
    }
    
    //MARK: draws the caps and joint buttons and bottom label
    func drawCapsJoints(){
        //setting up bottom label
        bottomLabel.frame = CGRect(x: 20, y: 110, width: 300, height: 21)
        bottomLabel.textColor = UIColor.white
        bottomLabel.text = "Line cap and line joint:"
        addSubview(bottomLabel)
        
        //setting up line cap buttons
        roundButton.setTitle("Round", for: UIControlState())
        roundButton.setTitleColor(UIColor.blue, for: UIControlState())
        roundButton.frame = CGRect(x: 4, y: 130, width: 70, height: 35) // X, Y, width, height
        roundButton.addTarget(self, action: #selector(BrushSettingsView.roundButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        addSubview(roundButton)
        
        squareButton.setTitle("Square", for: UIControlState())
        squareButton.setTitleColor(UIColor.blue, for: UIControlState())
        squareButton.frame = CGRect(x: 75, y: 130, width: 70, height: 35) // X, Y, width, height
        squareButton.addTarget(self, action: #selector(BrushSettingsView.squareButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        addSubview(squareButton)
        
        buttButton.setTitle("Butt", for: UIControlState())
        buttButton.setTitleColor(UIColor.blue, for: UIControlState())
        buttButton.frame = CGRect(x: 150, y: 130, width: 70, height: 35) // X, Y, width, height
        buttButton.addTarget(self, action: #selector(BrushSettingsView.buttButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        addSubview(buttButton)
        
        //setting up line joint buttons
        bevelButton.setTitle("Bevel", for: UIControlState())
        bevelButton.setTitleColor(UIColor.blue, for: UIControlState())
        bevelButton.frame = CGRect(x: 0, y: 170, width: 70, height: 35) // X, Y, width, height
        bevelButton.addTarget(self, action: #selector(BrushSettingsView.bevelButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        addSubview(bevelButton)
        
        miterButton.setTitle("Miter", for: UIControlState())
        miterButton.setTitleColor(UIColor.blue, for: UIControlState())
        miterButton.frame = CGRect(x: 75, y: 170, width: 70, height: 35) // X, Y, width, height
        miterButton.addTarget(self, action: #selector(BrushSettingsView.miterButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        addSubview(miterButton)
        
        roundJoinButton.setTitle("Round", for: UIControlState())
        roundJoinButton.setTitleColor(UIColor.blue, for: UIControlState())
        roundJoinButton.frame = CGRect(x: 150, y: 170, width: 70, height: 35) // X, Y, width, height
        roundJoinButton.addTarget(self, action: #selector(BrushSettingsView.roundJoinButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        addSubview(roundJoinButton)
        
        //MARK: draw eraser
        eraserButton.setTitle("Eraser", for: UIControlState())
        eraserButton.setTitleColor(UIColor.white, for: UIControlState())
        eraserButton.frame = CGRect(x: 75, y: 200, width: 70, height: 35) // X, Y, width, height
        eraserButton.addTarget(self, action: #selector(BrushSettingsView.eraserButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        addSubview(eraserButton)
    }
    

    
    //MARK: sliders targets
    func RGBSliderChanged(){
        redColor = CGFloat(_rSlider.value)
        greenColor = CGFloat(_gSlider.value)
        blueColor = CGFloat(_bSlider.value)
        
        
        
        _rSlider.thumbTintColor = UIColor(red: redColor + 0.125, green: 0.0, blue: 0.0, alpha: 1.0)
        _gSlider.thumbTintColor = UIColor(red: 0.0, green: greenColor + 0.125, blue: 0.0, alpha: 1.0)
        _bSlider.thumbTintColor = UIColor(red: 0.0, green: 0.0, blue: blueColor + 0.125, alpha: 1.0)
        
        
        lineWidth = CGFloat(_widthSlider.value)*25+0.125
        
        //MARK: DELEGATE CALL
        let stroke:Stroke = Stroke(start: CGPoint(), end:CGPoint())
        let color:Color = Color(_r: redColor, _g: greenColor, _b: blueColor)
        stroke.color = color
        stroke.lineCap = lineCap
        stroke.lineJoin = lineJoin
        stroke.lineWidth = self.lineWidth
        delegate?.settingsViewUpdate(stroke)
        
        
        setNeedsDisplay()
    }
    
    
    //    override func layoutSubviews() {
    //        super.layoutSubviews()
    //
    //        var r: CGRect = bounds
    //
    //        (self.frame,r) = r.divide(r.height*0.1, fromEdge: .MinYEdge)
    //    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
