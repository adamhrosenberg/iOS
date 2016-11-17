//
//  MainMenuView.swift
//  Battleship
//
//  Created by Adam Rosenberg on 3/25/16.
//  Copyright © 2016 Adam Rosenberg. All rights reserved.
//

import UIKit

protocol OnlineGamesViewDelegate: class{
    func selectedGame(_ gameID:String)
}

class OnlineGamesView: UIView, UITableViewDataSource, UITableViewDelegate{
    
    //Member fields
    weak var onlineGamesViewDelegate:OnlineGamesViewDelegate? = nil
    var onlineGamesTableView:UITableView = UITableView(frame: UIScreen.main.bounds, style: UITableViewStyle.plain)
    var gameNameList:NSArray = NSArray()
    var arrGamesNameList = [GameSummary]()
    var gameList:GameList = GameList()
    var network:BattleshipNetwork!
    
    override init(frame:CGRect){
        
        super.init(frame:frame)//add subviews
        go()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func go(){
        onlineGamesTableView.delegate = self
        onlineGamesTableView.dataSource = self
        onlineGamesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        addSubview(self.onlineGamesTableView)
        
        network = BattleshipNetwork()
        network.getGameListPost{
            (response) in
            self.loadGames(response)
        }
        
    }
    
    //make request//
    func loadGames(_ games: NSArray){

        for i in 0  ..< games.count  += 1{

            if ((games[i] as AnyObject).value(forKey: "status") as! String! == "WAITING"){
                let name = (games[i] as AnyObject).value(forKey: "name")
                let id = (games[i] as AnyObject).value(forKey: "id")
                let status = (games[i] as AnyObject).value(forKey: "status")
                
                let summary:GameSummary = GameSummary(gameID: id as! String, gameName: name as! String, gameStatus: status as! String)
                arrGamesNameList.append(summary)
            }
        
        }
        DispatchQueue.main.async {
            self.onlineGamesTableView.reloadData()
        }
    }
    
    //table stuff
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrGamesNameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        cell.textLabel!.text = "NAME: \(arrGamesNameList[indexPath.row].name)  STATUS: \(arrGamesNameList[indexPath.row].status)"
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if(arrGamesNameList[indexPath.row].status == "WAITING"){
            print("selected :  \(arrGamesNameList[indexPath.row].id)")
            onlineGamesViewDelegate?.selectedGame(arrGamesNameList[indexPath.row].id )

        }
        else{
            print("bad")
        }
    }
    
    
    
    
}
