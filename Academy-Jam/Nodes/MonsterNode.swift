//
//  MonsterNode.swift
//  Academy-Jam
//
//  Created by Eduardo Cordeiro da Camara on 04/05/24.
//

import Foundation
import CoreGraphics
import SpriteKit

extension CGPoint {
    static func randomInCircumference(ofRadius radius: CGFloat) -> CGPoint {
        let distance: CGFloat = radius
        let angle = CGFloat.random(in: 0..<2 * .pi)
        
        let x = cos(angle) * distance
        let y = sin(angle) * distance
        
        return CGPoint(x: x, y: y)
    }
}

enum Monsters: String {
    case ex1 = "ex1", ex2, ex3
    
    static func random() -> Monsters {
        let allValues: Array<Monsters> = [.ex1, .ex2, .ex3]
        return allValues[.random(in: 0..<3)]
    }
}

class MonsterNode: SKNode, SKPhysicsContactDelegate {
    let sprite: SKSpriteNode
    let monsterType: Monsters
    
    init(ofType monster: Monsters? = nil) {
        
        // TODO: Later integrate assets
        self.monsterType = monster ?? .random()
        //self.sprite = .init(imageNamed: "\(monsterType.rawValue) 1")
        // FIXME: Temporary
        self.sprite = .init(color: .brown, size: .init(width: 30, height: 30))
        
        super.init()
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.sprite.size.width / 2)
        self.physicsBody!.isDynamic = true
        self.physicsBody!.categoryBitMask = PhysicsCategory.Monster.rawValue
        self.physicsBody!.contactTestBitMask = PhysicsCategory.Player.rawValue | PhysicsCategory.Attack.rawValue
        self.physicsBody!.collisionBitMask = PhysicsCategory.None.rawValue
        self.physicsBody!.usesPreciseCollisionDetection = true
        
        self.addChild(sprite)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func walkingAnimation() -> SKAction {
        // FIXME: Temporary
        return .rotate(byAngle: 1, duration: 0.5)
    }
    
    private func dyingAnimation() -> SKAction {
        // FIXME: Temporary
        return .fadeOut(withDuration: 0.3)
    }
    
    func spawn(at _point: CGPoint? = nil) {
        let point: CGPoint = _point ?? .randomInCircumference(ofRadius: 500)
        self.position = point
        self.run(.repeatForever(walkingAnimation()))
        
        // Walking to Center
        let distanceToCenter = sqrt(pow(self.position.x, 2) + pow(self.position.y, 2))
        let velocity: CGFloat = .random(in: 40...50)
        let timeToCenter = distanceToCenter/velocity
        let moveAction = SKAction.move(to: .zero, duration: timeToCenter)
        
//        self.addChild(sprite)
        self.run(moveAction)
    }
    
    func die() {
        self.sprite.run(.sequence([
            dyingAnimation(),
            .run {
                self.removeAllActions()
                self.removeAllChildren()
                self.removeFromParent()
            }
        ]))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let otherCategory = contact.bodyA.categoryBitMask == PhysicsCategory.Attack.rawValue ? contact.bodyA.categoryBitMask : contact.bodyB.categoryBitMask
        
        if otherCategory == PhysicsCategory.Attack.rawValue {
            self.die()
        }
        
    }
}
