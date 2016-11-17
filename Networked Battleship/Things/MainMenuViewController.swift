//
//  MainMenuViewController.swift
//  Things
//
//  Created by Adam Rosenberg on 2/20/16.
//  Copyright © 2016 Adam Rosenberg. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController, MainMenuDelegate{

    
    //MARK:UIViewController Methods
    override func loadView() {
        
        let mainView:MainMenuView = MainMenuView()
        mainView.backgroundColor = UIColor.white
        mainView.mainMenuDelegate = self
        view = mainView
        
    }
    
    func pushView(_ type:Int) {
        if(type == 1){
            let gameViewController: GameViewController = GameViewController()
            navigationController?.pushViewController(gameViewController, animated: true)
        }
        if(type == 2){
            let onlineGamesViewController:OnlineGamesViewController = OnlineGamesViewController()
            navigationController?.pushViewController(onlineGamesViewController, animated: true)
        }
        if(type == 3){
            let alert = UIAlertController(title: "This Project", message: "I was not able to get this project fully working. The MVC from my last project was pretty clunky and with just a lack of time with other classes on my end I wasn't able to make the needed changes to make this functional. I understand I will take a lower grade for this assignment. I was able to poll the server for a list of games, and include the games in the waiting state in 'Online Games'. From there you can successfully create a game with a game name and player name, but the next screen is not the actual game screen. If you click a game to join you join the game, and the board shows in the game view however the game is not playable from there. Since I cannot continue a game in progress really, it's pretty non working. However, when you click a cell when you join a game it does poll the server for the response however it's not your turn so you get a 400 error. The network code is in the battleship network class. Implementing the methods there happen in a variety of classes such as OnlineGameViewController, OneGamesViewController, and CreateGameViewController. I attempted to do as much as I could. I'm hoping to make up for this lower grade with my final project. Thank you!! ", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: ":(", style: UIAlertActionStyle.default) {
                UIAlertAction in             }
            alert.addAction(okAction)
            self.present(alert, animated:true, completion: nil)
        }
    }

}



/*******
let alert = UIAlertController(title: "Load games..", message: "I was not able to get persistence to work. I tried saving everything as a plist but was never able to generate one. I wasn't able to work at all over spring break and used my late days to get the game functional so I understand I will loose points for this. I will be meeting up with the TA this week to fix it for future assignments. I have 2 boards (arrays) and 2 move arrays to store with persistence. I would have saved every turn and loading them would have been as easy as assigning the models to the loaded ones from the plist. Sadly, I just couldn't get it to work! Thanks for grading :D", preferredStyle: UIAlertControllerStyle.Alert)
let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
UIAlertAction in             }
alert.addAction(okAction)
self.presentViewController(alert, animated:true, completion: nil)
*******/
