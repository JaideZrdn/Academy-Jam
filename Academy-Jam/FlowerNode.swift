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
    
    private var _health: Int = 100
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
        super.init()
        
        self.addChild(sprite)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
