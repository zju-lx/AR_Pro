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
        return hit
    }
    
}
