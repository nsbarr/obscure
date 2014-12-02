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
    let sceneBackgroundColor = UIColor(red: 24/255, green: 18/255, blue: 28/255, alpha: 1)
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.size = CGSizeMake(750,1334)
        view.sizeToFit()
        println("you win")
        println(view)
        self.scaleMode = .AspectFill
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: Selector("pan:"))
        self.view?.addGestureRecognizer(panRecognizer)
        self.backgroundColor = sceneBackgroundColor
        


        println("userData:\(self.userData)")
        
        
        
        
        
//        backgroundNode.size = self.size
//        backgroundNode.name = "backgroundNode"
//        self.addChild(backgroundNode)
        
        
//        let menuThing = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(self.frame.width/2,self.frame.width/2))
//        menuThing.alpha = 0.8
//        menuThing.position = CGPointMake(self.frame.midX,self.frame.midY)
//        self.addChild(menuThing)
        
        let theWord = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        theWord.text = self.userData?.objectForKey("word")! as String
        theWordText = theWord.text
        theWord.position = CGPointMake(self.frame.midX,self.frame.midY)
        theWord.fontColor = UIColor.whiteColor()
        theWord.fontSize = 80.0
        self.addChild(theWord)
        
        let timer = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        timer.text = self.userData?.objectForKey("timer")! as String
        timer.position = CGPointMakeCGPointMake(self.frame.midX-40,self.frame.midY-100)
        timer.fontColor = UIColor.whiteColor()
        timer.fontSize = 60.0
        self.addChild(timer)
        
        let numberOfGuesses = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        numberOfGuesses.text = self.userData?.objectForKey("plays")?.count
        numberOfGuesses.position = CGPointMakeCGPointMake(self.frame.midX+40,self.frame.midY-100)
        numberOfGuesses.fontColor = UIColor.whiteColor()
        numberOfGuesses.fontSize = 60.0
        self.addChild(numberOfGuesses)
        
        
        
//        var arrayOfPlays = self.userData?.objectForKey("plays") as [SKSpriteNode]
//        var yPosition:CGFloat = 0.0
//        arrayOfPlays = arrayOfPlays.reverse()
//        for var i=0; i<arrayOfPlays.count; i++ {
//            arrayOfPlays[i].removeFromParent()
//            arrayOfPlays[i].setScale(2.0)
//            arrayOfPlays[i].position = CGPointMake(self.frame.midX, yPosition+arrayOfPlays[i].frame.height/2)
//            backgroundNode.addChild(arrayOfPlays[i])
//            yPosition = yPosition + arrayOfPlays[i].frame.height
//        }
        
        
        var playAgainButton = MenuButton(frame: CGRect(x:(view.frame.width-200)/2,y:view.frame.height/2+200,width:200,height:40))
        playAgainButton.setTitle("Again", forState: .Normal)
        playAgainButton.alpha = 0.8
        playAgainButton.addTarget(self, action: Selector("pvpButtonPressed:"), forControlEvents: .TouchUpInside)
        view.addSubview(playAgainButton)
        
//        var defineButton = MenuButton(frame: CGRect(x:(view.frame.width-200)/2,y:view.frame.height/2+100,width:200,height:40))
//        defineButton.setTitle("Define", forState: .Normal)
//        defineButton.addTarget(self, action: Selector("defineButtonPressed:"), forControlEvents: .TouchUpInside)
//        view.addSubview(defineButton)
    }
    
    func pan(recognizer:UIPanGestureRecognizer){
        if (recognizer.state == .Ended){
//            var translation:CGPoint = recognizer.translationInView(recognizer.view!)
//            let scroll = SKAction.moveByX(0, y: translation.y, duration: 0.2)
//            backgroundNode.runAction(scroll)
//            recognizer.setTranslation(CGPointZero, inView: recognizer.view)
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