//
//  NoteNode.swift
//  AR_Pro
//
//  Created by zjucvglab509 on 2024/6/8.
//

import Foundation
import SceneKit
import ARKit

enum NoteNodeState: Int {
    case waiting = 0
    case moving
    case reached
}

class NoteNode: SCNNode {
    var song: Song?
    var note: Song.Note?
    var node: SCNNode?
    var state: NoteNodeState = .waiting
    let height: Float = 0.08
    let width: Float = 0.08
    var length: Float = 0.0
    
    override init() {
        super.init()
    }
    
    init(song: Song, note: Song.Note) {
        super.init()
        self.note = note
        self.song = song
        length = (Float(note.duration) / 4.0) * 1.0
        // 1 个单位长度对应 4 个节拍 根据长度和节拍数成正比的关系可以求出音符的长度
    }
    
    func activate() {
        let geometry = SCNBox(width: CGFloat(self.width), height: CGFloat(self.length), length: CGFloat(self.height), chamferRadius: 0.01)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red.withAlphaComponent(0.9)
        geometry.materials = [material]
        node = SCNNode(geometry: geometry)
        addChildNode(node!)
        
        localize()
        go()
    }
    
    private func go() {
        state = .moving
        let moveAction = SCNAction.move(by: SCNVector3(0, -(1.0 + self.length), 0), duration: getTime(length: 4 + self.note!.duration))
        // 移动距离：1.0（轨道长度）+ length（音符长度）
        // 移动时间：4（音符从一端滑动到另一端的时间）+ duration（音符持续的时间）
        node!.runAction(moveAction) {
            self.state = .reached
            self.node!.removeFromParentNode()
        }
    }
    
    private func getTime(length: Int) -> Double {
        let one = 60.0 / Double(self.song!.speed)
        return one * Double(length)
    }
    
    private func localize() {
        var x_offset: Float = 0
        var y_offset: Float = 0
        var z_offset: Float = 0
        
        if note!.track == 0 {
            x_offset = -0.15
        } else if note!.track == 1 {
            x_offset = -0.05
        } else if note!.track == 2 {
            x_offset = 0.05
        } else if note!.track == 3 {
            x_offset = 0.15
        }
        
        y_offset = 0.5 + self.length / 2
        
        z_offset = self.height / 2
        
        let translation = SCNMatrix4MakeTranslation(x_offset, y_offset, z_offset)
        node!.transform = translation
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
