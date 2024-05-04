//
//  GameScene.swift
//  Academy-Jam
//
//  Created by Jaide Zardin on 04/05/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        print("Did move")
    }
    
    override func sceneDidLoad() {

        let sprite = SKSpriteNode(color: .cyan, size: .init(width: 100, height: 100))
        sprite.position = .zero
        
        self.addChild(sprite)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.isEmpty {return}
        let touch = touches.first!
        let temp = SKSpriteNode(color: .blue, size: .init(width: 80, height: 80))
        temp.position = touch.location(in: self)
        print(touch.location(in: self))
        
        self.addChild(temp)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
    }
}
