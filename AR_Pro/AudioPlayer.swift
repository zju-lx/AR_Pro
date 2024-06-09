//
//  AudioPlayer.swift
//  AR_Pro
//
//  Created by zjucvglab509 on 2024/6/9.
//

import Foundation
import SceneKit

class AudioPlayer {
    
    static func load(name: String) -> SCNAudioSource {
        let filePath = "\(name).m4a"
        let audioSource = SCNAudioSource(fileNamed: filePath)!
        audioSource.load()
        audioSource.volume = 1
        audioSource.isPositional = true
        audioSource.shouldStream = false
        return audioSource
    }
    
    static func play(source: SCNAudioSource, on: SCNNode) {
        let action = SCNAction.playAudio(source,
                                         waitForCompletion: false)
        on.runAction(action)
    }
}
