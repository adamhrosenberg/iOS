//
//  BattleshipNetwork.swift
//  Battleship
//
//  Created by Adam Rosenberg on 3/31/16.
//  Copyright © 2016 Adam Rosenberg. All rights reserved.
//

import Foundation

protocol NetworkDelegate:class{
    func sendGameList(_ gameList:GameList)
}

class BattleshipNetwork{
    
    var gameNameList:NSArray = NSArray()
    var gameList:GameList = GameList()
    weak var networkDelegate:NetworkDelegate? = nil
    var gameName:String = "Default"
    var playerName:String = "Player1"
    var playerID:String = ""
    var gameID:String = ""
    var xPos:Int = 0
    var yPos:Int = 0
    
    func getGameListPost(_ callback:@escaping (NSArray)->()) {
        request("http://battleship.pixio.com/api/games",callback: callback)
    }
    
    func getRequestToJoinPost(_ callback:@escaping (String)->()){
        //send player name get player id.
        // POST /api/games/:id/join
        let post:String = "playerName=\(playerName)"
        requestMutableToJoin("http://battleship.pixio.com/api/games/\(gameID)/join", stringPost: post, callback: callback)
    }
    
    func getPlayerTurn(_ callback:@escaping (NSDictionary)->()){
        //api/games/:id/status
        //send player ID. get back isYourTurn and winner
        let post:String = "playerId=\(playerID)"
        print(gameID)
        requestMutablePlayerTurn("http://battleship.pixio.com/api/games/\(gameID)/status", stringPost: post, callback: callback)
    }
    
    func getSendIndexPost(_ callback:@escaping (NSDictionary)->()){
        /// POST /api/games/:id/guess
        // send playerId, xPos, and yPos..receive "hit" to bool and "shipSunk" to Int. 
        let post:String = "playerId=\(playerID)&xPos=\(xPos)&yPos=\(yPos)"
        print(gameID)
        print(playerID, xPos, yPos)
        requestMutableIndex("http://battleship.pixio.com/api/games/\(gameID)/guess", stringPost: post, callback: callback)

    }
    
    func getBoardForPlayerID(_ callback: @escaping (NSDictionary)->()){
        //send player id get back both boards.
        // POST /api/games/:id/board
//        print("hello. printing player and game id \(playerID) , \(gameID)")
        let post:String = "playerId=\(playerID)"
        requestMutableForBoard("http://battleship.pixio.com/api/games/\(gameID)/board", stringPost: post, callback: callback)
        
    }
    
    func getCreateGamePost(_ callback:@escaping (NSArray)->()){
        let post:String = "gameName=\(gameName)&playerName=\(playerName)"
        requestMutable("http://battleship.pixio.com/api/games", stringPost: post, callback: callback)
    }
    
    
    
    
    func requestMutableIndex(_ url:String, stringPost:String, callback:@escaping (NSDictionary)->()){
        //CREATE GAME CODE
        let gameCreateURL:URL = URL(string: url)!
        let gameCreateRequest:NSMutableURLRequest = NSMutableURLRequest(url: gameCreateURL)
        gameCreateRequest.httpMethod = "POST"
        let dataPost = stringPost.data(using: String.Encoding.utf8)
        
        gameCreateRequest.timeoutInterval = 60
        gameCreateRequest.httpBody=dataPost
        gameCreateRequest.httpShouldHandleCookies=false
        
        NSURLConnection.sendAsynchronousRequest(gameCreateRequest as URLRequest, queue: OperationQueue(), completionHandler: {(response, data, error) in
            if data == nil{
                print("nil data")
            }
            guard let httpResponse = response as? HTTPURLResponse else{
                print("negative")
                return
            }
            if httpResponse.statusCode < 200{
                print("error system with UI..status code: \(httpResponse.statusCode)")
                return
            }
            print("HttpResponse.statusCode.. \(httpResponse.statusCode)")
            let response = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions())
            callback(response as! NSDictionary)
            //response.valueForKey("playerId") //gameId..example...28a9e0e3-4419-46cc-b698-759e665c1cef
        })
        
    }

    
    
    func requestMutablePlayerTurn(_ url:String, stringPost:String, callback:@escaping (NSDictionary)->()){
        //CREATE GAME CODE
        let gameCreateURL:URL = URL(string: url)!
        let gameCreateRequest:NSMutableURLRequest = NSMutableURLRequest(url: gameCreateURL)
        gameCreateRequest.httpMethod = "POST"
        let dataPost = stringPost.data(using: String.Encoding.utf8)
        
        gameCreateRequest.timeoutInterval = 60
        gameCreateRequest.httpBody=dataPost
        gameCreateRequest.httpShouldHandleCookies=false
        
        NSURLConnection.sendAsynchronousRequest(gameCreateRequest as URLRequest, queue: OperationQueue(), completionHandler: {(response, data, error) in
            if data == nil{
                print("nil data")
            }
            guard let httpResponse = response as? HTTPURLResponse else{
                print("negative")
                return
            }
            if httpResponse.statusCode < 200{
                print("error system with UI..status code: \(httpResponse.statusCode)")
                return
            }
            print("HttpResponse.statusCode.. \(httpResponse.statusCode)")
            let response = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions())
            callback(response as! NSDictionary)
            //response.valueForKey("playerId") //gameId..example...28a9e0e3-4419-46cc-b698-759e665c1cef
        })
        
    }

    
    
    
    func requestMutableForBoard(_ url:String, stringPost:String, callback:@escaping (NSDictionary)->()){
        //CREATE GAME CODE
        let gameCreateURL:URL = URL(string: url)!
        let gameCreateRequest:NSMutableURLRequest = NSMutableURLRequest(url: gameCreateURL)
        gameCreateRequest.httpMethod = "POST"
        let dataPost = stringPost.data(using: String.Encoding.utf8)
        
        gameCreateRequest.timeoutInterval = 60
        gameCreateRequest.httpBody=dataPost
        gameCreateRequest.httpShouldHandleCookies=false
        
        NSURLConnection.sendAsynchronousRequest(gameCreateRequest as URLRequest, queue: OperationQueue(), completionHandler: {(response, data, error) in
            if data == nil{
                print("nil data")
            }
            guard let httpResponse = response as? HTTPURLResponse else{
                print("negative")
                return
            }
            if httpResponse.statusCode < 200{
                print("error system with UI..status code: \(httpResponse.statusCode)")
                return
            }
            print("HttpResponse.statusCode.. \(httpResponse.statusCode)")
            let response = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions())
            callback(response as! NSDictionary)
            //response.valueForKey("playerId") //gameId..example...28a9e0e3-4419-46cc-b698-759e665c1cef
        })
        
    }
    
    
    
    func requestMutableToJoin(_ url:String, stringPost:String, callback:@escaping (String)->()){
        //CREATE GAME CODE
        let gameCreateURL:URL = URL(string: url)!
        let gameCreateRequest:NSMutableURLRequest = NSMutableURLRequest(url: gameCreateURL)
        gameCreateRequest.httpMethod = "POST"
        let dataPost = stringPost.data(using: String.Encoding.utf8)
        
        gameCreateRequest.timeoutInterval = 60
        gameCreateRequest.httpBody=dataPost
        gameCreateRequest.httpShouldHandleCookies=false
        
        NSURLConnection.sendAsynchronousRequest(gameCreateRequest as URLRequest, queue: OperationQueue(), completionHandler: {(response, data, error) in
            if data == nil{
                print("nil data")
            }
            guard let httpResponse = response as? HTTPURLResponse else{
                print("negative")
                return
            }
            if httpResponse.statusCode < 200{
                print("error system with UI..status code: \(httpResponse.statusCode)")
                return
            }
            print("HttpResponse.statusCode.. \(httpResponse.statusCode)")
            
            let response = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions())
            let pID:String = (response as AnyObject).value(forKey: "playerId") as! String
//            let idArray:[String] = [pID, gID]
            print("breakpoint")
            callback(pID)
            //response.valueForKey("playerId") //gameId..example...28a9e0e3-4419-46cc-b698-759e665c1cef
        })
        
    }

    
    
    
    func request(_ url:String,callback:@escaping (NSArray)->()) {
        let gamesServiceURL:URL = URL(string: url)!
        let gamesListRequest:URLRequest = URLRequest(url: gamesServiceURL)
        NSURLConnection.sendAsynchronousRequest(gamesListRequest, queue: OperationQueue(), completionHandler: {(response, data, error) in
            let games = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions()) as! NSArray
            callback(games)
        })
    }
    
    func requestMutable(_ url:String, stringPost:String, callback:@escaping (NSArray)->()){
        //CREATE GAME CODE
        let gameCreateURL:URL = URL(string: url)!
        let gameCreateRequest:NSMutableURLRequest = NSMutableURLRequest(url: gameCreateURL)
        gameCreateRequest.httpMethod = "POST"
        let dataPost = stringPost.data(using: String.Encoding.utf8)
        
        gameCreateRequest.timeoutInterval = 60
        gameCreateRequest.httpBody=dataPost
        gameCreateRequest.httpShouldHandleCookies=false
        
        NSURLConnection.sendAsynchronousRequest(gameCreateRequest as URLRequest, queue: OperationQueue(), completionHandler: {(response, data, error) in
            if data == nil{
                print("nil data")
            }
            guard let httpResponse = response as? HTTPURLResponse else{
                print("negative")
                return
            }
            if httpResponse.statusCode < 200{
                print("error system with UI..status code: \(httpResponse.statusCode)")
                return
            }
            print("HttpResponse.statusCode.. \(httpResponse.statusCode)")
            
            let response = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions())
            let pID:String = (response as AnyObject).value(forKey: "playerId") as! String
            let gID:String = (response as AnyObject).value(forKey: "gameId") as! String
            let idArray:[String] = [pID, gID]
            
            callback(idArray as NSArray)
            //response.valueForKey("playerId") //gameId..example...28a9e0e3-4419-46cc-b698-759e665c1cef
        })

    }
}
