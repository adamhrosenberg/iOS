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
            navigationController?.pushViewController(gameViewController, animated: false)
        }
        if(type == 2){
            let alert = UIAlertController(title: "Load games..", message: "I was not able to get persistence to work. I tried saving everything as a plist but was never able to generate one. I wasn't able to work at all over spring break and used my late days to get the game functional so I understand I will loose points for this. I will be meeting up with the TA this week to fix it for future assignments. I have 2 boards (arrays) and 2 move arrays to store with persistence. I would have saved every turn and loading them would have been as easy as assigning the models to the loaded ones from the plist. Sadly, I just couldn't get it to work! Thanks for grading :D", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in             }
            alert.addAction(okAction)
            self.present(alert, animated:true, completion: nil)

        }
    }

}
