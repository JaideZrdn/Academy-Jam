//
//  TestCharacterNode.swift
//  Academy-Jam
//
//  Created by Jaide Zardin on 05/05/24.
//

import Foundation
import SpriteKit

enum PhysicsCategory: UInt32 {
    case None = 0
    case Player = 1
    case Monster = 2
    case Attack = 4
    
}

enum Directions: String{
    case up = "up", down, left, right
}

enum States: String{
    case walking = "walking", atacking, watering, idle
}

class Gardener: SKNode {
    
    private var baseAnimTime = 0.2
    private var velocity: CGFloat = 12
    let sprite: SKSpriteNode
    var currentDirection: Directions = .right
    var currentState: States = .idle
    
    init(baseSprite: String){
        sprite = .init(imageNamed: baseSprite)
        sprite.setScale(0.5)
        sprite.texture?.filteringMode = .nearest

        sprite.name = baseSprite
        super.init()
        self.name = baseSprite
        self.addChild(sprite)
        changeAnimation(state: .idle, direction: .right)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createMoveAnimation(direction: Directions) -> SKAction{
        let vector: CGVector
        switch direction{
        case .up:
            vector = .init(dx: 0, dy: velocity)
        case .down:
            vector = .init(dx: 0, dy: -velocity)
        case .right:
            vector = .init(dx: velocity, dy: 0)
        case .left:
            vector = .init(dx: -velocity, dy: 0)
        }
        
        return .repeatForever(.move(by: vector, duration: 0.05))
    }
    
    func setDirection(to direction: Directions){
        self.currentDirection = direction
    }
    
    func setState(to state: States){
        self.currentState = state
    }
    
    func getAnimation(state: States) -> SKAction {
        var textures: [SKTexture] = []
        
        for index in 1...4 {
            let newTexture = SKTexture(imageNamed:"\(self.name!)_\(state.rawValue)_\(currentDirection.rawValue)_\(index)")
            newTexture.filteringMode = .nearest
            textures.append(newTexture)
        }
        
        return .animate(with: textures, timePerFrame: baseAnimTime)
    }
    
    
    public func changeAnimation(state: States, direction: Directions){
        
        self.removeAllActions()
        sprite.removeAllActions()
        
        setDirection(to: direction)
        setState(to: state)
        sprite.run(.repeatForever(getAnimation(state: state)))
    }
    
    public func walk(direction: Directions){
        changeAnimation(state: .walking, direction: direction)
        sprite.run(createMoveAnimation(direction: direction))
    }
    
    public func watering(flower: FlowerNode){
        changeAnimation(state: .watering, direction: .down)
        
        self.position = .init(x: flower.position.x, y: flower.position.y + 50)
        
        let cureAction = SKAction.sequence([.wait(forDuration: 3), .run {
            flower.heal(amount: 10)
        }])
        
        self.run(.repeatForever(cureAction))
    }
    
    public func attacking( monsters: inout [MonsterNode]){
        changeAnimation(state: .atacking, direction: self.currentDirection)
        var deslocVert: CGFloat = 0
        var deslocHor: CGFloat = 0
        
        switch currentDirection {
        case .up:
            deslocVert = +64
        case .down:
            deslocVert = -64
        case .left:
            deslocHor = -64
        case .right:
            deslocHor = 64
        }
        
        let attackNode = SKSpriteNode(color: .clear, size: .init(width: self.sprite.size.width*1.3, height: self.sprite.size.height*1.3))
        attackNode.position = .init(x: self.sprite.position.x + deslocHor, y: self.sprite.position.y + deslocVert)
        
        for index in 0..<monsters.count {
            if attackNode.contains(.init(x: monsters[index].position.x , y: monsters[index].position.y )) {
                monsters[index].die()
                monsters.remove(at: index)
                attackNode.removeFromParent()
                return
            }
        }
        attackNode.removeFromParent()
    }
    
    public func idle(){
        changeAnimation(state: .idle, direction: self.currentDirection)
    }
    
}
