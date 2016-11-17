//
//  ViewController.swift
//  Asteroids
//
//  Created by Adam Rosenberg on 4/28/16.
//  Copyright © 2016 Adam Rosenberg. All rights reserved.
//

import GLKit


class OpenGLViewController: GLKViewController {
    
    //sprites
    let bgSprite = Sprite()
    
    //textures
    var backgroundTexture: GLKTextureInfo? = nil
    
    let uuid = NSUUID()
    
    var startTime: CFAbsoluteTime!
    var touchDown:Bool = false
    private var lastUpdate: NSDate = NSDate()
    private var lastBulletFired: NSDate = NSDate()
    private var currentPoint:CGPoint = CGPoint()
    private var gameModel:GameModel = GameModel()

    var scoreLabel = UILabel(frame: CGRectMake(15,20, 100, 20))
    var levelLabel = UILabel(frame: CGRectMake(120,20, 100, 20))
    var healthLabel = UILabel(frame: CGRectMake(240,20, 100, 20))
    var bossHealthLabel = UILabel(frame: CGRectMake(-5,-20, 30, 20))
    var newGame:Bool = false
    var gameStarted:Bool = false
    var gameIsPaused:Bool = true
    private var enemySpawnTimer: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let glkView: GLKView = view as! GLKView
        glkView.context = EAGLContext(API: .OpenGLES2)
        glkView.drawableColorFormat = .RGBA8888
        EAGLContext.setCurrentContext(glkView.context)
        setup()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //start game. called when resume or new game is clicked in main menu
    func startGame(){
        gameStarted = true
        gameIsPaused = false
        
        fetchHighScores()
        startTime = CFAbsoluteTimeGetCurrent()
        if(newGame){
            seedPlayer()
            fetch()
        }else{
            fetch()
            if (gameModel.level == 1){
                gameModel.bossHealth = 30
            }
            if (gameModel.level == 2){
                gameModel.bossHealth = 100
            }
            if (gameModel.level==3){
                gameModel.bossHealth = 120
            }
            gameModel.playerSprite.position.x = 0.0
            gameModel.playerSprite.position.y = -0.8
        }
        
        setupLabels()
        print("player info: lvl \(gameModel.level) score \(gameModel.score) HP \(gameModel.playerHealth)")
        
        enemySpawnTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(OpenGLViewController.spawnEnemy), userInfo: nil, repeats: true)
    }
    
    
    //label setup
    func setupLabels(){
        scoreLabel.backgroundColor = UIColor.redColor()
        scoreLabel.text = "Score: \(gameModel.score)"
        self.view.addSubview(scoreLabel)
        
        healthLabel.backgroundColor = UIColor.greenColor()
        healthLabel.text = "HP: \(gameModel.playerHealth)"
        self.view.addSubview(healthLabel)
        
        levelLabel.backgroundColor = UIColor.blueColor()
        levelLabel.text = "Level: \(gameModel.level)"
        self.view.addSubview(levelLabel)
        
        bossHealthLabel.backgroundColor = UIColor.blueColor()
        bossHealthLabel.text = "\(gameModel.bossHealth)"
        self.view.addSubview(bossHealthLabel)
    }
    
    
    //timer spawn method...
    
    func spawnEnemy(){
        if(gameModel.levelKillCount<10){
            gameModel.spawnEnemy()
        }else{
            if(gameModel.bossCount == 0){
                gameModel.bossPhase = true
                gameModel.spawnBoss()
            }
        }
        
    }
    
    //touch methods
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            currentPoint = touch.locationInView(self.view)
            if(!gameStarted){
                simulateButtons()
                
            }else{
                gamePress()
            }
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        gameModel.playerSprite.texture = gameModel.shipTexture!.name
        gameModel.directionButtons.texture = gameModel.directionalTexture!.name
        gameModel.fireButtonSprite.texture = gameModel.fireButtonOffTexture!.name
        gameModel.moveLeft = false
        gameModel.moveRight = false
        gameModel.moveUp = false
        gameModel.moveDown = false
        touchDown = false
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            currentPoint = touch.locationInView(self.view)
            
        }
    }
    
    func gamePress(){
        if((currentPoint.x > 275 && currentPoint.x < 300) && (currentPoint.y < 90 && currentPoint.y > 60)){
            gameStarted = false
            gameIsPaused = true
        }
        
        if(currentPoint.x < 97 && currentPoint.y > 470){
            if((currentPoint.x > 35 && currentPoint.x < 67) && (currentPoint.y > 470 && currentPoint.y < 495)){
                gameModel.directionButtons.texture = gameModel.directionalUpTexture!.name
                gameModel.moveUp = true
            }
            else if((currentPoint.x > 65 && currentPoint.x < 97) && (currentPoint.y > 495 && currentPoint.y < 520)){
                gameModel.directionButtons.texture = gameModel.directionalRightTexture!.name
                gameModel.moveRight = true
            }
            else if((currentPoint.x > 35 && currentPoint.x < 67) && (currentPoint.y > 530 && currentPoint.y < 557)){
                gameModel.directionButtons.texture = gameModel.directionalDownTexture!.name
                gameModel.moveDown = true
            }
            else if((currentPoint.x > 10 && currentPoint.x < 35) && (currentPoint.y > 495 && currentPoint.y < 520)){
                gameModel.directionButtons.texture = gameModel.directionalLeftTexture!.name
                gameModel.moveLeft = true
            }
        }
        
        if((currentPoint.x > 245 && currentPoint.x < 295) && (currentPoint.y > 490 && currentPoint.y < 540)){
            gameModel.fireButtonSprite.texture = gameModel.fireButtonOnTexture!.name
            touchDown = true
            
            let elapsed = CFAbsoluteTimeGetCurrent() - startTime
            
            if(elapsed > 0.8){
                gameModel.fireBullet()
                startTime = CFAbsoluteTimeGetCurrent()
            }
            
        }
    }
    
    
    private func setup(){
        
        glClearColor(0.0, 0.0, 0.0, 0.0)
        
        //load textures and associate them with sprites.
        gameModel.shipTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "shipCenter")!.CGImage!, options: nil)
        gameModel.shipLeftTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "shipLeft")!.CGImage!, options: nil)
        gameModel.shipRightTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "shipRight")!.CGImage!, options: nil)
        gameModel.bulletTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "bullet")!.CGImage!, options: nil)
        gameModel.invaderTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "invader")!.CGImage!, options: nil)
        gameModel.background1Texture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "level1BG.jpg")!.CGImage!, options: nil)
        gameModel.directionalTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "directionalButtonOff")!.CGImage!, options: nil)
        gameModel.directionalUpTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "directionButtonsUp")!.CGImage!, options: nil)
        gameModel.directionalDownTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "directionalButtonsDown")!.CGImage!, options: nil)
        gameModel.directionalLeftTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "directionalButtonsLeft")!.CGImage!, options: nil)
        gameModel.directionalRightTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "directionalButtonsRight")!.CGImage!, options: nil)
        
        gameModel.bossTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "boss")!.CGImage!, options: nil)

        gameModel.backTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "pause")!.CGImage!, options: nil)

        gameModel.fireButtonOnTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "fireButtonOn")!.CGImage!, options: nil)
        gameModel.fireButtonOffTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "fireButtonOff")!.CGImage!, options: nil)
        backgroundTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "MainMenu")!.CGImage!, options: nil)
        gameModel.bossBulletTexture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "bossBullet")!.CGImage!, options: nil)
        
        gameModel.background3Texture = try! GLKTextureLoader.textureWithCGImage(UIImage(named: "level1BG.jpg")!.CGImage!, options: nil)
        
        
        gameModel.backSprite.texture = gameModel.backTexture!.name
        
        gameModel.levelOneBackgroundSprite3.texture = gameModel.background3Texture!.name
        gameModel.levelOneBackgroundSprite4.texture = gameModel.background3Texture!.name

        gameModel.bossSprite.texture = gameModel.bossTexture!.name
        gameModel.invaderSprite.texture = gameModel.invaderTexture!.name
        gameModel.playerSprite.texture = gameModel.shipTexture!.name
        gameModel.levelOneBackgroundSprite.texture = gameModel.background1Texture!.name
        gameModel.levelOneBackgroundSprite2.texture = gameModel.background1Texture!.name
        
        gameModel.fireButtonSprite.texture = gameModel.fireButtonOffTexture!.name
        gameModel.directionButtons.texture = gameModel.directionalTexture!.name
        
        bgSprite.texture = backgroundTexture!.name
        bgSprite.width = 2.0
        bgSprite.height = 2.0
        
    }
    
    func update(){
        
        
        if(!gameIsPaused && gameStarted){
            if(!gameModel.bossPhase){
                bossHealthLabel.frame = CGRectMake(-100,-100, 40, 20)
                self.view.addSubview(bossHealthLabel)
            }
            if(gameModel.playerHealth <= 0){
                //player died
                gameIsPaused = true
                gameStarted = false
                
                
//                //1. Create the alert controller.
//                var alert = UIAlertController(title: "Please enter name ",  message: "You have fallen. Your score is \(gameModel.score) and you survived to level \(gameModel.level)", preferredStyle: .Alert)
//                
//                //2. Add the text field. You can configure it however you need.
//                alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
//                    textField.text = ""
//                })
//                
//                //3. Grab the value from the text field, and print it when the user clicks OK.
//                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
////                    let textField = alert.textFields![0] as UITextField
////                    println("Text field: \(textField.text)")
//                    
//                }))
//                // 4. Present the alert.
//                self.presentViewController(alert, animated: true, completion: nil)
//
                var tField: UITextField!
                
                func configurationTextField(textField: UITextField!)
                {
                    //                    print("generating the TextField")
                    //                    textField.placeholder = "Enter an item"
                    gameModel.userName = textField.text!
                    seedPlayer()
                }
                
                
                func handleCancel(alertView: UIAlertAction!)
                {
                    
                }
                
                var alert = UIAlertController(title: "You died", message: "You have fallen. Your score is \(gameModel.score) and you survived to level \(gameModel.level)", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addTextFieldWithConfigurationHandler(configurationTextField)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:handleCancel))
                alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
                }))
                self.presentViewController(alert, animated: true, completion: {
                    
                })
                
                
                
                /////////
                
                
       
            }
            if(gameModel.level > 3){
                //game over..
                gameModel.spriteList.removeAll()
                gameModel.invaderList.removeAll()
                gameModel.bulletList.removeAll()
                //            gameModel.level = 1
                gameStarted = false
                gameIsPaused = true
//                
//                
//                let alert = UIAlertController(title: "You won!", message: "You beat the third boss! You are the master! Your score is \(gameModel.score) and you survived with \(gameModel.playerHealth)", preferredStyle: UIAlertControllerStyle.Alert)
//                alert.addAction(UIAlertAction(title: "Main Menu", style: UIAlertActionStyle.Default, handler: nil))
//                self.presentViewController(alert, animated: true, completion: nil)
//                
                
                var tField: UITextField!
                
                func configurationTextField(textField: UITextField!)
                {
                    //                    print("generating the TextField")
                    //                    textField.placeholder = "Enter an item"
                    gameModel.userName = textField.text!
                    seedPlayer()
                }
                
                
                func handleCancel(alertView: UIAlertAction!)
                {
                    
                }
                
                var alert = UIAlertController(title: "Enter Input", message: "You beat the third boss! You are the master! Your score is \(gameModel.score) and you survived with \(gameModel.playerHealth)", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addTextFieldWithConfigurationHandler(configurationTextField)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:handleCancel))
                alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
                }))
                self.presentViewController(alert, animated: true, completion: {
                    
                })
                
                seedPlayer()
                
                
                
            }
            if(touchDown){
                let elapsed = CFAbsoluteTimeGetCurrent() - startTime
                
                if(elapsed > 0.8){
                    gameModel.fireBullet()
                    startTime = CFAbsoluteTimeGetCurrent()
                }
            }
            seedPlayer()
            scoreLabel.text = "Score: \(gameModel.score)"
            healthLabel.text = "HP: \(gameModel.playerHealth)"
            levelLabel.text = "Level: \(gameModel.level)"
            if(gameModel.bossPhase){
                for invader in gameModel.invaderList{
                    gameModel.destroySprite(invader.id, array: gameModel.invaderList)
                }
                
                bossHealthLabel.backgroundColor = UIColor.redColor()
                bossHealthLabel.text = "\(gameModel.bossHealth)"
                bossHealthLabel.frame = CGRectMake(CGFloat(abs(gameModel.bossSprite.position.x)*100+50), CGFloat(gameModel.bossSprite.position.y*100), 40, 20)
                self.view.addSubview(bossHealthLabel)
            }
            let now = NSDate()
            let elapsed = now.timeIntervalSinceDate(lastUpdate)
            lastUpdate = now
            gameModel.ExecuteGameLoop(elapsed)
        }else{
            
        }
        
    }
    
    override func glkView(view: GLKView, drawInRect rect: CGRect) {
        if(!gameIsPaused && gameStarted){
            glClear(GLbitfield(GL_COLOR_BUFFER_BIT)) //draw operation.
            
            let height : GLint = GLsizei(view.bounds.height * view.contentScaleFactor)
            let offset : GLint = GLsizei((view.bounds.height - view.bounds.width) * 0.5 * view.contentScaleFactor)
            glViewport(-offset, 0, height, height)
            gameModel.levelOneBackgroundSprite.draw()
            gameModel.levelOneBackgroundSprite2.draw()
            gameModel.levelOneBackgroundSprite3.draw()
            gameModel.levelOneBackgroundSprite4.draw()
            for sprite in gameModel.spriteList{
                sprite.draw()
            }
            gameModel.directionButtons.draw()
            gameModel.backSprite.draw()
            gameModel.fireButtonSprite.draw()
            gameModel.playerSprite.draw()
            if(gameModel.bossPhase){
                gameModel.bossSprite.draw()
            }
        }
        
        if(!gameStarted){
            bgSprite.draw()
        }
    }
    
    //main menu
    func simulateButtons(){
        if (currentPoint.x > 75 && currentPoint.x < 248){
            if(currentPoint.y > 190 && currentPoint.y < 230){
                //new game
                newGame = true
                startGame()
            }
            if(currentPoint.y > 250 && currentPoint.y < 300){
                //resume game
                startGame()
            }
            if(currentPoint.y > 330 && currentPoint.y < 370){
                //high scores
                fetchHighScores()
                let alert = UIAlertController(title: "High scores:", message: "Here are the high scores for \(gameModel.userName): \n" +
                    "\(gameModel.highScoreList[0])\n" +
                    "\(gameModel.highScoreList[1])\n" +
                    "\(gameModel.highScoreList[2])\n" +
                    "\(gameModel.highScoreList[3])\n" +
                    "\(gameModel.highScoreList[4])\n", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Main Menu", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
        }
    }
    
    
    //saving
    func seedPlayer() {
        let prefs = NSUserDefaults.standardUserDefaults()
        if(gameModel.level > 3){
            print("saving end of game")
            gameStarted = false
            gameIsPaused = true
            gameModel.spriteList.removeAll()
            gameModel.invaderList.removeAll()
            gameModel.bossPhase = false
            gameModel.bulletList.removeAll()
            gameModel.level = 4
            prefs.setObject(gameModel.userName, forKey: "userName")
            prefs.setObject(0, forKey: "currentScore")
            prefs.setObject(1, forKey: "currentLevel")
            prefs.setObject(100, forKey: "playerHealth")
            
        }else if(gameModel.playerHealth <= 0){
            //saved after palyer death
            gameStarted = false
            gameIsPaused = true
            gameModel.bossPhase = false
            gameModel.spriteList.removeAll()
            gameModel.invaderList.removeAll()
            gameModel.bulletList.removeAll()
            gameModel.level = 4
            
            prefs.setObject(0, forKey: "currentScore")
            prefs.setObject(1, forKey: "currentLevel")
            prefs.setObject(100, forKey: "playerHealth")
            
        }else{
            prefs.setObject(gameModel.userName, forKey: "userName")
            prefs.setObject(gameModel.score, forKey: "currentScore")
            prefs.setObject(gameModel.level, forKey: "currentLevel")
            prefs.setObject(gameModel.playerHealth, forKey: "playerHealth")
            
        }
        
    }
    
    func fetchHighScores(){
        let prefs = NSUserDefaults.standardUserDefaults()
        gameModel.userName = prefs.stringForKey("userName")!
        gameModel.highScoreList.append(prefs.integerForKey("highScore1"))
        gameModel.highScoreList.append(prefs.integerForKey("highScore2"))
        gameModel.highScoreList.append(prefs.integerForKey("highScore3"))
        gameModel.highScoreList.append(prefs.integerForKey("highScore4"))
        gameModel.highScoreList.append(prefs.integerForKey("highScore5"))
        
        gameModel.highScoreList.sortInPlace(>)
        
    }
    
    func fetch() {
        let prefs = NSUserDefaults.standardUserDefaults()
        
        gameModel.userName = prefs.stringForKey("userName")!
        gameModel.score = prefs.integerForKey("currentScore")
        gameModel.level = prefs.integerForKey("currentLevel")
        gameModel.playerHealth = prefs.integerForKey("playerHealth")
        
        if(gameModel.level>3 || gameModel.playerHealth <= 0){
            gameModel.score = 0
            gameModel.level = 1
            gameModel.playerHealth = 100
        }
    }
    
    func seedHighScores(){
        let prefs = NSUserDefaults.standardUserDefaults()
        gameModel.highScoreList.sortInPlace(>)
        prefs.setObject(gameModel.highScoreList[0], forKey: "highScore1")
        prefs.setObject(gameModel.highScoreList[1], forKey: "highScore2")
        prefs.setObject(gameModel.highScoreList[2], forKey: "highScore3")
        prefs.setObject(gameModel.highScoreList[3], forKey: "highScore4")
        prefs.setObject(gameModel.highScoreList[4], forKey: "highScore5")
        
    }
}



