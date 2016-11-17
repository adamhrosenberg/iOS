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
    weak var mainMenuDelegate:MainMenuDelegate? = nil
    override init(frame:CGRect){
        super.init(frame:frame)//add subviews
        go()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func go(){
        print("adding button")
        newGameButton.setTitle("New Game", for: UIControlState())
        newGameButton.setTitleColor(UIColor.blue, for: UIControlState())
        newGameButton.frame = CGRect(x: 100, y: 130, width: 150, height: 35) // X, Y, width, height
        newGameButton.layer.borderWidth = 1
        newGameButton.layer.borderColor = UIColor.black.cgColor
        newGameButton.addTarget(self, action: #selector(MainMenuView.newGamePressed(_:)), for: UIControlEvents.touchUpInside)

        addSubview(newGameButton)
        
        loadGameButton.setTitle("Load Game", for: UIControlState())
        loadGameButton.setTitleColor(UIColor.blue, for: UIControlState())
        loadGameButton.layer.borderWidth = 1
        loadGameButton.layer.borderColor = UIColor.black.cgColor
        loadGameButton.frame = CGRect(x: 100, y: 200, width: 150, height: 35) // X, Y, width, height
        loadGameButton.addTarget(self, action: #selector(MainMenuView.loadGamePressed(_:)), for: UIControlEvents.touchUpInside)

        addSubview(loadGameButton)
        
    }
    func newGamePressed(_ sender: UIButton){
        //send message to main menu view controller to push the new game view controller on navigationg stack...fame for load games..
        mainMenuDelegate?.pushView(1)
//        print("new game button pressed")
    }
    func loadGamePressed(_ sender: UIButton){
        mainMenuDelegate?.pushView(2)
//        print("load game button pressed")
        
    }
}
