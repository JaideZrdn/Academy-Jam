//
//  GameScene.swift
//  Academy-Jam
//
//  Created by Jaide Zardin on 04/05/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var background: BackgroundNode?
    let flower: FlowerNode = .init()
    var monsters: Array<MonsterNode> = []
    var jardineiro = Gardener(baseSprite: "jardineiro")
    var buttonLeft = PressButtonNode(name: "left")
    var buttonRight = PressButtonNode(name: "right")
    var buttonUp = PressButtonNode(name: "up")
    var buttonDown = PressButtonNode(name: "down")
    var buttonWatering = PressButtonNode(name: "Botao regar")
    var buttonAttacking = ActionButtonNode(name: "Botao ataque")
    
    override func didMove(to view: SKView) {
        spawnMonsterCycle()
    }
    
    override func sceneDidLoad() {
        background = BackgroundNode(flower: flower)
        configButton()
        addChild(flower)
        addChild(jardineiro)
        addChild(background!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
        if touches.isEmpty {return}
        let touch = touches.first!
        
        for i in 0..<monsters.count {
            if monsters[i].contains(touch.location(in: self)) {
                monsters[i].die()
                monsters.remove(at: i)
                return
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if !flower.isTakingDamage {
            background?.updateBackground()
            for i in 0..<monsters.count {
                if flower.contains(monsters[i].position) {
                    flower.takeDamage()
                    background?.updateBackground()
                }
            }
        }
        if flower.sprite.contains(CGPoint(x: jardineiro.sprite.position.x, y: jardineiro.sprite.position.y+10)) {
            buttonWatering.toggleUserInteraction(to: true)
            print("ta dentro")
        } else {
            buttonWatering.toggleUserInteraction(to: false)
            print("ta fora")
        }
    
    }
    
    func spawnMonsterCycle() {
        let spawnAction: SKAction = .sequence([
            .run {
                if self.monsters.count < 15 {
                    self.addMonster()
                }
            },
            .wait(forDuration: .init(.random(in: 15...25)/10))
        ])
        
        self.run(.repeatForever(spawnAction))
    }
    
    private func addMonster() {
        let monster = MonsterNode(flower: flower)
        self.monsters.append(monster)
        monster.zPosition = 5
        monster.spawn()
        self.addChild(monster)
    }
    
    func configButton(){
        buttonUp.position = .init(x: -300, y: 0)
        buttonDown.position = .init(x: buttonUp.position.x, y: buttonUp.position.y-70)
        buttonLeft.position = .init(x: buttonUp.position.x-35, y: buttonUp.position.y-35)
        buttonRight.position = .init(x: buttonUp.position.x+35, y: buttonLeft.position.y)
        buttonWatering.position = .init(x: -180, y: 100)
        buttonAttacking.position = .init(x: 80, y: 0)
        
        buttonUp.zPosition = 10
        buttonDown.zPosition = 10
        buttonLeft.zPosition = 10
        buttonRight.zPosition = 10
        buttonWatering.zPosition = 10
        buttonAttacking.zPosition = 10
        
        buttonAttacking.setActionBegin {
            self.jardineiro.attacking(monsters: &self.monsters)
        }
        buttonAttacking.setActionEnd {
            self.jardineiro.idle()
        }
        
        buttonUp.setActionBegin {
            self.jardineiro.walk(direction: .up)
        }
        buttonUp.setActionEnd {
            self.jardineiro.idle()
        }
        
        buttonDown.setActionBegin {
            self.jardineiro.walk(direction: .down)
        }
        buttonDown.setActionEnd {
            self.jardineiro.idle()
        }
        
        buttonLeft.setActionBegin {
            self.jardineiro.walk(direction: .left)
        }
        buttonLeft.setActionEnd {
            self.jardineiro.idle()
        }
        
        buttonRight.setActionBegin {
            self.jardineiro.walk(direction: .right)
        }
        buttonRight.setActionEnd {
            self.jardineiro.idle()
        }
        
        buttonWatering.setActionBegin {
            self.jardineiro.watering(flower: self.flower)
        }
        buttonWatering.setActionEnd {
            self.jardineiro.idle()
        }
        
        self.addChild(buttonUp)
        self.addChild(buttonDown)
        self.addChild(buttonRight)
        self.addChild(buttonLeft)
        self.addChild(buttonWatering)
        self.addChild(buttonAttacking)
    }
}
