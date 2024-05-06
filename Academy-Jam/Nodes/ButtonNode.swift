//
//  ButtonNode.swift
//  Academy-Jam
//
//  Created by Jaide Zardin on 05/05/24.
//

import Foundation
import SpriteKit

class ButtonNode: SKNode {
    
    let sprite: SKSpriteNode
    
    var actionBegin: (() -> Void)?
    var actionEnd: (() -> Void)?
    
    init(name: String){
        self.sprite = .init(imageNamed: name)
        self.sprite.alpha = 0.6
        super.init()
        self.name = name
        
        isUserInteractionEnabled = true
        self.addChild(sprite)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setActionBegin(action: @escaping () -> Void) {
        actionBegin = action
    }
    
    public func setActionEnd(action: @escaping () -> Void) {
        actionEnd = action
    }
    
    public func toggleUserInteraction(to value: Bool? = nil) {
        isUserInteractionEnabled = value ?? !isUserInteractionEnabled
        if isUserInteractionEnabled {
            sprite.alpha = 0.6
        } else {
            sprite.alpha = 0.3
        }
    }
}

class PressButtonNode: ButtonNode {
    
    public var isBeingTouched: Bool = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isBeingTouched = true
        sprite.alpha = 0.8
        sprite.run(.scale(by: 11/10, duration: 0.1))
        self.actionBegin?()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isBeingTouched = false
        sprite.alpha = 0.6
        sprite.run(.scale(by: 10/11, duration: 0.1))
        self.actionEnd?()
    }
}

class ToggleButtonNode: ButtonNode {
    
    public var touched: Bool = true
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touched {
            touched.toggle()
            self.actionBegin?()
        } else {
            touched.toggle()
            self.actionEnd?()
        }
    }
    
}

class ActionButtonNode: ButtonNode {
    public var isOnAction: Bool = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOnAction {return}
        
        self.run(.sequence([
            .run {
                self.isOnAction = true
                self.sprite.alpha = 0.8
                self.sprite.run(.scale(by: 11/10, duration: 0.1))
                self.actionBegin?()
            },
            .wait(forDuration: 0.8),
            .run {
                self.isOnAction = false
                self.sprite.alpha = 0.6
                self.sprite.run(.scale(by: 10/11, duration: 0.1))
                self.actionEnd?()
            }
        ]))
    }
}
