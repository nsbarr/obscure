
//
//  GameScene.swift
//  obscure
//
//  Created by nick barr on 11/26/14.
//  Copyright (c) 2014 poemsio. All rights reserved.
//

import SpriteKit

class GameBoard: SKScene {
    
    var letters = [["Y","Z"],["S", "T", "U", "V", "W", "X"],["M", "N", "O", "P", "Q", "R"], ["G", "H", "I", "J", "K", "L"], ["A", "B", "C", "D", "E", "F"]]
    let sceneBackgroundColor = UIColor(red: 198/255, green: 208/255, blue: 178/255, alpha: 1)
    let perfectMatchColor = UIColor.blueColor()
    let imperfectMatchColor = UIColor(red: 119/255, green: 252/255, blue: 212/255, alpha: 1)
    var tileFontSize:CGFloat = 40.0
    var tileFontName = "ArialRoundedMTBold"
    var tileWidth:CGFloat = 0
    var tileHeight:CGFloat = 0.0
    let tileSpacing:CGFloat = 6.0
    let gutterSpacing:CGFloat = 40.0
    let tileFontColor = UIColor(red: 24/255, green: 18/255, blue: 28/255, alpha: 1)
    let tileColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    var letterYPosition = CGFloat()
    var lastTappedTile = SKSpriteNode()
    var numberOfLettersInGuess = 0
    var guessArea = SKSpriteNode()
    var guessSpacing:CGFloat = 60.0
    var guessArray:[Character] = []
    var theWord = "LOVE"
    var wordArray:[String] = Array()
    var timerLabel = SKLabelNode()
    var timescore = Int()
    var actionwait = SKAction.waitForDuration(1.0)
    var timesecond = Int()
    var vc = GameViewController()
    var experimentArray:[SKSpriteNode] = []
    var deleteButton = SKSpriteNode()
    
    
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.scaleMode = .AspectFit
        self.size = CGSizeMake(750,1334)
        println(UIScreen.mainScreen().bounds.size)
        self.backgroundColor = tileFontColor
        println(self.size)
        tileWidth = (self.size.width - gutterSpacing*2.0 - tileSpacing*5)/6
        tileHeight = tileWidth - 20
        tileFontSize = tileHeight - 40.0
        
        var path = NSBundle.mainBundle().pathForResource("everyfourletterword", ofType: "txt")
        let content = NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: nil)
        let upperContent = content!.uppercaseString
        wordArray = upperContent.componentsSeparatedByString("\n")
        
        var gameMode = self.userData?.objectForKey("gameMode")! as Int
        println(gameMode)
        
        if (gameMode == 1) {
            println("singleplayer mode")
            self.generateKeyboard()
            self.generateSubmitButtonWithText("Guess")
            self.generateRandomPassword()
            self.generateTimer()
            
        }
        else if (gameMode == 2) {
            println("multiplayer mode")
            self.generateKeyboard()
            self.generateSubmitButtonWithText("Create")
            let someText = SKLabelNode(text: "Set the Password!")
            someText.fontSize = 60.0
            someText.color = tileColor
            someText.name = "SetPassword"
            someText.fontName = tileFontName
            someText.position = CGPointMake(self.frame.midX,self.frame.midY+200)
            self.addChild(someText)
            //add "Create MasterPass" text
            
        }
        else {
            println("error")
        }

        self.createGuessArea()
        self.createDeleteButton()
        
    }
    
    func generateKeyboard(){
        var letterYPosition = gutterSpacing + tileHeight/2
        for rowOfLetters in letters {
            var letterXPosition = gutterSpacing + tileWidth/2
            
            for letter in rowOfLetters {
                self.generateTileWithLetter(letter, withPosition: CGPoint(x: letterXPosition, y: letterYPosition))
                letterXPosition = letterXPosition + tileWidth + tileSpacing
            }
            letterYPosition = letterYPosition + tileHeight + tileSpacing
        }
        
    }
    
    
    func generateSubmitButtonWithText(text:String){
        let submitButton = SKSpriteNode(color: sceneBackgroundColor, size:CGSizeMake(tileWidth*2+tileSpacing,tileHeight))
        submitButton.position = CGPoint(x: self.frame.width-(submitButton.size.width/2+gutterSpacing), y: gutterSpacing+submitButton.size.height/2)
        submitButton.color = UIColor.blueColor()
        submitButton.name = text
        let goText = SKLabelNode(fontNamed: tileFontName)
        goText.text = text
        goText.verticalAlignmentMode = .Center
        goText.fontSize = tileFontSize
        goText.fontColor = UIColor.whiteColor()
        self.addChild(submitButton)
        submitButton.addChild(goText)
    }
    
    func generateTimer(){
        
        timerLabel.fontName = tileFontName
        timerLabel.fontSize = 60.0
        timerLabel.fontColor = tileColor
        timerLabel.text = "0:00"
        timerLabel.position = CGPointMake(self.frame.midX, gutterSpacing)
        self.addChild(timerLabel)
        
        
        
        var actionrun = SKAction.runBlock({
            self.timescore++
            self.timesecond++
            if self.timesecond == 60 {self.timesecond = 0}
            self.timerLabel.text = String(format:"\(self.timescore/60):%02d", self.timesecond)
            //println(String(format: "%02d", myInt))
        })
        timerLabel.runAction(SKAction.repeatActionForever(SKAction.sequence([actionwait,actionrun])))
        

    }
    
    func createGuessArea() {
        guessArea = SKSpriteNode(color: tileColor, size: CGSizeMake(self.frame.width/2,tileHeight))
        guessArea.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        guessArea.name = "guessArea"
        self.addChild(guessArea)
    }
    
    func createDeleteButton(){
        deleteButton = SKSpriteNode(color: UIColor.grayColor(), size: CGSizeMake(60,60))
        deleteButton.position = CGPointMake(guessArea.frame.minX, guessArea.position.y)
        deleteButton.name = "delete"
        self.addChild(deleteButton)
    }
    
    func generateRandomPassword() {
        let randomIndex = Int(arc4random_uniform(UInt32(wordArray.count)))
        theWord = wordArray[randomIndex]
        
        vc.passcode = theWord
        println(vc.passcode)

    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            
            let location = touch.locationInNode(self)
            let touchedNodes = nodesAtPoint(location) as [SKNode]
            
            for touchedNode in touchedNodes{
                let nodeName: String? = touchedNode.name
                
                if nodeName == "tile" || nodeName == "Guess" || nodeName == "Create" {
                    lastTappedTile = touchedNode as SKSpriteNode
                    lastTappedTile.setScale(0.8)
                }
            }
        }
        
    }
    
    
    func evaluateGuess() {
        
        
        var theWordArray = Array(theWord)
        let foo = String(guessArray)
        if guessArray == theWordArray {
            println("you win")
            experimentArray.append(guessArea)
            vc.timer = timerLabel.text
            let winScene = YouWin()
            
            let data: NSMutableDictionary = ["timer":self.timerLabel.text, "word":self.theWord, "plays":self.experimentArray]
            
            
            winScene.userData = data
            println(winScene.userData)
    
            self.view?.presentScene(winScene, transition: SKTransition.crossFadeWithDuration(0.4))
            
        }
        
        else if (find(wordArray, foo) == nil){
            println("not a word")
            self.throwMessageWithText("Has to be a 4 letter word!")
        }
        else {
            println("you don't win")
            self.animateGuess()
        }
    }
    
    
    func throwMessageWithText(text:String) {
        let getOutDaWay = SKAction.moveByX(2000.0, y: 0.0, duration: 0.2)
        let message = SKLabelNode(text: text)
        guessArea.runAction(getOutDaWay, completion: { () -> Void in

            message.position = CGPointMake(self.frame.midX,self.frame.midY)
            message.fontSize = 40.0
            message.fontColor = self.tileColor
            message.fontName = self.tileFontName
            self.addChild(message)
            self.clearGuessArea()

        })
        let wait = SKAction.waitForDuration(2)
        let waitAndSlideBack = SKAction.sequence([wait,getOutDaWay.reversedAction()])
        
        guessArea.runAction(waitAndSlideBack, completion: { () -> Void in
            message.removeFromParent()
        })
        
    }
    
    func clearGuessArea(){
        self.guessArea.removeAllChildren()
        self.numberOfLettersInGuess = 0
        guessArray = []
    }
    
    func colorSquares() {
        
        let originalGuessArray = guessArray
        var theWordArray = Array(theWord)
        println("guess array: \(guessArray)")
        for var i = 0; i < guessArray.count; i++ {
            let guessLetter = guessArea.children[i].childNodeWithName("guessLetter") as SKLabelNode
            if guessArray[i] == theWordArray[i] {
                println("it's a perfect match")
                let papaNode = guessLetter.parent as SKSpriteNode
                papaNode.color = perfectMatchColor
                guessLetter.fontColor = UIColor.whiteColor()
                theWordArray[i] = Character("!")
                guessArray[i] = Character("!")
            }
            else {
                println("it's not a perfect match")
                
            }
            
        }
        for var i = 0; i < guessArray.count; i++ {
            let guessLetter = guessArea.children[i].childNodeWithName("guessLetter") as SKLabelNode
            if (find(theWordArray, guessArray[i]) != nil && (guessArray[i] != Character("!"))) {
                println("right letter in the wrong place")
                let papaNode = guessLetter.parent as SKSpriteNode
                papaNode.color = imperfectMatchColor
                //theWordArray[i] = Character("!")
                theWordArray[find(theWordArray, guessArray[i])!] = Character("!")
                guessArray[i] = Character("!")
            }
            else if (find(theWordArray, guessArray[i]) == nil && (guessArray[i] != Character("!"))) {
                let papaNode = guessLetter.parent as SKSpriteNode
                papaNode.color = UIColor.grayColor()
            }
            
        }
        for var i = 0; i < originalGuessArray.count; i++ {
            if (find(Array(theWord), originalGuessArray[i]) == nil){
                self.darkenLetterInKeyboardWithColor(originalGuessArray[i], color: UIColor.grayColor())
            }
            else {
                self.darkenLetterInKeyboardWithColor(originalGuessArray[i], color: imperfectMatchColor)
            }
        }
        
        self.respawnGuessArea()
    }
    
    
    func respawnGuessArea(){
        self.createGuessArea()
        
        numberOfLettersInGuess=0
        guessArray = []
    }
    
    
    func darkenLetterInKeyboardWithColor(letter:Character, color:UIColor) {
        self.enumerateChildNodesWithName("tile") {
            node, stop in
            // do something with node or stop
            let letterTile = node.children[0] as SKLabelNode
            if (letter == Character(letterTile.text)){
                let tile = letterTile.parent as SKSpriteNode
                tile.color = color
                
            }
        }
    }
    
    func animateGuess(){
        experimentArray.append(guessArea)
        var xPos = CGFloat()
        if experimentArray.count < 8 {
            xPos = self.frame.midX
        }
        else if experimentArray.count == 8 {
            xPos = self.frame.maxX - gutterSpacing - (guessArea.frame.width*0.8)/2
            guessSpacing = 60.0
            for var i=0; i<experimentArray.count-1; i++ {
                let slide = SKAction.moveToX(self.frame.minX + gutterSpacing + (guessArea.frame.width*0.8)/2, duration: 0.2)
                experimentArray[i].runAction(slide)
                
            }
        }
        else if (experimentArray.count > 8) && (experimentArray.count < 16){
            xPos = self.frame.maxX - gutterSpacing - (guessArea.frame.width*0.8)/2
        }
        else { //do clever stuff at some point
            for var i=0; i<experimentArray.count-1; i++ {
                let slide = SKAction.moveByX(-50.0, y: 0.0, duration: 0.2)
                let shrink = SKAction.scaleTo(0.5, duration: 0.2)
                let slideAndShrink = SKAction.sequence([slide,shrink])
                experimentArray[i].runAction(slideAndShrink)
            }

        }
        let move = SKAction.moveTo(CGPointMake(xPos,self.frame.height-guessSpacing), duration: 0.5)
        let shrink = SKAction.scaleTo(0.8, duration: 0.5)
        let shrinkAndMove = SKAction.group([move,shrink])
        guessArea.runAction(shrinkAndMove, completion: { () -> Void in
            self.colorSquares()
        })
        guessSpacing = guessSpacing+guessArea.frame.height*0.8
        
        
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        lastTappedTile.setScale(1.0)
        if let letter = lastTappedTile.childNodeWithName("letter") as? SKLabelNode {
            self.generateGuessLetterFrom(letter)
        }
        else if lastTappedTile.name == "Guess" {
            self.evaluateGuess()
        }
        else if lastTappedTile.name == "Create" {
            theWord = String(guessArray)
            println(theWord)
            if (find(wordArray, theWord) == nil){
                println("not a word")
                self.throwMessageWithText("Has to be a 4 letter word!")
                self.clearGuessArea()
            }
            else {
                vc.passcode = theWord
                self.throwMessageWithText("Saved! Now pass it to a friend.")
                self.childNodeWithName("Create")?.removeFromParent()
                self.childNodeWithName("SetPassword")?.removeFromParent()
                self.generateSubmitButtonWithText("Guess")
                self.generateTimer()
            }
            
        }
        lastTappedTile = SKSpriteNode()
    }
    
    func generateGuessLetterFrom(letter: SKLabelNode) {
        if (numberOfLettersInGuess < 4) {
            let guessLabel = SKLabelNode(fontNamed: tileFontName)
            guessLabel.text = letter.text
            guessLabel.name = "guessLetter"
            guessLabel.fontSize = tileFontSize
            guessLabel.fontColor = tileFontColor
            guessLabel.verticalAlignmentMode = .Center
            let guessNode = SKSpriteNode(color: tileColor, size: CGSizeMake(guessArea.frame.width/4,guessArea.frame.height))
            guessNode.position.x = -guessArea.frame.width/2 + guessArea.frame.width/4*CGFloat(numberOfLettersInGuess)+guessArea.frame.width/8
            guessArea.addChild(guessNode)
            guessNode.addChild(guessLabel)
            numberOfLettersInGuess = numberOfLettersInGuess+1
            guessArray.append(Character(guessLabel.text))
            println(guessArray)
        }
        
    }
    
    
    func generateTileWithLetter(letterToPass: NSString, withPosition position: CGPoint) {
        let tile = SKSpriteNode(color: sceneBackgroundColor, size:CGSizeMake(tileWidth,tileHeight))
        tile.position = position
        tile.name = "tile"
        tile.color = tileColor
        println(tile.position)
        let tileLabel = SKLabelNode(fontNamed: tileFontName)
        tileLabel.text = letterToPass
        tileLabel.name = "letter"
        tileLabel.fontSize = tileFontSize
        tileLabel.fontColor = tileFontColor
        println(tileFontSize)
        tileLabel.position = CGPointMake(0, 0)
        tileLabel.verticalAlignmentMode = .Center
        tile.addChild(tileLabel)
        self.addChild(tile)
        
    }
    

    
    
    override func update(currentTime: CFTimeInterval) {
        if guessArray.count > 0 {
            deleteButton.alpha = 0
        }
        else {
            deleteButton.alpha = 0
        }

    }
}
