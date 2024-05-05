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
//        sprite = .init(imageNamed: name)
        sprite = .init(color: .green, size: .init(width: 30, height: 30))
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
        
        self.actionBegin?()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isBeingTouched = false
        
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
