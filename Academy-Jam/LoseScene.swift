//
//  WinScene.swift
//  Academy-Jam
//
//  Created by Jaide Zardin on 05/05/24.
//

import Foundation
import SpriteKit

class LoseScene: SKScene {
    
    var botaoTryAgain = ActionButtonNode(name: "try again")
    
    override func didMove(to view: SKView) {
        addChild(botaoTryAgain)
        addChild(SKSpriteNode(imageNamed:"Gameover"))
        setupButtons()
    }
    
    func setupButtons(){

        
        botaoTryAgain.setActionBegin {
            let content = GameScene()
            self.transitionToScene(scene: content)
        }
        
        botaoTryAgain.zPosition = 100
    }
    
    func transitionToScene(scene: SKScene, transition: SKTransition? = nil){
        if let view = self.view{
            let sceneTo = scene
            sceneTo.scaleMode = .aspectFit
            view.presentScene(sceneTo, transition: transition!)
        }
    }
    
}
