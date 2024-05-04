//
//  GameViewController.swift
//  Academy-Jam
//
//  Created by Jaide Zardin on 04/05/24.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let scene = GameScene(size: .init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
               
            scene.scaleMode = .aspectFit
            scene.anchorPoint = .init(x: 0.5, y: 0.5)
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
