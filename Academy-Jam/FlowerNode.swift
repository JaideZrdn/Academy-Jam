//
//  FlowerNode.swift
//  Academy-Jam
//
//  Created by Eduardo Cordeiro da Camara on 04/05/24.
//

import Foundation
import SpriteKit

class FlowerNode: SKNode {
    let sprite: SKSpriteNode
    
    public var isAlive: Bool
    private var _health: Int
    var health: Int {
        get {
            return self._health
        } set {
            if newValue > 100 {
                self._health = 100
            } else if newValue < 0 {
                self._health = 0
            } else {
                self._health = newValue
            }
        }
    }
    
    override init() {
        self.sprite = SKSpriteNode(color: .systemPink, size: .init(width: 30, height: 30))
        self.isAlive = true
        self._health = 100
        super.init()
        
        self.addChild(sprite)
    }
    
    func takeDamage(damage: Int = 8) {
        if !isAlive {return}
        
        self.health -= damage
        print("Health: \(self.health)")
        if self.health == 0 {
            self.isAlive = false
            self.sprite.color = .init(red: 0.3, green: 0, blue: 0, alpha: 1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
