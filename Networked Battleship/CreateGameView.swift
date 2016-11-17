//
//  MainMenuView.swift
//  Battleship
//
//  Created by Adam Rosenberg on 3/25/16.
//  Copyright © 2016 Adam Rosenberg. All rights reserved.
//

import UIKit

protocol CreateGameDelegate: class{
    func pushView(_ gameNameLocal:String, playerNameLocal:String)
}

class CreateGameView: UIView{
    
    let newGameButton:UIButton = UIButton()
    let gameNameLabel:UILabel = UILabel(frame: CGRect(x: 0, y: 130, width: 200, height: 21))
    let nameLabel:UILabel = UILabel(frame: CGRect(x: 0, y: 180, width: 200, height: 21))
    let gameNameTextInput:UITextField = UITextField(frame: CGRect(x: 100.0, y: 130.0, width: 100.0, height: 33.0))
    let playerNameTextInput:UITextField = UITextField(frame: CGRect(x: 100.0, y: 180.0, width: 100.0, height: 33.0))
    var post:String = ""
    
    weak var createGameDelegate:CreateGameDelegate? = nil
    override init(frame:CGRect){
        super.init(frame:frame)//add subviews
        go()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func go(){
        
        
        gameNameTextInput.backgroundColor = UIColor.white
        gameNameTextInput.borderStyle = UITextBorderStyle.line
        addSubview(gameNameTextInput)
        
        playerNameTextInput.backgroundColor = UIColor.white
        playerNameTextInput.borderStyle = UITextBorderStyle.line
        addSubview(playerNameTextInput)
        
    
//        gameNameLabel.center = CGPointMake(160, 284)
        gameNameLabel.textAlignment = NSTextAlignment.left
        gameNameLabel.text = "Game Name: "
        addSubview(gameNameLabel)
        
        nameLabel.textAlignment = NSTextAlignment.left
        nameLabel.text = "Your Name: "
        addSubview(nameLabel)
        
        newGameButton.setTitle("Create Game", for: UIControlState())
        newGameButton.setTitleColor(UIColor.blue, for: UIControlState())
        newGameButton.frame = CGRect(x: 80, y: 250, width: 200, height: 35) // X, Y, width, height
        newGameButton.layer.borderWidth = 1
        newGameButton.layer.borderColor = UIColor.black.cgColor
        newGameButton.addTarget(self, action: #selector(CreateGameView.newGamePressed(_:)), for: UIControlEvents.touchUpInside)
        addSubview(newGameButton)
        
    }
    func newGamePressed(_ sender: UIButton){
        //cant have any symbols in the text...
        //TODO::
        if(gameNameTextInput.text != "" && playerNameTextInput.text != ""){
            post = "gameName=\(gameNameTextInput.text)&playerName=\(playerNameTextInput.text)"
            let gameName:String! = gameNameTextInput.text
            let playerName2:String! = playerNameTextInput.text
            //pass game and p name
            createGameDelegate?.pushView(gameName, playerNameLocal: playerName2)
        }
    }

}
