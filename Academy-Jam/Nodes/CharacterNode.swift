//
//  TestCharacterNode.swift
//  Academy-Jam
//
//  Created by Jaide Zardin on 05/05/24.
//

import Foundation
import SpriteKit

enum Directions: String{
    case up, down, left, right
}

enum States: String{
    case walking, attacking, watering, idle
}

class Gardener: SKNode {
    
    private var baseAnimTime = 0.2
    private var velocity: CGFloat = 12
    let sprite: SKSpriteNode
    var currentDirection: Directions = .right
    var currentState: States = .idle
    
    init(baseSprite: String){
        sprite = .init(imageNamed: baseSprite)
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
            let newTexture = "\(self.name!)_\(state.rawValue)_\(currentDirection.rawValue)"
            textures.append(.init(imageNamed: newTexture))
        }
        
        return .animate(with: textures, timePerFrame: baseAnimTime)
    }
    
    
    public func changeAnimation(state: States, direction: Directions){
        
        sprite.removeAllActions()
        
        setDirection(to: direction)
        setState(to: state)
        sprite.run(.repeatForever(getAnimation(state: state)))
    }
    
    public func walk(direction: Directions){
        changeAnimation(state: .walking, direction: direction)
        sprite.run(createMoveAnimation(direction: direction))
    }
    
    public func watering(){
        changeAnimation(state: .watering, direction: .down)
    }
    
    public func attacking(){
        changeAnimation(state: .attacking, direction: self.currentDirection)
    }
    
    public func idle(){
        changeAnimation(state: .idle, direction: self.currentDirection)
    }
    
}
