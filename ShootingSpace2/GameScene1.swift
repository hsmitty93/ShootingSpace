//
//  GameScene.swift
//  ShootingSpace2
//
//  Created by Debra L Smith on 7/16/15.
//  Copyright (c) 2015 Hailey Smith. All rights reserved.
//

import SpriteKit
import AVFoundation

import GameKit


struct PhysicsCategory {
    static let enemy: UInt32 = 1
    static let Bullet: UInt32 = 2
    static let Player: UInt32 = 3
}



class GameScene1: SKScene, SKPhysicsContactDelegate, AVAudioPlayerDelegate, EasyGameCenterDelegate {
    var Player = SKSpriteNode(imageNamed: "spaceship-1.png")
    var Score = Int()
    let scoreLabel = SKLabelNode(fontNamed: "Silkscreen")
    let GameOver = SKSpriteNode(imageNamed: "Base.png")
    
    let RetryBtn = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    let GameCenter = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    
    let background = SKSpriteNode(imageNamed: "background.png")
    var gameOver = false
    let fileLocation = NSBundle.mainBundle().pathForResource("TheLastShip", ofType: ".wav")
    
    let GameOverText = SKLabelNode(fontNamed: "Silkscreen")
    
    
    
    var sound = AVAudioPlayer()
    
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer  {
        //1
        var path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        var url = NSURL.fileURLWithPath(path!)
        
        //2
        var error: NSError?
        
        //3
        var audioPlayer:AVAudioPlayer?
        audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
        
        //4
        return audioPlayer!
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        background.position = CGPointMake(self.size.width / 2, self.size.height / 2)
        background.zPosition = -3
        self.addChild(background)
        
        
        sound = self.setupAudioPlayerWithFile("TheLastShip", type:"wav")
        
        
        sound.numberOfLoops = -1
        sound.play()
        
        physicsWorld.contactDelegate = self
        
        Player.position = CGPointMake(self.size.width / 2, self.size.height/6)
        Player.physicsBody = SKPhysicsBody(rectangleOfSize: Player.size)
        Player.physicsBody?.affectedByGravity = false
        Player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        Player.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        Player.physicsBody?.dynamic = false
        
        GameOver.position = CGPointMake(self.size.width / 2, self.size.height / 2)
        [GameOver.setScale(0.8)]
        
        RetryBtn.frame = CGRectMake(0, 0, view.frame.size.width - 100, 60)
        RetryBtn.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 1.9)
        RetryBtn.setImage(UIImage(named: "RetryBtn.png"), forState: UIControlState.Normal)
        RetryBtn.addTarget(self, action: Selector("restartGame"), forControlEvents: UIControlEvents.TouchUpInside)
        
        GameCenter.frame = CGRectMake(0, 0, view.frame.size.width - 100, 60)
        GameCenter.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 1.5)
        GameCenter.setImage(UIImage(named: "GameCenterBtn.png"), forState: UIControlState.Normal)
        GameCenter.addTarget(self, action: Selector("ReportScore"), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.addChild(GameOver)
        self.view?.addSubview(GameCenter)
        self.view?.addSubview(RetryBtn)
        
        GameOver.hidden = true
        RetryBtn.hidden = true
        GameCenter.hidden = true
        
        
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(SpawnBullets), SKAction.waitForDuration(0.2)])), withKey: "actionB")
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(SpawnEnemies), SKAction.waitForDuration(0.7)])), withKey: "actionA")
        
        self.addChild(Player)
        
        
        GameOverText.text = "Game Over"
        GameOverText.fontSize = 50
        GameOverText.fontColor = SKColor.whiteColor()
        GameOverText.position = CGPointMake(GameOver.size.width * 1.45, GameOver.frame.height / 1)
        self.addChild(GameOverText)
        GameOverText.hidden = true
        
        
        
        
        
        
        scoreLabel.text = "\(Score)"
        scoreLabel.fontSize = 60
        scoreLabel.fontColor = SKColor.whiteColor()
        scoreLabel.position = CGPointMake(self.size.width / 2, self.size.height * 0.7)
        self.addChild(scoreLabel)
        
        
        
        
    }
    
    func Explosion(pos: CGPoint) {
        let emitterNode = SKEmitterNode(fileNamed: "ExplosionParticle.sks")
        emitterNode!.particlePosition = pos
        self.addChild(emitterNode!)
        //remove the emitter node after explosion
        self.runAction(SKAction.waitForDuration(2), completion: {
            emitterNode!.removeFromParent() })
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody : SKPhysicsBody = contact.bodyA
        let secondBody : SKPhysicsBody = contact.bodyB
        
        if((firstBody.categoryBitMask == PhysicsCategory.enemy) && (secondBody.categoryBitMask == PhysicsCategory.Bullet) || (firstBody.categoryBitMask == PhysicsCategory.Bullet) && (secondBody.categoryBitMask == PhysicsCategory.enemy)){
            CollisionWithBullet(firstBody.node as! SKSpriteNode, Bullet: secondBody.node as! SKSpriteNode)
        } else if((firstBody.categoryBitMask == PhysicsCategory.enemy) && (secondBody.categoryBitMask == PhysicsCategory.Player) || (firstBody.categoryBitMask == PhysicsCategory.Player) && (secondBody.categoryBitMask == PhysicsCategory.enemy)){
            CollisionWithPlayer(firstBody.node as! SKSpriteNode, Player: secondBody.node as! SKSpriteNode)
        }
    }
    
    func CollisionWithBullet(enemy: SKSpriteNode, Bullet:SKSpriteNode){
        
        enemy.removeFromParent()
        Bullet.removeFromParent()
        runAction(SKAction.playSoundFileNamed("Explosion.wav", waitForCompletion: false))
        Score++
        
        scoreLabel.text = "\(Score)"
    }
    
    func ReportScore(){
        
        EasyGameCenter.reportScoreLeaderboard(leaderboardIdentifier: "ScoreBoard", score: Score)
        println("sent score")
       EasyGameCenter.showGameCenterLeaderboard(leaderboardIdentifier: "ScoreBoard")
          
    }
    
    func CollisionWithPlayer(enemy:SKSpriteNode, Player: SKSpriteNode){
        enemy.removeFromParent()
        Player.removeFromParent()
        Player.hidden = true
        Explosion(self.Player.position)
        runAction(SKAction.playSoundFileNamed("Explosion2.wav", waitForCompletion: false))
        
        removeActionForKey("actionA")
        removeActionForKey("actionB")
        gameOver = true
        GameOver.hidden = false
        GameOverText.hidden = false
        
        RetryBtn.hidden = false
        GameCenter.hidden = false
        sound.stop()
        
    }
    
    func restartGame(){
        
        var gameScene = GameScene(size: self.size)
        gameScene.scaleMode = SKSceneScaleMode.AspectFill
        self.scene!.view?.presentScene(gameScene, transition: SKTransition.fadeWithDuration(0.4))
        RetryBtn.removeFromSuperview()
        GameCenter.removeFromSuperview()
        
    }
    
    func SpawnBullets(){
        
        let Bullet = SKSpriteNode(imageNamed: "bullet.png")
        Bullet.zPosition = -1
        Bullet.position = CGPointMake(Player.position.x, Player.position.y)
        let action = SKAction.moveToY(self.size.height + 30, duration: 0.8)
        let actionDone = SKAction.removeFromParent()
        Bullet.runAction(SKAction.sequence([action, actionDone]), withKey: "actionB")
        
        Bullet.physicsBody = SKPhysicsBody(rectangleOfSize: Bullet.size)
        Bullet.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
        Bullet.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        Bullet.physicsBody?.affectedByGravity = false
        Bullet.physicsBody?.dynamic = false
        runAction(SKAction.playSoundFileNamed("Bullet.wav", waitForCompletion: false))
        self.addChild(Bullet)
    }
    
    func SpawnEnemies(){
        let enemy = SKSpriteNode(imageNamed: "enemyRed.png")
        [enemy.setScale(0.5)]
        let MinValue = self.size.width / 8
        let MaxValue = self.size.width - 20
        let SpawnPoint = UInt32(MaxValue - MinValue)
        enemy.position = CGPoint(x: CGFloat(arc4random_uniform(SpawnPoint)), y: self.size.height)
        let action = SKAction.moveToY(-70, duration: 2.0)
        let actionDone = SKAction.removeFromParent()
        enemy.runAction(SKAction.sequence([action, actionDone]))
        
        
        
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.size)
        enemy.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        enemy.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.dynamic = true
        
        
        
        self.addChild(enemy)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            Player.position.x = location.x
            Player.position.y = location.y
            
            
            
            
        }
    }
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            Player.position.x = location.x
            Player.position.y = location.y
        }
    }
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

