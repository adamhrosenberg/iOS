//
//  GameViewController.swift
//  Things
//
//  Created by Adam Rosenberg on 2/20/16.
//  Copyright © 2016 Adam Rosenberg. All rights reserved.
//

import UIKit


class GameViewController: UIViewController, GameViewDelegate{
    var board:Board = Board(PlayerName: "player 1")
    var board2:Board = Board(PlayerName: "player 2")
    var P1MoveBoard:[String]=[]
    var P2MoveBoard: [String]=[]
    var CellString:String = ""
    var HitList: [String] = []
    var HitList2: [String] = []
    var HitCount:Int = 0
    var HitCount2:Int = 0
    var gameStarting:Bool = true
    var isPlayer1Turn:Bool = true
    
    //dont let user press next button until he or she makes a move

    let gameView:GameView = GameView()
    //MARK:UIViewController Methods
    override func loadView() {
        
        gameView.backgroundColor = UIColor.white
        gameView.gameViewDelegate = self
        view = gameView
        
    }
    //after load view to customize view.
    override func viewDidLoad() {
        navigationItem.title = "BATTLESHIP"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(GameViewController.startGame))
        for i in 0  ..< 100  += 1{
            P1MoveBoard.append("")
            P2MoveBoard.append("")
        }
        makeGameRequest()
        
    }
    
    func makeGameRequest(){
       
        
    }
    
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
        if(isPlayer1Turn){
            navigationItem.title = "P1 Turn"
            for i in 0  ..< 100  += 1{
                let cellLabel:String = board.boardArray[i] //bottom board..
                //                let cellLabel2:String = board2.boardArray[i]//top board.. show p2 board
                let cellLabel3:String = P1MoveBoard[i]
                let cellLabel4:String = P2MoveBoard[i]
                let index:IndexPath = IndexPath(item: i, section: 0)
                gameView.sendingCellLabel(cellLabel, index: index, isTopBoard: false)
                //                gameView.sendingCellLabel(cellLabel2, index: index, isTopBoard: true)
                gameView.sendingCellLabel(cellLabel3, index: index, isTopBoard: true)
                gameView.sendingCellLabel(cellLabel4, index: index, isTopBoard: false)
            }
        }else{
            navigationItem.title = "P2 Turn"
            for i in 0  ..< 100  += 1{
                let cellLabel:String = board2.boardArray[i]
                //                let cellLabel2:String = board.boardArray[i]
                let cellLabel3:String = P2MoveBoard[i]
                let cellLabel4:String = P1MoveBoard[i]
                let index:IndexPath = IndexPath(item: i, section: 0)
                gameView.sendingCellLabel(cellLabel, index: index, isTopBoard: false)
                //                gameView.sendingCellLabel(cellLabel2, index: index, isTopBoard: true)
                gameView.sendingCellLabel(cellLabel3, index: index, isTopBoard: true)
                gameView.sendingCellLabel(cellLabel4, index: index, isTopBoard: false)
            }
        }
    }
    func sendIndex(_ index:IndexPath, isTopBoard:Bool){
        
        if(!isPlayer1Turn){
            CellString = board.boardArray[index.item]
            //            P2MoveBoard[index.item] = "X"
        }else{
            CellString = board2.boardArray[index.item]
            P1MoveBoard[index.item]="X"
        }
        
        if(CellString == "A" || CellString == "B" || CellString=="S" || CellString == "C" || CellString == "D"){
            //            print("player hit")
            //need to manipulate the model..then send that model here.
            gameView.sendingCellLabel("X", index: index, isTopBoard: isTopBoard)
            if(isPlayer1Turn){
                P1MoveBoard[index.item] = "X"
                HitCount += 1
                HitList.append(CellString)
            }else{
                P2MoveBoard[index.item] = "X"
                HitCount2 += 1
                HitList2.append(CellString)
            }
        }else{
            //            print("player miss")
            if(isPlayer1Turn){
                P1MoveBoard[index.item]="~"
            }else{
                P2MoveBoard[index.item]="~"
            }
            gameView.sendingCellLabel("~", index: index, isTopBoard: isTopBoard)
        }
        //aircraft carrier - 5, battleship -4, submarine -3, cruiser - 3, destroyer -2
        //A,B,S,C,D
        var AirCraftHitCount:Int = 0
        var SubHitCount:Int = 0
        var BattleshipHitCount:Int = 0
        var CruiserHitCount:Int = 0
        var DestroyHitCount:Int = 0
        //may need to be if ifp1turn
        if(isPlayer1Turn){
            for i in 0  ..< HitList.count  += 1{
                if(HitList[i]=="A"){
                    AirCraftHitCount += 1
                }
                if(HitList[i]=="B"){
                    BattleshipHitCount += 1
                }
                if(HitList[i]=="S"){
                    SubHitCount += 1
                }
                if(HitList[i]=="C"){
                    CruiserHitCount += 1
                }
                if(HitList[i]=="D"){
                    DestroyHitCount += 1
                }
            }
        }else{
            for i in 0  ..< HitList2.count  += 1{
                if(HitList2[i]=="A"){
                    AirCraftHitCount += 1
                }
                if(HitList2[i]=="B"){
                    BattleshipHitCount += 1
                }
                if(HitList2[i]=="S"){
                    SubHitCount += 1
                }
                if(HitList2[i]=="C"){
                    CruiserHitCount += 1
                }
                if(HitList2[i]=="D"){
                    DestroyHitCount += 1
                }
            }
            
        }
        if(HitCount==17){
            print("P2 WINS")
            gameOverAlert()
        }
        if(HitCount2==17){
            print("P1 WINS")
            gameOverAlert()
        }
        if(AirCraftHitCount==5){
            sendAlert("Air Carrier", shipLetter: "A", isPlayer1: isPlayer1Turn)
        }
        if(BattleshipHitCount==4){
            sendAlert("Battleship", shipLetter: "B", isPlayer1: isPlayer1Turn)
        }
        if(SubHitCount==3){
            sendAlert("Submarine", shipLetter: "S", isPlayer1: isPlayer1Turn)
        }
        if(CruiserHitCount==3){
            sendAlert("Cruiser", shipLetter: "C", isPlayer1: isPlayer1Turn)
        }
        if(DestroyHitCount==2){
            sendAlert("Destroyer", shipLetter: "D", isPlayer1: isPlayer1Turn)
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
