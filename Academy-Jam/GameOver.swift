
import Foundation
import SpriteKit
import GameplayKit

class GameOver: SKScene {
    var gameOver: SKSpriteNode!
    
    func defeat(){
        // Configuração de Game Over
        gameOver = SKSpriteNode(imageNamed: "Asset DEFEAT")
        gameOver.position = CGPoint(x: 0, y: 0)
        gameOver.setScale(1)
        gameOver.texture?.filteringMode = .nearest
        
        self.addChild(self.gameOver)
    }
    
    func win(){
        // Configuração de Game Over
        gameOver = SKSpriteNode(imageNamed: "Asset WIN")
        gameOver.position = CGPoint(x: 0, y: 0)
        gameOver.setScale(1)
        gameOver.texture?.filteringMode = .nearest
        
        self.addChild(self.gameOver)
    }

}
