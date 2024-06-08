//
//  Player.swift
//  AR_Pro
//
//  Created by zjucvglab509 on 2024/6/7.
//

import Foundation
import SceneKit

class Player : SCNNode {
    var track = 0
    var player: SCNNode?
    
    override init() {
        super.init()
        
        let playerScene = SCNScene(named: "art.scnassets/player.scn")!
        let playerNode = playerScene.rootNode.childNode(withName: "player", recursively: true)!
        playerNode.removeFromParentNode()
        addChildNode(playerNode)
        player = playerNode
        updatePosition()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updatePosition() {
        var x_offset: Float = 0
        var y_offset: Float = 0
        var z_offset: Float = 0
        
        if track == 0 {
            x_offset = -0.15
        } else if track == 1 {
            x_offset = -0.05
        } else if track == 2 {
            x_offset = 0.05
        } else if track == 3 {
            x_offset = 0.15
        }
        
        y_offset = -0.4
        
        z_offset = 1.0
        
        let translation = SCNMatrix4MakeTranslation(x_offset, y_offset, z_offset)
        player!.transform = translation
    }
    
    func moveLeft() {
        if track > 0 {
            track -= 1
            let moveAction = SCNAction.move(by: SCNVector3(-0.1, 0, 0), duration: 0.1)
            player?.runAction(moveAction)
        }
        print("track = \(track)")
    }
    
    func moveRight() {
        if track < 3 {
            track += 1
            let moveAction = SCNAction.move(by: SCNVector3(0.1, 0, 0), duration: 0.1)
            player?.runAction(moveAction)
        }
        print("track = \(track)")
    }
    
    func jump() {
        let jumpAction = SCNAction.move(by: SCNVector3(0, 0, 0.2), duration: 0.1)
        player?.runAction(jumpAction)
    }
}
