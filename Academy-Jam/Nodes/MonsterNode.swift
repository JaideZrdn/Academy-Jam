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

class MonsterNode: SKNode {
    let sprite: SKSpriteNode
    let monsterType: Monsters
    
    init(ofType monster: Monsters? = nil) {
        // TODO: Later integrate assets
        self.monsterType = monster ?? .random()
        self.sprite = .init(imageNamed: "\(monsterType.rawValue) 1")
        
        
        super.init()
    }
    
    private func walkingAnimation() -> SKAction {
        // FIXME: Temporary
        return .rotate(byAngle: 30, duration: 0.5)
    }
    
    private func dyingAnimation() -> SKAction {
        // FIXME: Temporary
        return .fadeOut(withDuration: 1)
    }
    
    func spawn(at _point: CGPoint? = nil) {
        let point: CGPoint = _point ?? .randomInCircumference(ofRadius: 300)
        self.position = point
        self.run(.repeatForever(walkingAnimation()))
        let distanceToCenter = pow(self.position.x, 2)
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("tá maluco")
    }
}
