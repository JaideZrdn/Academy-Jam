//
//  GameScene.swift
//  Academy-Jam
//
//  Created by Jaide Zardin on 04/05/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var monsters: Array<MonsterNode> = []
    
    override func didMove(to view: SKView) {
        //
        spawnMonsterCycle()
    }
    
    override func sceneDidLoad() {
        //
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       //
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
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
        let monster = MonsterNode()
        self.monsters.append(monster)
        monster.spawn()
        self.addChild(monster)
    }
}
