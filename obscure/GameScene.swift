//
//  GameMenu.swift
//  obscure
//
//  Created by nick barr on 11/27/14.
//  Copyright (c) 2014 poemsio. All rights reserved.
//

import Foundation

import SpriteKit

class GameScene: SKScene {
    
    let sceneBackgroundColor = UIColor(red: 24/255, green: 18/255, blue: 28/255, alpha: 1)
    
    override func didMoveToView(view: SKView) {
        println("hello Scene")
        
        self.backgroundColor = sceneBackgroundColor
        var playerVPlayer = MenuButton(frame: CGRect(x:(view.frame.width-200)/2,y:view.frame.height/2+100,width:200,height:40))
        playerVPlayer.setTitle("Word of the Day", forState: .Normal)
        playerVPlayer.addTarget(self, action: Selector("pvpButtonPressed:"), forControlEvents: .TouchUpInside)
        view.addSubview(playerVPlayer)
        
        
    }
    
    func pvpButtonPressed(sender: MenuButton){
        for subview in self.view?.subviews as [UIView] {
            subview.removeFromSuperview()
        }
        self.view?.presentScene(GameBoard(), transition: SKTransition.crossFadeWithDuration(1))
    }
}
