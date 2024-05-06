//
//  FlowerNode.swift
//  Academy-Jam
//
//  Created by Eduardo Cordeiro da Camara on 04/05/24.
//

import Foundation
import SpriteKit

enum MoodStates: String {
    case dead = "dead", sad, neutral, happy, veryHappy, flourished
    
    static func getAllValues() -> Array<MoodStates> {
        return [.dead, .sad, .neutral, .happy, .veryHappy, .flourished]
    }
    
    mutating func levelUp() {
        let allValues = MoodStates.getAllValues()
        if self == .flourished || self == .dead {return}
        
        guard let index = allValues.firstIndex(of: self) else {return}
        self = allValues[index + 1]
    }
    
    mutating func levelDown() {
        let allValues = MoodStates.getAllValues()
        if self == .flourished || self == .dead {return}
        
        guard let index = allValues.firstIndex(of: self) else {return}
        self = allValues[index - 1]
    }

}

//class FlowerNode: SKNode {
//    let sprite: SKSpriteNode
//    var state: MoodStates = .neutral
//    var index = 2
//    var flower: FlowerNode
//    
//    init(flower: FlowerNode) {
//        self.flower = flower
//        self.sprite = SKSpriteNode(imageNamed: "Background_2")
//        self.sprite.setScale(0.45)
//        super.init()
//        self.addChild(self.sprite)
//        self.zPosition = -500
//    }
//    
//    func updateBackground(){
//        let allMood = MoodStates.getAllValues()
//        index = allMood.firstIndex(of: flower.state)!
//        self.sprite.run(.setTexture(.init(imageNamed: "Background_\(index)")))
//    }
//    
//    
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}

class FlowerNode: SKNode {
    let sprite: SKSpriteNode
    let healthLabel: SKLabelNode
//    let background: BackgroundNode
//    let greenArea: SKShapeNode
    
    public var isTakingDamage: Bool
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
    var state: MoodStates
    
    override init() {
//        self.background = /*background*/
        self.sprite = .init(imageNamed: "flower_neutral_1")
        
//        self.greenArea =  .init(circleOfRadius: 1)
//        self.greenArea.fillColor = .green
//        self.greenArea.strokeColor = .clear
//        
        self.isTakingDamage = false
        self.isAlive = true
        
        self._health = 40
        self.healthLabel = .init(text: "40")
        self.healthLabel.position.y -= 40
        self.healthLabel.fontSize = 20
        self.healthLabel.color = .white
        self.healthLabel.zPosition = 10
        
        self.state = .neutral
        super.init()
        
        let scale = 50 / self.sprite.size.width
        self.sprite.setScale(scale)
        
        self.sprite.texture?.filteringMode = .nearest
        self.sprite.run(.repeatForever(getAnimation(ofState: self.state)))
        
        self.addChild(sprite)
        self.addChild(healthLabel)
//        self.addChild(greenArea)
        
        isUserInteractionEnabled = true
    }
    
    func takeDamage(background: BackgroundNode, damage: Int = 8) {
        if !isAlive {return}
        
        // Se o oldValue de health for no range pra ir prum novo nível depois de tomar damage, ativar o levelDown
        switch self.health {
        case 75..<(75+damage), 50..<(50+damage), 25..<(25+damage):
            self.sprite.removeAllActions()
            self.state.levelDown()
            background.transitionDown()
            self.sprite.run(.repeatForever(getAnimation(ofState: self.state)))
        case 0..<(0+damage):
            self.sprite.removeAllActions()
            self.isAlive = false
            let texture: SKTexture = .init(imageNamed: "flower_dead")
            
            self.sprite.texture?.filteringMode = .nearest
            
            
        default:
            break
        }
        
        self.health -= damage
        self.healthLabel.text = "\(self.health)"
        
        self.run(.sequence([
            .run {
                self.isTakingDamage = true
            },
            .wait(forDuration: 0.8),
            .run {
                self.isTakingDamage = false
            }
        ]))
    }
    
    func heal(background: BackgroundNode, amount: Int = 2) {
        if !isAlive {return}
        
        // Se o oldValue de health for no range pra ir prum novo nível depois de somar o amount, ativar o levelUp
        switch self.health {
        case (100-amount)..<100, (75-amount)..<75, (50-amount)..<50, (25-amount)..<25:
            self.sprite.removeAllActions()
            self.state.levelUp()
            background.transitionUp()
            self.sprite.run(.repeatForever(getAnimation(ofState: self.state)))
        default:
            break
        }
        
        self.health += amount
        self.healthLabel.text = "\(self.health)"
        
    }
    /*
    func enlargeGreenArea(by factor: CGFloat = 1.5, duration: CGFloat) {
        self.greenArea.run(.scale(by: factor, duration: duration))
//        // TODO: Nao sei como consertar
//        print("Radius: \(self.greenArea.path!)")
    }
     */
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.heal(background: background)
//    }
    
    private func getAnimation(ofState state: MoodStates) -> SKAction {
        var textures: Array<SKTexture> = []
        for i in 1...4 {
            let texture: SKTexture = .init(imageNamed: "flower_\(state.rawValue)_\(i)")
            texture.filteringMode = .nearest
            textures.append(texture)
        }
        return .animate(with: textures, timePerFrame: 1/4)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
