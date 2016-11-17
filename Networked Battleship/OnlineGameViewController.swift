//
//  GameViewController.swift
//  Things
//
//  Created by Adam Rosenberg on 2/20/16.
//  Copyright © 2016 Adam Rosenberg. All rights reserved.
//

import UIKit


class OnlineGameViewController: UIViewController, OnlineGameViewDelegate{
    var board:Board = Board(PlayerName: "player 1")
    var board2:Board = Board(PlayerName: "player 2")
    var P1MoveBoard:[String]=[]
    var P2MoveBoard: [String]=[]
    var P1Board:[String]=[]
    var P2Board: [String]=[]
    
    var CellString:String = ""
    var HitList: [String] = []
    var HitList2: [String] = []
    var HitCount:Int = 0
    var HitCount2:Int = 0
    var gameStarting:Bool = true
    var isPlayer1Turn:Bool = true
    
    var gameID:String = ""
    var playerID:String = ""
    var network:BattleshipNetwork!
    var playerName:String = ""
    var yourTurn:Bool = false
    
    var action:String = ""
    
    
    //dont let user press next button until he or she makes a move
    
    let gameView:OnlineGameView = OnlineGameView()
    //MARK:UIViewController Methods
    override func loadView() {
        print("in online games view cont")
        print(gameID, playerID, playerName)
        gameView.backgroundColor = UIColor.white
        gameView.onlinegameViewDelegate = self
        view = gameView
        
        if(action == "New"){
            
        }else if(action == "Join"){
            makeGameJoinRequest()
        }
        
    }
    
    //after load view to customize view.
    override func viewDidLoad() {
        navigationItem.title = "BATTLESHIP"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(OnlineGameViewController.startGame))
        for i in 0  ..< 100  += 1{
            P1MoveBoard.append("")
            P2MoveBoard.append("")
            P1Board.append("")
            P2Board.append("")
        }
    }
    
    
    /////////////////NETWORK STUFF///////////////////////
    
    func getPlayerID(_ response: String){
        
        //        getPlayerID(response)
        //call get player board for ID in battleship network...get back boards.. display those
        playerID = response
        network = BattleshipNetwork()
        network.playerID = response
        network.gameID = gameID
        network.getPlayerTurn{
            (response) in self.getPlayerTurn(response)
        }
    }
    
    func getPlayerTurn(_ response:NSDictionary){
        //send p id
        print(response)
        yourTurn = response.value(forKey: "isYourTurn") as! Bool
        
        
        network = BattleshipNetwork()
        network.playerID = playerID
        network.gameID = gameID
        network.getBoardForPlayerID{
            (response) in self.getGameBoards(response)
        }
    }
    
    func getGameBoards(_ response: NSDictionary){
        let pBoard = response.value(forKey: "playerBoard")
        print(response.value(forKey: "playerBoard"))
        let oBoard = response.value(forKey: "opponentBoard")
//        if(yourTurn){
//            playerBoard = pBoard as! Dictionary
//            opponentBoard = oBoard as! Dictionary
//        }
        convertData(response)
    }
    
    func getIndexResponse(_ response: NSDictionary){
        print(response)
        print("break")
    }
    
    func convertData(_ response:NSDictionary){
        print(response)

        
        //set player board
        if(!yourTurn){
            for i in 0  ..< 100 {
                
                if ((response.value(forKey: "playerBoard") as AnyObject).value(forKey: "status")?[i]!)! as! String == "SHIP"{
                    P1Board[i] = "S"
                }
                if ((response.value(forKey: "playerBoard") as AnyObject).value(forKey: "status")?[i]!)! as! String == "NONE"{
                    P1Board[i] = ""
                }
                if ((response.value(forKey: "playerBoard") as AnyObject).value(forKey: "status")?[i]!)! as! String == "HIT"{
                    P1Board[i] = "X"
                }
                if ((response.value(forKey: "playerBoard") as AnyObject).value(forKey: "status")?[i]!)! as! String == "MISS"{
                    P1Board[i] = "~"
                }
                
                //opponenet board
                if ((response.value(forKey: "opponentBoard") as AnyObject).value(forKey: "status")?[i]!)! as! String == "SHIP"{
                    P2Board[i] = "S"
                }
                if ((response.value(forKey: "opponentBoard") as AnyObject).value(forKey: "status")?[i]!)! as! String == "NONE"{
                    P2Board[i] = ""
                }
                if ((response.value(forKey: "opponentBoard") as AnyObject).value(forKey: "status")?[i]!)! as! String == "HIT"{
                    P2Board[i] = "X"
                }
                if ((response.value(forKey: "opponentBoard") as AnyObject).value(forKey: "status")?[i]!)! as! String == "MISS"{
                    P2Board[i] = "~"
                }
            }
        }else{
            for i in 0  ..< 100 {
                
                if ((response.value(forKey: "playerBoard") as AnyObject).value(forKey: "status")?[i]!)! as! String == "SHIP"{
                    P2Board[i] = "S"
                }
                if ((response.value(forKey: "playerBoard") as AnyObject).value(forKey: "status")?[i]!)! as! String == "NONE"{
                    P2Board[i] = ""
                }
                if ((response.value(forKey: "playerBoard") as AnyObject).value(forKey: "status")?[i]!)! as! String == "HIT"{
                    P2Board[i] = "X"
                }
                if ((response.value(forKey: "playerBoard") as AnyObject).value(forKey: "status")?[i]!)! as! String == "MISS"{
                    P2Board[i] = "~"
                }
                
                //opponenet board
                if ((response.value(forKey: "opponentBoard") as AnyObject).value(forKey: "status")?[i]!)! as! String == "SHIP"{
                    P1Board[i] = "S"
                }
                if ((response.value(forKey: "opponentBoard") as AnyObject).value(forKey: "status")?[i]!)! as! String == "NONE"{
                    P1Board[i] = ""
                }
                if ((response.value(forKey: "opponentBoard") as AnyObject).value(forKey: "status")?[i]!)! as! String == "HIT"{
                    P1Board[i] = "X"
                }
                if ((response.value(forKey: "opponentBoard") as AnyObject).value(forKey: "status")?[i]!)! as! String == "MISS"{
                    P1Board[i] = "~"
                }
            }
        }
        print(P1Board)
    }
    
    func makeGameJoinRequest(){
        
        network = BattleshipNetwork()
        network.gameID = gameID
        network.playerName = playerName
        network.getRequestToJoinPost{
            (response) in
            self.getPlayerID(response)
        }
        
    }
    
    ///////////////////////////GAME MECHANICS////////////////////////////////////
    
    func startGame(){
        if(gameStarting){
            gameStarting = false
            navigationItem.rightBarButtonItem?.title = "Next"
            navigationItem.title = "Battleship"
            gameView.modifyAllowsSelection(true)
            playerTurn()
        }
        else{
            //next turn clicked..
            gameView.modifyVisibility(false)
            nextTurnAlert()
            //            navigationItem.title = "Battleship"
            gameView.modifyAllowsSelection(true)
            //            playerTurn()
        }
    }
    
    func gameOverAlert(){
        var winner:String = "Player 2"
        if(isPlayer1Turn){
            winner = "Player 1"
        }
        let alert = UIAlertController(title: "Game Over", message: "WINNER: \(winner)", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in self.gameOverOKHandler()
        }
        alert.addAction(okAction)
        self.present(alert, animated:true, completion: nil)
        
    }
    func gameOverOKHandler(){
        navigationController?.popViewController(animated: true)
    }
    func nextTurnAlert(){
        let alert = UIAlertController(title: "Turn Over", message: "Hand the device to the enemy.", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in self.nextTurnOKHandler()
        }
        alert.addAction(okAction)
        self.present(alert, animated:true, completion: nil)
        
    }
    func nextTurnOKHandler(){
        gameView.modifyVisibility(true)
        playerTurn()
    }
    
    
    func playerTurn(){
        //clear both boards..
        for i in 0  ..< 100  += 1{
            let index:IndexPath = IndexPath(item: i, section: 0)
            //game bogs down because we put a clear on each tile...
            gameView.sendingCellLabel("clear", index: index, isTopBoard: false)
            gameView.sendingCellLabel("clear", index: index, isTopBoard: true)
        }
        if(!isPlayer1Turn){
            navigationItem.title = "P1 Turn"
            for i in 0  ..< 100  += 1{
                let cellLabel:String = P2Board[i] //bottom board..
                //                let cellLabel2:String = board2.boardArray[i]//top board.. show p2 board
//                let cellLabel3:String = P1MoveBoard[i]
//                let cellLabel4:String = P2MoveBoard[i]
                let index:IndexPath = IndexPath(item: i, section: 0)
                gameView.sendingCellLabel(cellLabel, index: index, isTopBoard: false)
                //                gameView.sendingCellLabel(cellLabel2, index: index, isTopBoard: true)
//                gameView.sendingCellLabel(cellLabel3, index: index, isTopBoard: true)
//                gameView.sendingCellLabel(cellLabel4, index: index, isTopBoard: false)
            }
        }else{
            navigationItem.title = "P2 Turn"
            for i in 0  ..< 100  += 1{
                let cellLabel:String = P1Board[i]
                //                let cellLabel2:String = board.boardArray[i]
//                let cellLabel3:String = P2MoveBoard[i]
//                let cellLabel4:String = P1MoveBoard[i]
                let index:IndexPath = IndexPath(item: i, section: 0)
                gameView.sendingCellLabel(cellLabel, index: index, isTopBoard: false)
                //                gameView.sendingCellLabel(cellLabel2, index: index, isTopBoard: true)
//                gameView.sendingCellLabel(cellLabel3, index: index, isTopBoard: true)
//                gameView.sendingCellLabel(cellLabel4, index: index, isTopBoard: false)
            }
        }
    }
    func sendIndex(_ index:IndexPath, isTopBoard:Bool){
        
        
            network = BattleshipNetwork()
            network.playerID = playerID
            network.gameID = gameID
            network.xPos = index.row % 10
            network.yPos = index.row / 10
            network.getSendIndexPost{
                (response) in
                self.getIndexResponse(response)
            }
        
        isPlayer1Turn = !isPlayer1Turn
        
    }
    func sendAlert(_ shipName: String, shipLetter:String, isPlayer1:Bool) {
        print("player sunk sip \(shipName)")
        //        navigationItem.title = "Sunk Enemy \(shipName)"
        
        let alert = UIAlertController(title: "SHIP SUNK", message: "You have sunk the enemy \(shipName)", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            print("OK Pressed")
        }
        //        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
        
        if(isPlayer1){
            for i in 0  ..< HitList.count  += 1{
                if(HitList[i]==shipLetter){
                    HitList.remove(at: i)
                }
            }
        }else{
            for i in 0  ..< HitList2.count  += 1{
                if(HitList2[i]==shipLetter){
                    HitList2.remove(at: i)
                }
            }
        }
    }
    
}
