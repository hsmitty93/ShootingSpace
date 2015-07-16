//
//  GameViewController.swift
//  ShootingSpace2
//
//  Created by Debra L Smith on 7/16/15.
//  Copyright (c) 2015 Hailey Smith. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit



class GameViewController: UIViewController, EasyGameCenterDelegate{
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*** Set Delegate UIViewController ***/
        EasyGameCenter.sharedInstance(self)
        
        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        EasyGameCenter.delegate = self
        
        func easyGameCenterAuthentified() {
            print("\n[AuthenticationActions] Player Authentified\n")
        }
        /**
        Player not connected to Game Center, Delegate Func of Easy Game Center
        */
        func easyGameCenterNotAuthentified() {
            print("\n[AuthenticationActions] Player not authentified\n")
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
}
