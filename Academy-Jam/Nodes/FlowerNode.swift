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
//    let greenArea: SKShapeNode
    
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
        
        self.isAlive = true
        self._health = 50
        self.state = .neutral
        super.init()
        
        self.addChild(sprite)
//        self.addChild(greenArea)
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
        print("Health: \(self.health)")
        if self.health == 0 {
            self.isAlive = false
            self.sprite.color = .init(red: 0.3, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func heal(amount: Int = 2) {
        if !isAlive {return}
        
        // Se o oldValue de health for no range pra ir prum novo nível depois de somar o amount, ativar o levelUp
        switch self.health {
        case (100-amount)..<100, (80-amount)..<80, (60-amount)..<60, (40-amount)..<40, (20-amount)..<20:
            self.state.levelUp()
        default:
            break
        }
        
        self.health += amount
        print("Health: \(self.health)")
        
    }
    /*
    func enlargeGreenArea(by factor: CGFloat = 1.5, duration: CGFloat) {
        self.greenArea.run(.scale(by: factor, duration: duration))
//        // TODO: Nao sei como consertar
//        print("Radius: \(self.greenArea.path!)")
    }
     */
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
