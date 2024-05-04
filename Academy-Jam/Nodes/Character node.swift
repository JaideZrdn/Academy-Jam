//
//CharacterNode.swift
//Academy-Jam
//
//CreatedbyJaideZardinon04/05/24.
//



import Foundation

import SpriteKit

enum Directions: String{
    case foward, backward, left, right
}

enum States: String{
    case walking, attacking, watering, idle
}


class Character: SKNode{
    var currentDirection: Directions = .foward
    var sprite: SKSpriteNode
    var currentState: States = .idle
    let timeInterval = 0.2
    private var isMoving: Bool = false
    
    init (name:String) {
        sprite = .init(imageNamed:name)
        sprite.name = name
        super.init()
        self.name = name
        self.addChild(sprite)
        self.sprite.run(stateAnimation(estado: .idle))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func stateAnimation(estado: States) -> SKAction{
        var textures: [SKTexture] = []
        
        for index in 1...4{
            let newTexture = "\(self.name!))_\(estado.rawValue)_\(index)"
            textures.append(.init(imageNamed: newTexture))
        }
        return.animate(with: textures, timePerFrame: timeInterval)
    }
    
    public func walkingAnimation(direcao: Directions) -> SKAction{
        var textures: [SKTexture] = []
        
        for index in 1...4 {
            let newTexture = "\(self.name!)_\(direcao.rawValue)_\(index)"
            textures.append(.init(imageNamed: newTexture))
        }
        return.animate(with: textures,timePerFrame: timeInterval)
    }
    
    public func changeAnimation(state: States? = nil,direction: Directions? = nil){
        
        if isMoving {return}
        sprite.removeAllActions()
        if direction != nil{
            sprite.run(.repeatForever(walkingAnimation(direcao: direction!)))
            currentDirection = direction!
            currentState = .walking
            return
        }else{
            sprite.run(.repeatForever((stateAnimation(estado: state!))))
            currentState = state!
            return
        }
    }
    
    public func moveBy(direction: Directions){
        changeAnimation(direction: direction)
        isMoving = true
        
        var vector: CGVector{
            switch direction{
            case.foward:
                return.init(dx: 0,dy: 0.2)
            case.backward:
                return.init(dx: 0,dy: -0.2)
            case.left:
                return.init(dx: -0.2,dy: 0)
            case.right:
                return.init(dx: 0.2,dy: 0)
            }
        }
        
        self.run(.group([
            .move(by: vector,duration: 0.02),
            .sequence([
                .wait(forDuration: 0.02 + 0.01),
                .run{
                    self.isMoving.toggle()
                    self.changeAnimation(state: .idle)
                }
            ])
        ]))
    }
}
