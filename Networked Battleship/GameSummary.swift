//
//  GameSummary.swift
//  Battleship
//
//  Created by Adam Rosenberg on 3/31/16.
//  Copyright © 2016 Adam Rosenberg. All rights reserved.
//

import Foundation

class GameSummary{
    
            var id:String
            var name:String
            var status:String
            init(gameID:String, gameName:String, gameStatus:String){
                id = gameID
                name = gameName
                status = gameStatus
            }
}