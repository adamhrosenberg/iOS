//
//  OnlineGamesViewController.swift
//  Things
//
//  Created by Adam Rosenberg on 2/20/16.
//  Copyright © 2016 Adam Rosenberg. All rights reserved.
//

import UIKit

class OnlineGamesViewController: UIViewController, OnlineGamesViewDelegate{
    
    
    var inputTextField: UITextField?
    var gameIDController:String = ""
    
    //MARK:UIViewController Methods
    override func loadView() {
        
        let onlineGamesView:OnlineGamesView = OnlineGamesView()
        onlineGamesView.backgroundColor = UIColor.white
        onlineGamesView.onlineGamesViewDelegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(OnlineGamesViewController.addTapped))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Main Menu", style: .plain, target: self, action: #selector(OnlineGamesViewController.backTapped))
        
        navigationItem.backBarButtonItem?.title = "Menu"
        view = onlineGamesView
        
    }
    
    func addTapped(){
        //get pname and gnamt..set to bshpi network.
        let createGameViewController: CreateGameViewController = CreateGameViewController()
        navigationController?.pushViewController(createGameViewController, animated: true)
        
    }
    
    
    func backTapped(){
        navigationController?.popToRootViewController(animated: true)
    }
    func selectedGame(_ gameID: String) {
        
        gameIDController = gameID
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Enter name:", message: "", preferredStyle: .alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelAction)
        
        let nextAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
            self.okAction()
        }
        actionSheetController.addAction(nextAction)
        actionSheetController.addTextField { textField -> Void in
            self.inputTextField = textField
        }
        
        //Present the AlertController
        self.present(actionSheetController, animated: true, completion: nil)
        
        
    }
    func okAction(){
        if(inputTextField!.text != ""){
            
            let onlineGameViewController: OnlineGameViewController = OnlineGameViewController()
            let pName:String! = inputTextField!.text
            
            print("in ok action \(gameIDController) and \(pName)")
            onlineGameViewController.gameID = gameIDController
            onlineGameViewController.playerName = pName
            onlineGameViewController.action = "Join"
            navigationController?.pushViewController(onlineGameViewController, animated: false)
            
        }
        
        
    }
    
}
