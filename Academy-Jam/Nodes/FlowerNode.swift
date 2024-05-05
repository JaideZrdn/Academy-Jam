//
//  FlowerNode.swift
//  Academy-Jam
//
//  Created by Eduardo Cordeiro da Camara on 04/05/24.
//

import Foundation
import SpriteKit

enum FlowerStates: String {
    case dead = "dead", sad, neutral, happy, veryHappy, flourished
    
    static func getAllValues() -> Array<FlowerStates> {
        return [.dead, .sad, .neutral, .happy, .veryHappy, .flourished]
    }
    
    mutating func levelUp() {
        let allValues = FlowerStates.getAllValues()
        if self == .flourished || self == .dead {return}
        
        guard let index = allValues.firstIndex(of: self) else {return}
        self = allValues[index + 1]
    }
    
    mutating func levelDown() {
        let allValues = FlowerStates.getAllValues()
        if self == .flourished || self == .dead {return}
        
        guard let index = allValues.firstIndex(of: self) else {return}
        self = allValues[index - 1]
    }

}

class FlowerNode: SKNode {
    let sprite: SKSpriteNode
    let healthLabel: SKLabelNode
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
    var state: FlowerStates
    
    override init() {
        self.sprite = .init(imageNamed: "flower_neutral")
        
//        self.greenArea =  .init(circleOfRadius: 1)
//        self.greenArea.fillColor = .green
//        self.greenArea.strokeColor = .clear
//        
        self.isTakingDamage = false
        self.isAlive = true
        
        self._health = 50
        self.healthLabel = .init(text: "50")
        self.healthLabel.position.y -= 40
        self.healthLabel.fontSize = 20
        self.healthLabel.color = .white
        self.healthLabel.zPosition = 10
        
        self.state = .neutral
        super.init()
        
        self.addChild(sprite)
        self.addChild(healthLabel)
//        self.addChild(greenArea)
        
        isUserInteractionEnabled = true
    }
    
    func takeDamage(damage: Int = 8) {
        if !isAlive {return}
        
        // Se o oldValue de health for no range pra ir prum novo nível depois de tomar damage, ativar o levelDown
        switch self.health {
        case 80..<(80+damage), 60..<(60+damage), 40..<(40+damage), 20..<(20+damage):
            self.state.levelDown()
            self.sprite.texture = .init(imageNamed: "flower_\(self.state.rawValue)")
        default:
            break
        }
        
        self.health -= damage
        self.healthLabel.text = "\(self.health)"
        if self.health == 0 {
            self.isAlive = false
        }
        
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
    
    func heal(amount: Int = 2) {
        if !isAlive {return}
        
        // Se o oldValue de health for no range pra ir prum novo nível depois de somar o amount, ativar o levelUp
        switch self.health {
        case (100-amount)..<100, (80-amount)..<80, (60-amount)..<60, (40-amount)..<40, (20-amount)..<20:
            self.state.levelUp()
            self.sprite.texture = .init(imageNamed: "flower_\(self.state.rawValue)")
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.heal()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
