//
//  YouWin.swift
//  obscure
//
//  Created by nick barr on 11/27/14.
//  Copyright (c) 2014 poemsio. All rights reserved.
//

import Foundation

import SpriteKit

class YouWin: SKScene {
    
    
    var theWordText = String()
    var backgroundNode = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.size = CGSizeMake(750,1334)
        view.sizeToFit()
        println("you win")
        println(view)
        self.scaleMode = .AspectFill
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: Selector("pan:"))
        self.view?.addGestureRecognizer(panRecognizer)
        
        
        
        let youWinLabel = SKLabelNode(fontNamed: "Chalkduster")
        youWinLabel.text = "You Win!"
        youWinLabel.position = CGPointMake(self.frame.midX,40)
        youWinLabel.fontColor = UIColor.whiteColor()
        youWinLabel.fontSize = 40.0
        self.addChild(youWinLabel)

        println("userData:\(self.userData)")
        
        
        
        
        
        backgroundNode.size = self.size
        backgroundNode.name = "backgroundNode"
        self.addChild(backgroundNode)
        
        let theWord = SKLabelNode(fontNamed: "Chalkduster")
        theWord.text = self.userData?.objectForKey("word")! as String
        theWordText = theWord.text
        theWord.position = CGPointMake(self.frame.midX,self.frame.midY)
        theWord.fontColor = UIColor.whiteColor()
        theWord.fontSize = 60.0
        self.addChild(theWord)
        
        let timer = SKLabelNode(fontNamed: "Chalkduster")
        timer.text = self.userData?.objectForKey("timer")! as String
        timer.position = CGPointMake(self.frame.midX,self.frame.midY-100)
        timer.fontColor = UIColor.whiteColor()
        timer.fontSize = 60.0
        self.addChild(timer)
        
        let arrayOfPlays = self.userData?.objectForKey("plays") as [SKSpriteNode]
        var yPosition:CGFloat = 0.0
        for var i=0; i<arrayOfPlays.count-1; i++ {
            arrayOfPlays[i].removeFromParent()
            arrayOfPlays[i].setScale(2.0)
            arrayOfPlays[i].position = CGPointMake(self.frame.midX, self.frame.height-yPosition-arrayOfPlays[i].frame.height/2)
            backgroundNode.addChild(arrayOfPlays[i])
            yPosition = yPosition + arrayOfPlays[i].frame.height
        }
        
        
        var playAgainButton = MenuButton(frame: CGRect(x:(view.frame.width-200)/2,y:view.frame.height/2+200,width:200,height:40))
        playAgainButton.setTitle("Again", forState: .Normal)
        playAgainButton.addTarget(self, action: Selector("pvpButtonPressed:"), forControlEvents: .TouchUpInside)
        view.addSubview(playAgainButton)
        
        var defineButton = MenuButton(frame: CGRect(x:(view.frame.width-200)/2,y:view.frame.height/2+100,width:200,height:40))
        defineButton.setTitle("Define", forState: .Normal)
        defineButton.addTarget(self, action: Selector("defineButtonPressed:"), forControlEvents: .TouchUpInside)
        view.addSubview(defineButton)
    }
    
    func pan(recognizer:UIPanGestureRecognizer){
        if (recognizer.state == .Ended){
            var translation:CGPoint = recognizer.translationInView(recognizer.view!)
            let scroll = SKAction.moveByX(0, y: translation.y, duration: 0.2)
            backgroundNode.runAction(scroll)
            recognizer.setTranslation(CGPointZero, inView: recognizer.view)
        }
    }
    
    func pvpButtonPressed(sender: MenuButton){
        for subview in self.view?.subviews as [UIView] {
            subview.removeFromSuperview()
        }
        self.view?.presentScene(GameScene(), transition: SKTransition.crossFadeWithDuration(1))
    }
    
    func defineButtonPressed(sender: MenuButton){
        var vc = GameViewController()
        vc.passcode = theWordText
        vc.defineWord()
    }
}