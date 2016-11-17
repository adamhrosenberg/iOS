//
//  Board.swift
//  Painting
//
//  Created by Adam Rosenberg on 3/8/16.
//  Copyright © 2016 Adam Rosenberg. All rights reserved.
//

import Foundation

class Board{
    var boardArray:[String] = []
    var player:String = ""
    init(PlayerName:String){
//        print("CREATING BOARD FOR \(PlayerName)")
        player = PlayerName
//        populateBoard()
    }
//    func populateBoard(){
////        print("generating board")
//        //fill array
//        for var i = 0 ; i < 100 ; ++i{
//            boardArray.insert("", atIndex: i)
//            
//        }
//        //aircraft carrier - 5, battleship -4, submarine -3, cruiser - 3, destroyer -2
//        //A,B,S,C,D
////        print("PLACING AIRCRAFT CARRIER")
//        placeShip(5,ShipLetter: "A", isVertical: decideIfVertical())
////        print("PLACING BATTLESHIP")
//        placeShip(4,ShipLetter: "B",isVertical: decideIfVertical())
////        print("PLACING SUBMARTINE")
//        placeShip(3, ShipLetter: "S",isVertical: decideIfVertical())
////        print("P2ACING DESTROYER")
//        placeShip(2, ShipLetter: "D",isVertical: decideIfVertical())
////        print("PLACING CRUISER")
//        placeShip(3, ShipLetter: "C",isVertical: decideIfVertical())
//    }

    func placeShip(_ ShipLength: Int, ShipLetter:String, isVertical:Bool){
        var random:Int = 0
        var CurrentShipLength:Int = 0
        var baseMultiplier = 0
        var HaventFoundValidRandom:Bool = true
        if(isVertical){
            baseMultiplier = 10
        }
        else{
            baseMultiplier = 1
        }
       
        var temp:Int = 0
        var i:Int = 0
        random = randomInt(0, max: 100)
//        print("original random int: \(random)")
        while(HaventFoundValidRandom){
            if(!isVertical){
                if(random%10<ShipLength){
//                    print("random is \(random)")
                    random = randomInt(0, max: 100)
//                    print("...changing random to... \(random)")
                }
            }
//            if(isVertical){
//                if(boardArray[random]==""){
//                }else{
//                    random = randomInt(0, max:100)
//                }
//            }
            if(random-(baseMultiplier*temp)>=0 && random-(baseMultiplier*temp)<100){
                if(boardArray[random-(baseMultiplier*temp)] == ""){
                    temp += 1
                }
            }
            if(i>ShipLength+1){
                random = randomInt(0, max: 100)
//                print("changing random to... \(random)")
                temp = 0
                i = 0
            }
            if(temp == ShipLength+1){
                HaventFoundValidRandom = false
            }
            i += 1
        }
        
//        print("placing \(ShipLetter) at: \(random)")
        boardArray[random]=ShipLetter
        CurrentShipLength += 1
        temp = 1
        while(temp<6 && CurrentShipLength<ShipLength){
            if(random-(baseMultiplier*temp)>=0 && (random-(baseMultiplier*temp))<100 && CurrentShipLength < ShipLength){
                boardArray[random-(baseMultiplier*temp)]=ShipLetter
//                print("placing \(ShipLetter) at: \(random-(baseMultiplier*temp))")
                CurrentShipLength += 1
            }
            temp += 1
        }
    }
    
    
    func decideIfVertical()->Bool {
        let tempRandom = randomInt(0, max:100)
        return tempRandom<50
    }
    func randomInt(_ min: Int, max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    
}
