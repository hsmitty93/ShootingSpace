//
//  StartGameScene.swift
//  ShootingSpace2
//
//  Created by Hailey Smith on 7/15/15.
//  Copyright © 2015 hsmitty93. All rights reserved.
//

import UIKit
import SpriteKit

class GameScene: SKScene {
    
    let StartBtn = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    let StartBase = SKSpriteNode(imageNamed: "Base.png")
    let Shooting = SKLabelNode(fontNamed: "Silkscreen")
    let Space = SKLabelNode(fontNamed: "Silkscreen")
    let background = SKSpriteNode(imageNamed: "background.png")
    
    
        override func didMoveToView(view: SKView) {
            background.position = CGPointMake(self.size.width / 2, self.size.height / 2)
            self.addChild(background)
            
            StartBase.position = CGPointMake(self.size.width / 2, self.size.height / 2)
            [StartBase.setScale(0.8)]
            self.addChild(StartBase)
            
            Shooting.text = "Shooting"
            Shooting.fontSize = 60
            Shooting.fontColor = SKColor.whiteColor()
            Shooting.position = CGPointMake(StartBase.size.width * 1.45, StartBase.frame.height * 1.1)
            self.addChild(Shooting)
            
            Space.text = "Space"
            Space.fontSize = 60
            Space.fontColor = SKColor.whiteColor()
            Space.position = CGPointMake(StartBase.size.width * 1.45, StartBase.frame.height * 0.95)
            self.addChild(Space)
            
            StartBtn.frame = CGRectMake( 0, 0, view.frame.size.width - 100, 60)
            StartBtn.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 1.65)
            
            StartBtn.setImage(UIImage(named: "StartBtn.png"), forState: UIControlState.Normal)
            StartBtn.addTarget(self, action: Selector("StartGame"), forControlEvents: UIControlEvents.TouchUpInside)
            self.view?.addSubview(StartBtn)
    
    }
    func StartGame(){
        var gameScene = GameScene1(size: self.size)
        gameScene.scaleMode = SKSceneScaleMode.AspectFill
        self.scene!.view?.presentScene(gameScene, transition: SKTransition.fadeWithDuration(0.4))
        StartBtn.removeFromSuperview()
    }
}
