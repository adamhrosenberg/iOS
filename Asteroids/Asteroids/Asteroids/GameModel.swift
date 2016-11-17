//
//  GameMode.swift
//  Asteroids
//
//  Created by Adam Rosenberg on 5/1/16.
//  Copyright © 2016 Adam Rosenberg. All rights reserved.
//

import GLKit

class GameModel{
    private var animation:Double = 0.0
    
    //game variables
    var level:Int = 1
    var score:Int = 0
    var playerHealth:Int = 100
    var highScoreList:[Int] = []
    var levelKillCount:Int = 0
    
    var userName:String = "Player 1"
    
    //boss stuff
    var bossCount:Int = 0
    var bossHealth = 30
    var bossPhase: Bool = false
    var bossMoveLeft:Bool = false
    var bossMoveRight:Bool = false
    var bossShootTimer: NSTimer!
    
    //moving variables
    var moveLeft:Bool = false
    var moveRight:Bool = false
    var moveUp:Bool = false
    var moveDown:Bool = false
    
    //sprite lists
    var bulletList:[Sprite] = []
    var invaderList:[Sprite] = []
    var spriteList:[Sprite] = []
    var bossBulletList:[Sprite] = []
    
    //sprites
    let playerSprite = Sprite()
    let invaderSprite = Sprite()
    let levelOneBackgroundSprite = Sprite()
    let levelOneBackgroundSprite2 = Sprite()
    let levelOneBackgroundSprite3 = Sprite()
    let levelOneBackgroundSprite4 = Sprite()
    let bossSprite = Sprite()
    let explosionSprite = Sprite()
    let backSprite = Sprite()
    
    //button sprites
    let directionButtons = Sprite()
    let fireButtonSprite = Sprite()
    
    
    //textures
    var backTexture: GLKTextureInfo? = nil
    var background1Texture: GLKTextureInfo? = nil
    var background2Texture: GLKTextureInfo? = nil
    var background3Texture: GLKTextureInfo? = nil
    var shipTexture: GLKTextureInfo? = nil
    var shipLeftTexture: GLKTextureInfo? = nil
    var bossTexture: GLKTextureInfo? = nil
    var shipRightTexture: GLKTextureInfo? = nil
    var bulletTexture: GLKTextureInfo? = nil
    var invaderTexture: GLKTextureInfo? = nil
    var directionalTexture: GLKTextureInfo? = nil
    var directionalUpTexture: GLKTextureInfo? = nil
    var directionalDownTexture: GLKTextureInfo? = nil
    var directionalLeftTexture: GLKTextureInfo? = nil
    var directionalRightTexture: GLKTextureInfo? = nil
    var fireButtonOnTexture: GLKTextureInfo? = nil
    var fireButtonOffTexture: GLKTextureInfo? = nil
    var bossBulletTexture: GLKTextureInfo? = nil
    
    convenience init(){
        self.init(1,0)
    }
    
    init(_ lvl: Int, _ scr: Int){
        //load in from devices info
        level = lvl
        score = scr
        
        //set player stuff
        playerSprite.position.x = 0.0
        playerSprite.position.y = -0.8
        playerSprite.width = 0.2
        playerSprite.height = 0.2
        //        spriteList.append(playerSprite)
        
        //set directional button sprite stuff
        directionButtons.position.x = -0.38
        directionButtons.position.y = -0.8
        directionButtons.width = 0.3
        directionButtons.height = 0.3
        
        //set fire button stuff
        fireButtonSprite.position.x = 0.38
        fireButtonSprite.position.y = -0.8
        fireButtonSprite.width = 0.2
        fireButtonSprite.height = 0.2
        
        //set back button stuff
        backSprite.position.x = 0.45
        backSprite.position.y = 0.75
        backSprite.width = 0.1
        backSprite.height = 0.1
        
        //set background
        
        if(level == 1){
            levelOneBackgroundSprite.position.x = 0.0
            levelOneBackgroundSprite.position.y = 0.0
            levelOneBackgroundSprite.width = 3.37
            levelOneBackgroundSprite.height = 6.28
            
            levelOneBackgroundSprite2.position.x = 0.0
            levelOneBackgroundSprite2.position.y = 6.28
            levelOneBackgroundSprite2.width = 3.37
            levelOneBackgroundSprite2.height = 6.28
            
            levelOneBackgroundSprite3.position.x = 0.0
            levelOneBackgroundSprite3.position.y = 12.56
            levelOneBackgroundSprite3.width = 3.37
            levelOneBackgroundSprite3.height = 6.28
            
            levelOneBackgroundSprite4.position.x = 0.0
            levelOneBackgroundSprite4.position.y = 18.84
            levelOneBackgroundSprite4.width = 3.37
            levelOneBackgroundSprite4.height = 6.28
        }
        

    }
    
    func ExecuteGameLoop(elapsed:NSTimeInterval){
        checkForCollisions()
        if(moveLeft){
            if(playerSprite.position.x > -0.40){
                playerSprite.position.x -= 0.04
                playerSprite.texture = shipLeftTexture!.name
            }
        }else if(moveRight){
            if(playerSprite.position.x < 0.40){
                playerSprite.position.x += 0.04
                playerSprite.texture = shipRightTexture!.name
            }
        }else if(moveUp){
            if(playerSprite.position.y < 0.4){
                playerSprite.texture = shipTexture!.name
                playerSprite.position.y += 0.02
            }
        }
        else if(moveDown){
            if(playerSprite.position.y > -0.85){
                playerSprite.texture = shipTexture!.name
                playerSprite.position.y -= 0.02
            }
        }
        
        //move bullets
        for bullet in bulletList{
            bullet.position.y += 0.03
        }
        animation = elapsed * 0.5
        
        //move invaders
        for invader in invaderList{
            if(invader.invaderMove == "down"){
                invader.position.y -= 0.01
            }
            else{
             invader.position.x += 0.01
            }
        }
        
        if(!bossPhase){
            levelOneBackgroundSprite.position.y -= 0.01
            levelOneBackgroundSprite2.position.y -= 0.01
            levelOneBackgroundSprite3.position.y -= 0.01
            levelOneBackgroundSprite4.position.y -= 0.01
        }else{
            for bull in bossBulletList{
                bull.position.y -= 0.03
            }
            if(bossMoveLeft){
                if(bossSprite.position.x > -0.40){
                    bossSprite.position.x -= 0.01
                }else{
                    bossMoveRight = true
                    bossMoveLeft = false
                }
            }else if(bossSprite.position.x < 0.4){
                bossSprite.position.x += 0.01
            }else{
                bossMoveRight = false
                bossMoveLeft = true
            }
        }
        
        
    }
    
    func spawnBoss(){
        bossShootTimer = NSTimer.scheduledTimerWithTimeInterval(1.3, target: self, selector: #selector(GameModel.bossShoot), userInfo: nil, repeats: true)
        bossCount = 1
        bossSprite.width = 0.2
        bossSprite.height = 0.2
        bossSprite.position.x = 0.0
        bossSprite.position.y = 0.5
        if(drand48() < 0.5){
            bossMoveLeft = true
        }else{
            bossMoveRight = true
        }
    }
    
    @objc func bossShoot(){
        let bullet = Sprite()
        let uuid = NSUUID()
        bullet.id = uuid
        bossBulletList.append(bullet)
        bossBulletList[bossBulletList.count-1].texture = bossBulletTexture!.name
        bossBulletList[bossBulletList.count-1].position.x = bossSprite.position.x
        bossBulletList[bossBulletList.count-1].position.y = bossSprite.position.y - 0.15
        bossBulletList[bossBulletList.count-1].width = 0.05
        bossBulletList[bossBulletList.count-1].height = 0.1
        spriteList.append(bullet)
    }
    
    func spawnEnemy(){
        
        let enemy = Sprite()
        let uuid = NSUUID()
        enemy.id = uuid
        enemy.texture = invaderTexture!.name
        //randomize these
//        print("enemy spawn")
        enemy.position.y = Float(drand48() + 0.2)
        enemy.position.x = -1.1
        enemy.width = 0.15
        enemy.height = 0.15
        invaderList.append(enemy)
        spriteList.append(enemy)
        
        if(drand48() > 0.7){
//            print("spawn to the top")
            let enemy = Sprite()
            enemy.invaderMove = "down"
            let uuid = NSUUID()
            enemy.id = uuid
            enemy.texture = invaderTexture!.name
            //randomize these
            enemy.position.y = 1.2
            enemy.position.x = Float(drand48())
            enemy.width = 0.15
            enemy.height = 0.15
            invaderList.append(enemy)
            spriteList.append(enemy)
            
        }
    }
    
    func fireBullet(){
        let bullet = Sprite()
        let uuid = NSUUID()
        bullet.id = uuid
        bulletList.append(bullet)
        bulletList[bulletList.count-1].texture = bulletTexture!.name
        bulletList[bulletList.count-1].position.x = playerSprite.position.x
        bulletList[bulletList.count-1].position.y = playerSprite.position.y + 0.15
        bulletList[bulletList.count-1].width = 0.05
        bulletList[bulletList.count-1].height = 0.1
        spriteList.append(bullet)
    }
    
    
    func destroySprite(id:NSUUID, array:[Sprite]){
        for var index = bulletList.count - 1; index >= 0; index -= 1 {
            if  (bulletList[index].id == id){
                bulletList.removeAtIndex(index)
            }
        }
        for var index = spriteList.count - 1; index >= 0; index -= 1 {
            if  (spriteList[index].id == id){
                spriteList.removeAtIndex(index)
            }
        }
    }
    
    func playerDied(){
        if(score > highScoreList[4]){
            highScoreList.removeLast()
            highScoreList.append(score)
        }
//        highScoreList.sortInPlace(>)
    }
    
    func checkForCollisions(){
        if(!bossPhase){
            for invader in invaderList{
                for bullet in bulletList{
                    if (invader.position.x < bullet.position.x + bullet.width &&
                        invader.position.x + invader.width > bullet.position.x &&
                        invader.position.y < bullet.position.y + bullet.height &&
                        invader.height + invader.position.y > bullet.position.y) {
                        invader.position.y = -5.0
                        bullet.position.y = -15.0
                        destroySprite(invader.id, array: invaderList)
                        destroySprite(bullet.id, array: bulletList)
                        levelKillCount += 1
                        score += 5
                    }
                }
            }
            for invader in invaderList{
                if (invader.position.x < playerSprite.position.x + playerSprite.width &&
                    invader.position.x + invader.width > playerSprite.position.x &&
                    invader.position.y < playerSprite.position.y + playerSprite.height &&
                    invader.height + invader.position.y > playerSprite.position.y) {
                    invader.position.x = 20.0
                    invader.position.y = -5.0
                    destroySprite(invader.id, array: invaderList)
                    playerHealth -= 5
                    if(playerHealth <= 0){
                        playerDied()
                    }
                }
            }
            
        }else{//if boss phase...
            for invader in invaderList{
                for bullet in bulletList{
                    if (invader.position.x < bullet.position.x + bullet.width &&
                        invader.position.x + invader.width > bullet.position.x &&
                        invader.position.y < bullet.position.y + bullet.height &&
                        invader.height + invader.position.y > bullet.position.y) {
                        invader.position.y = -5.0
                        bullet.position.y = -15.0
                        destroySprite(invader.id, array: invaderList)
                        destroySprite(bullet.id, array: bulletList)
                        levelKillCount += 1
                        score += 5
                    }
                }
            }
            for invader in invaderList{
                if (invader.position.x < playerSprite.position.x + playerSprite.width &&
                    invader.position.x + invader.width > playerSprite.position.x &&
                    invader.position.y < playerSprite.position.y + playerSprite.height &&
                    invader.height + invader.position.y > playerSprite.position.y) {
                    invader.position.x = 20.0
                    invader.position.y = -5.0
                    destroySprite(invader.id, array: invaderList)
                    playerHealth -= 5
                    if(playerHealth <= 0){
                        
                        playerDied()
                    }
//                    print("OUCH!!")
                }
            }
            
            
            for bossBullet in bossBulletList{
                if (bossBullet.position.x < playerSprite.position.x + playerSprite.width &&
                    bossBullet.position.x + bossBullet.width > playerSprite.position.x &&
                    bossBullet.position.y < playerSprite.position.y + playerSprite.height &&
                    bossBullet.height + bossBullet.position.y > playerSprite.position.y) {
                    bossBullet.position.x = 20.0
                    bossBullet.position.y = -5.0
                    destroySprite(bossBullet.id, array: bossBulletList)
                    playerHealth -= 15
                    if(playerHealth <= 0){
                        playerDied()
                    }
                }
            }
            for playerBullet in bulletList{
                if (playerBullet.position.x < bossSprite.position.x + bossSprite.width &&
                    playerBullet.position.x + playerBullet.width > bossSprite.position.x &&
                    playerBullet.position.y < bossSprite.position.y + bossSprite.height &&
                    playerBullet.height + playerBullet.position.y > bossSprite.position.y) {
                    playerBullet.position.x = 20.0
                    playerBullet.position.y = -5.0
                    destroySprite(playerBullet.id, array: bulletList)
                    
                    if(bossHealth>=0){
                        bossHealth -= 10
                    }
                    if(bossHealth <= 0){
                        bossHealth = 0
                        //boss died
                        score += 100
                        drawExplosion(bossSprite.position)
                        level += 1
                        bossShootTimer.invalidate()
                        for bull in bossBulletList{
                            bull.position.y = -10.0
                        }
                        bossBulletList.removeAll()
                        
                        if(level == 4){
                            //GAME OVER
                            print("game over!!!")
                        }
                        if (level == 2){
                            bossHealth = 100
                        }
                        if (level==3){
                            bossHealth = 120
                        }
                        bossPhase = false
                        bossCount = 0
                        levelKillCount = 0
                    }
                }
            }
            
        }
        
    }//end of col
    func drawExplosion(pos:Vector){
        
    }
}//end of class