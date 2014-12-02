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
        var wordOfTheDayButton = MenuButton(frame: CGRect(x:(view.frame.width-300)/2,y:view.frame.height/2+100,width:300,height:40))
        wordOfTheDayButton.setTitle("Guess the Word of the Day", forState: .Normal)
        wordOfTheDayButton.tag = 1
        wordOfTheDayButton.addTarget(self, action: Selector("buttonPressed:"), forControlEvents: .TouchUpInside)
        view.addSubview(wordOfTheDayButton)
        
        var multiplayerButton = MenuButton(frame: CGRect(x:(view.frame.width-300)/2,y:view.frame.height/2,width:300,height:40))
        multiplayerButton.setTitle("Play with a Friend", forState: .Normal)
        multiplayerButton.tag = 2
        multiplayerButton.addTarget(self, action: Selector("buttonPressed:"), forControlEvents: .TouchUpInside)
        view.addSubview(multiplayerButton)
    }
    

    func buttonPressed(sender: MenuButton){
        for subview in self.view?.subviews as [UIView] {
            subview.removeFromSuperview()
        }
        var data: NSMutableDictionary = ["gameMode":sender.tag]
        let gameBoard = GameBoard()
        gameBoard.userData = data
        println(data)
        self.view?.presentScene(gameBoard, transition: SKTransition.crossFadeWithDuration(1))
        
    }
    
    
}
