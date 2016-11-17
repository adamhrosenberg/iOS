//
//  MainMenuView.swift
//  Battleship
//
//  Created by Adam Rosenberg on 3/25/16.
//  Copyright © 2016 Adam Rosenberg. All rights reserved.
//

import UIKit

protocol MainMenuDelegate: class{
    func pushView(_ type:Int)
}

class MainMenuView: UIView{
    
    let newGameButton:UIButton = UIButton()
    let loadGameButton:UIButton = UIButton()
    let clickMe:UIButton = UIButton()
    
    weak var mainMenuDelegate:MainMenuDelegate? = nil
    override init(frame:CGRect){
        super.init(frame:frame)//add subviews
        go()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func go(){
        newGameButton.setTitle("New Game", for: UIControlState())
        newGameButton.setTitleColor(UIColor.blue, for: UIControlState())
        newGameButton.frame = CGRect(x: 100, y: 130, width: 150, height: 35) // X, Y, width, height
        newGameButton.layer.borderWidth = 1
        newGameButton.layer.borderColor = UIColor.black.cgColor
        newGameButton.addTarget(self, action: #selector(MainMenuView.newGamePressed(_:)), for: UIControlEvents.touchUpInside)

        addSubview(newGameButton)
        
        loadGameButton.setTitle("Online Games", for: UIControlState())
        loadGameButton.setTitleColor(UIColor.blue, for: UIControlState())
        loadGameButton.layer.borderWidth = 1
        loadGameButton.layer.borderColor = UIColor.black.cgColor
        loadGameButton.frame = CGRect(x: 100, y: 200, width: 150, height: 35) // X, Y, width, height
        loadGameButton.addTarget(self, action: #selector(MainMenuView.onlineGamesPressed(_:)), for: UIControlEvents.touchUpInside)

        addSubview(loadGameButton)
        
        clickMe.setTitle("TA CLICK ME", for: UIControlState())
        clickMe.setTitleColor(UIColor.blue, for: UIControlState())
        clickMe.layer.borderWidth = 1
        clickMe.layer.borderColor = UIColor.black.cgColor
        clickMe.frame = CGRect(x: 100, y: 300, width: 150, height: 35) // X, Y, width, height
        clickMe.addTarget(self, action: #selector(MainMenuView.clickMePressed(_:)), for: UIControlEvents.touchUpInside)
        
        addSubview(clickMe)
        
    }
    func newGamePressed(_ sender: UIButton){
        //send message to main menu view controller to push the new game view controller on navigationg stack...fame for load games..
        mainMenuDelegate?.pushView(1)
//        print("new game button pressed")
    }
    func onlineGamesPressed(_ sender: UIButton){
        mainMenuDelegate?.pushView(2)
//        print("load game button pressed")
        
    }
    func clickMePressed(_ sender: UIButton){
        mainMenuDelegate?.pushView(3)
    }
}
