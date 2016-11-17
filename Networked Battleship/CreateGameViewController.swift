//
//  MainMenuViewController.swift
//  Things
//
//  Created by Adam Rosenberg on 2/20/16.
//  Copyright © 2016 Adam Rosenberg. All rights reserved.
//

import UIKit

class CreateGameViewController: UIViewController, CreateGameDelegate{
    
    var network:BattleshipNetwork!
    var gameID:String = ""
    var playerID:String = ""
    var flag:Bool = true
    
    //MARK:UIViewController Methods
    override func loadView() {
        
        let createGameView:CreateGameView = CreateGameView()
        createGameView.backgroundColor = UIColor.white
        createGameView.createGameDelegate = self
        view = createGameView
        
    }
    
    func createGame(_ response: NSArray){
        print(response)
        
        var tempArr = response as! [String]
        //gameID = response.valueForKey("gameId") as! String
        gameID = tempArr[0]
        playerID = tempArr[1]
        
        print("game id : \(gameID)  player id:   \(playerID)")
        flag = false
    }
    
    func pushView(_ gameNameLocal:String, playerNameLocal:String) {
        network = BattleshipNetwork()
        network.gameName = gameNameLocal
        network.playerName = playerNameLocal
        network.getCreateGamePost{
            (response) in
            self.createGame(response)
        }
        
//        print(post)
        while(flag){
        }
        let gameViewController: OnlineGameViewController = OnlineGameViewController()
        gameViewController.gameID = self.gameID
        gameViewController.playerID = self.playerID
        gameViewController.action = "New"
        navigationController?.pushViewController(gameViewController, animated: true)
    }
    
}
