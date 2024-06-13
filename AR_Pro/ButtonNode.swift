//
//  ButtonNode.swift
//  AR_Pro
//
//  Created by zjucvglab509 on 2024/6/9.
//

import Foundation
import SceneKit
import ARKit

class ButtonNode: SCNNode {
    var track = 0;
    var hit = false;
    
    let hitMaterial = SCNMaterial()
    let normalMaterial = SCNMaterial()
    var balls: [BallNode] = []
    
    override init() {
        super.init()
    }
    
    init(track: Int) {
        super.init()
        
        let geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        hitMaterial.diffuse.contents = UIColor.black.withAlphaComponent(0.9)
        normalMaterial.diffuse.contents = UIColor.white.withAlphaComponent(0.9)
        geometry.materials = [normalMaterial]
        self.geometry = geometry
        self.track = track
        self.hit = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHit() {
        hit = true
        geometry?.materials = [hitMaterial]
    }
    
    func resetHit() {
        hit = false
        geometry?.materials = [normalMaterial]
    }
    
    func isHit() -> Bool {
        if (hit) {
            for _ in 0...10 {
                let bable = BallNode()
                bable.position = SCNVector3(0, 0, 0)
                let randomForce = SCNVector3(Float.random(in: -1...1), Float.random(in: -1...1), Float.random(in: -1...1))
                bable.physicsBody?.applyForce(randomForce, asImpulse: true)
                self.addChildNode(bable)
                balls.append(bable)
            }
        }
        for (index, ball) in balls.enumerated() {
            if ball.life <= 0 {
                ball.removeFromParentNode()
                balls.remove(at: index)
            } else {
                ball.life -= 1
            }
        }
        return hit
    }
    
    class BallNode : SCNNode {
        var life = 50
        override init() {
            super.init()
            let geometry = SCNSphere(radius: 0.01)
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.red
            geometry.materials = [material]
            self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
            self.geometry = geometry
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
