//
//  BackgroundNode.swift
//  Academy-Jam
//
//  Created by Eduardo Cordeiro da Camara on 05/05/24.
//

import Foundation
import SpriteKit

class BackgroundNode: SKNode {
    
    var allTextures: Dictionary<MoodStates, SKTexture> = [:]
    
    let sprite: SKSpriteNode
    let helperSprite: SKSpriteNode
    var state: MoodStates
    
    override init() {
        self.sprite = .init(imageNamed: "background_neutral")
        self.helperSprite = .init(imageNamed: "background_neutral")
        self.state = .neutral
        super.init()
        
        sprite.zPosition = -1
        helperSprite.zPosition = -0.9
        
        helperSprite.alpha = 0
        configTextures()
        
        addChild(sprite)
        addChild(helperSprite)
    }
    
    func transitionUp() {
        self.state.levelUp()
        helperSprite.texture = allTextures[self.state]
        helperSprite.run(.fadeIn(withDuration: 1))
        self.run(.sequence([
            .wait(forDuration: 1.1),
            .run {
                self.sprite.texture = self.allTextures[self.state]
                self.helperSprite.alpha = 0
            }
        ]))
    }
    
    func transitionDown() {
        self.state.levelDown()
        helperSprite.texture = allTextures[self.state]
        helperSprite.run(.fadeIn(withDuration: 1))
        self.run(.sequence([
            .wait(forDuration: 1.1),
            .run {
                self.sprite.texture = self.allTextures[self.state]
                self.helperSprite.alpha = 0
            }
        ]))
    }
    
    func configTextures() {
        for state in MoodStates.getAllValues() {
            let texture: SKTexture = .init(imageNamed: "background_\(state.rawValue)")
            texture.filteringMode = .nearest
            allTextures[state] = texture
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
