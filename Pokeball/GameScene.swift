//
//  GameScene.swift
//  Space Game
//
//  Created by Rolando Sorbelli on 25/09/2017.
//  Copyright © 2017 Rolando Sorbelli. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var pokeball: SKSpriteNode!
    var level: SKLabelNode!
    var scoreLabel: SKLabelNode?
    
    let motionManager = CMMotionManager()
    var xAcceleration: CGFloat = 0
    var yAcceleration: CGFloat = 0
    
    let pokeballCategory : UInt32 = 0x1 << 1
    let monCategory : UInt32 = 0x1 << 2
    
    var score = 0
    
    override func didMove(to view: SKView) {
        
    pokeball = SKSpriteNode(imageNamed: "pokeball")
    pokeball?.physicsBody?.categoryBitMask = pokeballCategory
    pokeball?.physicsBody?.contactTestBitMask = monCategory
    pokeball.position = CGPoint(x: self.frame.size.width/2, y: self.size.height/2)
    
    self.addChild(pokeball)
    
    pokeball.physicsBody = SKPhysicsBody(texture: pokeball.texture!,
                                           size: pokeball.texture!.size())
    pokeball.physicsBody?.usesPreciseCollisionDetection = true
    
    scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode
        func createMon() {
            let mon = SKSpriteNode(imageNamed: "pikachu")
            mon.physicsBody = SKPhysicsBody(rectangleOf: mon.size)
            mon.physicsBody?.categoryBitMask = monCategory
            mon.physicsBody?.contactTestBitMask = pokeballCategory
            addChild(mon)
            
            let maxY = self.frame.height / 2 - mon.size.height / 2
            let minY = -self.frame.height / 2 + mon.size.height / 2
            
            let rangeY = maxY - minY
            let monY = maxY - CGFloat(arc4random_uniform(UInt32(rangeY)))
            
            let maxX = self.frame.width/2 - mon.size.width/2
            let minX = -self.frame.width/2 + mon.size.width/2
            
            let rangeX = maxX - minX
            let monX = maxX - CGFloat(arc4random_uniform(UInt32(rangeX)))
            
            mon.position = CGPoint(x: monX, y: monY)
        }
    
    self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    self.physicsWorld.contactDelegate = self
    
    level = SKLabelNode(text: "Level: Makers4Lyf")
    level.position = CGPoint(x:200, y: self.frame.size.height - 60)
    level.fontName = "AmericanTypewriter-Bold"
    level.fontSize = 36
    level.fontColor = UIColor.white
    
    self.addChild(level)
    
    createMon()
    createMon()
    createMon()
    createMon()
        
    motionManager.accelerometerUpdateInterval = 0.2
    motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data:CMAccelerometerData?, error:Error?) in
        if let accelerometerData = data {
            let acceleration = accelerometerData.acceleration
            self.xAcceleration = CGFloat(acceleration.x) * 0.50 + self.xAcceleration * 0.50
            self.yAcceleration = CGFloat(acceleration.y) * 0.50 + self.yAcceleration * 0.50
        }
    }
    
}

    
    override func didSimulatePhysics() {
        pokeball.position.x += xAcceleration * 35
        pokeball.position.y += yAcceleration * 35
        
        if pokeball.position.x < -20 {
            pokeball.position = CGPoint(x: pokeball.position.x, y: pokeball.position.y)
        }else if pokeball.position.x > self.size.width + 20 {
            pokeball.position = CGPoint(x: pokeball.position.x, y: pokeball.position.y)
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        score += 1
        scoreLabel?.text = "Score: \(score)"
        
        if contact.bodyA.categoryBitMask == monCategory {
            contact.bodyA.node?.removeFromParent()
        }
        if contact.bodyB.categoryBitMask == monCategory {
            contact.bodyB.node?.removeFromParent()
        }
    }
}

